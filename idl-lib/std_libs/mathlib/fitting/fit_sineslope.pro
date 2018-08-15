function fit_sineslope, y, t, yfit=yfit, period=period, double=double,  N=N, $
	improve=improve, weights=weights, errors=errors, covar=covar, meas_err=meas_err, $
	chisq = chisq

; t : array of times (indep var) - 1D (Nt)
; y : The data.  Note : this may be 2D (Nt, npix)
; N : the # of sinusoidal harmonics (default = 1)
; period : the period of the sinusoid in units of t
; weights : the weight for each data point.
	if n_elements(period) eq 0 then period = 12.0
	if n_elements(N) eq 0 then N = 1
	npix = n_elements(y[0,*])
	P = fit_linear(y, t, 'sineslope_basis', N=N, yfit=yfit, weights=weights, $
				double=double, improve = improve, period=period, $
				errors=errors, covar=S, meas_err=meas_err, chisq=chisq)

	; now convert P into amplitudes and phase offsets in units of time.
	; Y = p[0] + p[1]*t + p[2]*cosw(t-p[3]) [ + p[4]*cosw(2*(t-p[5])) + ... ]

	if keyword_set(errors) then begin
		np = 2 + 2*N
		covar = fltarr(np,np, npix)
		K = covar ; the K-matrix of the conversion
		K[0,0,*] = 1.0
		K[1,1,*] = 1.0
	endif

	for i = 1, N do begin
		amp = sqrt(p[2*i,*]^2 + p[2*i+1,*]^2)
		t0 = atan(p[2*i,*],p[2*i+1,*]) * period / (2*!pi)
		if keyword_set(errors) then begin
			K[2*i, 2*i,*] = p[2*i-1,*] / amp
			K[2*i+1, 2*i, *] = p[2*i,*] / amp
			K[2*i, 2*i+1, *] = p[2*i,*] / amp^2 * period/(2*!pi*i)
			K[2*i+1, 2*i+1, *] = -p[2*i-1] / p[2*i+1, *] * K[2*i, 2*i+1, *]
		endif
		p[2*i,*] = amp
		p[2*i+1,*] = t0
	endfor

	if keyword_set(errors) then begin
		; now must convert the covariance matrix to the new basis.
		ss = size(S)
		for i = 0, npix-1 do begin
			if ss[0] eq 2 then covar[*,*,i] = K[*,*,i] ## (S ## transpose(K[*,*,i])) $
				else covar[*,*,i] = K[*,*,i] ## (S[*,*,i] ## transpose(K[*,*,i]))
		endfor
	endif


	return, P

end