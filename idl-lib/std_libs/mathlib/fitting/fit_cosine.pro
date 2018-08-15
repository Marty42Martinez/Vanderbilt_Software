function cosine_basis, t, period=period, N = N
	; t : array of times
	; Period = the period, in units of t, of the sinusoid.
	; fitting function is y(t) = P0 + P1 sin(wt) + P2 cos(wt) + p3 sin(2wt) + p4 cos(2wt) + ...
	; the number of harmonics to keep is N (default is 1)

	if n_elements(period) eq 0 then period=12. ; default period
	if n_elements(N) eq 0 then N = 1
	Nt = n_elements(t)
	if size(t, /type) eq 5 then begin
		twopi = 2.0d * !dpi
		one = 1.0d
		out = dblarr(Nt,1+2*N)
	endif else begin
		twopi = 2.0*!pi
		one = 1.0
		out = fltarr(Nt,1+2*N)
	endelse
	omega = twopi / period

	out[*,0] = one
	for i = 1, N do begin
		out[*,2*i-1] = sin(i*omega*t)
		out[*,2*i] = cos(i*omega*t)
	endfor

	return, out

END

function fit_cosine, y, t, yfit=yfit, period=period, $
	double=double,  N=N, improve=improve, weights=weights, $
	errors=errors, covar=covar, meas_err = meas_err

; t : array of times (indep var) - 1D (Nt)
; y : The data.  Note : this may be 2D (Nt, npix)
; N : the # of sinusoidal harmonics (default = 1)
; period : the period of the sinusoid in units of t
; weights : the weight for each data point.
	if n_elements(period) eq 0 then period = 12.0
	if n_elements(N) eq 0 then N = 1
	P = fit_linear(y, t, 'cosine_basis', N=N, yfit=yfit, weights=weights, meas_err = meas_err, $
				double=double, improve = improve, period=period, errors=errors, $
				covar=S)

	; now convert P into amplitudes and phase offsets in units of time.
	; Y = p[0] + p[1]*cosw(t-p[2]) + p[3]*cosw(t-p[4]) + ...

	npix = n_elements(y[0,*])
	np = n_elements(p[*,0])
	if keyword_set(errors) then begin
		covar = fltarr(np,np, npix)
		K = covar ; the K-matrix of the conversion
		K[0,0,*] = 1.0
	endif

	for i = 1, N do begin
		amp = sqrt(p[2*i-1,*]^2 + p[2*i,*]^2)
		t0 = atan(p[2*i-1,*],p[2*i,*]) * period / (2*!pi*i)
		if keyword_set(errors) then begin
			K[2*i-1, 2*i-1,*] = p[2*i-1,*] / amp
			K[2*i, 2*i-1, *] = p[2*i,*] / amp
			K[2*i-1, 2*i, *] = p[2*i,*] / amp^2 * period/(2*!pi*i)
			K[2*i, 2*i, *] = -p[2*i-1] / p[2*i, *] * K[2*i-1, 2*i, *]
		endif

		p[2*i-1,*] = amp
		p[2*i,*] = t0
	endfor



	if keyword_set(errors) then begin
		; now must convert the covariance matrix to the new basis.
		for i = 0, npix-1 do begin
			covar[*,*,i] = K[*,*,i] ## (S ## transpose(K[*,*,i]))
		endfor
	endif

	return, P

end