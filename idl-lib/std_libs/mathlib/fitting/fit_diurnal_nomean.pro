function fit_diurnal_nomean, local, lwp, npoints, years, $
	Nc=Nc_in, period=period, min_years=min_years, meas_err=meas_err, $
	prior_err = prior_err, min_lambda=min_lambda

	; gather up all the same years

	if n_elements(nc_in) eq 0 then Nc_in = 1
	nc = nc_in
	if n_elements(period) eq 0 then period = 24.
	if n_elements(min_years) eq 0 then min_years = 4
	if n_elements(meas_err) eq 0 then meas_err = .045
	if n_elements(min_lambda) eq 0 then min_lambda = [25.,1.]
	dyears = different(years, z=ny, /old)
	Nmeas = n_elements(dyears)
	Nmax = max(ny)

	sdom = meas_err/ sqrt(npoints)
	ny = n_elements(lwp)

	; for later: now let us embed this is a higher dimensional thing.
	meanerr_squared = 1./total(1/sdom^2)
	mean_ = total(lwp / sdom^2) * meanerr_squared


	start_over:
	np = 2*nc

	p = fltarr(np, Nmeas)
	Kt_Syinv_y = fltarr(np, Nmeas)
	Sinv = fltarr(np, np, Nmeas)
	good = bytarr(Nmeas)
	Cinv = fltarr(nmax, nmax, nmeas)
	npoints_tot = 0L
	nused = 0
	Ktall = fltarr(ny, np)
	for m = 0, Nmeas-1 do begin
		w = where(years eq dyears[m], n)
		if n GT 1 then begin
			Cinv_ = fltarr(n,n)
			wgt = 1/sdom[w]^2
			norm = 1./total(wgt)
			lwpbar = total(lwp[w]*wgt) * norm
			for i = 0, n-1 do begin
				Cinv_[*,i] = -wgt * norm
				Cinv_[i,i] = 1. + Cinv_[i,i]
				Cinv_[*,i] = Cinv_[*,i] * wgt[i]
			endfor
			Cinv[0:n-1, 0:n-1, m] = Cinv_
			Kt = cosine_basis(local[w],period=period, N=Nc)
			Kt = Kt[*,1:*] ; remove fitting for the mean.
			Ktall[w, *] = Kt
			KtSyinv = Kt ## Cinv_
			Sinv[*,*,m] = KtSyinv ## transpose(Kt)
			Kt_Syinv_y[*,m] = transpose(KtSyinv ## transpose(lwp[w]))
			good[m] = 1
			npoints_tot = npoints_tot + npoints[m]
			nused = nused + n
			lwp[w] = lwp[w] - lwpbar
		endif
	endfor

	w = where(good, ng)

	diurnal = create_struct(['FIT','CS','NBINS','NPOINTS','MINLAMBDA','NC','MEAN','DOS','COVAR'], $
				name = 'LWP_DIURNAL_FIT' + sc(nc) + '_COVAR', $
				fltarr(np+1)-1., 0., 0b, 0, 0., 0b, 0., 0., fltarr((np+1)*(np+2)/2)	)


	if ng GT min_years then begin

		Sinv = Sinv[*,*,w]
		Kt_Syinv_y = Kt_Syinv_y[*,w]
		; now add up the contributions from each measurement
		Sfinv = symmetrize(total(Sinv, 3))
		lambda = eigeninv(Sfinv, inverse=Sf) ; this had better exist!!!
		print, 1000*sqrt(1./lambda) ; these are the errors on lin combos of fit params
		if keyword_set(prior_err) then begin
			lambda = sqrt(lambda) * prior_err
			if min(lambda) LT min_lambda[0] AND nc eq 2 then begin
				nc = 1
				goto, start_over
			endif
			if min(lambda) LT min_lambda[1] AND nc eq 1 then return, diurnal
			dos = total(lambda^2 / (1+lambda^2))

		endif

		P = Sf # total(Kt_Syinv_y,2)

		; try to get the chi-squared
		cs= 0.
		for m = 0, Nmeas-1 do begin
			w = where(years eq dyears[m], n)
			if n eq 0 then continue
			dy = lwp[w] - Ktall[w,*] # p
			cs = cs + dy ## (Cinv[0:n-1, 0:n-1, m] ## transpose(dy))
		endfor
		cs = cs[0] / (nused-np-ng)

		lwp = lwp + mean_
		covar = fltarr(np+1, np+1)
		covar[0,0] = meanerr_squared
		covar[1:np,1:np] = Sf
		P = [mean_, P]

		; now convert to other basis
		convert_diurnal_fit, P, covar, /over
		covar = compress_symmetric(covar)

		diurnal.mean = mean_
		diurnal.covar = covar
		diurnal.fit = P
		diurnal.nbins = nused
		diurnal.npoints = npoints_tot
		diurnal.nc = nc
		diurnal.cs = cs
		if keyword_set(prior_err) then begin
			diurnal.minlambda = min(lambda)
			diurnal.dos = dos
		endif

	endif

	return, diurnal


END


