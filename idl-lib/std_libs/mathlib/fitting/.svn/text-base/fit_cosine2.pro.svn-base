function fit_cosine2, y, t, yfit=yfit, period=period, $
	double=double,  Nc=Nc, weights=weights, $
	covar=covar, meas_err = meas_err, prior_err = prior_err, $
	lambda=lambda, xa=xa, Sa=Sa, noconvert=noconvert

; t : array of times (indep var) - 1D (Nt)
; y : The data.  (Nt)
; N : the # of sinusoidal harmonics (default = 1)
; period : the period of the sinusoid in units of t
; weights : the weight for each data point.
; meas_err : the measurement error on each y data point (scalar or vector)
; 			 in this case, weight propto 1/meas_err^2
; covar : the output covariance matrix.  Requires meas_err to be set in order to make any sense.
; xa : prior knowledge of the fit solution (in original sin+cos system)
; Sa : prior knowledge covariance matrix (in original sin+cos system)



	if n_elements(period) eq 0 then period = 12.0
	if n_elements(Nc) eq 0 then N = 1 else N = Nc

	; * PERFORM INITIAL FIT
	;-------------------------------------------------------------------------
	Kt = cosine_basis(t,period=period, N=N)
	np = n_elements(Kt[0,*]) ; # of fitting parameters
	ny = n_elements(y)

	; create the weights vectors
	if n_elements(meas_err) GT 0 then weights = 1./meas_err^2 + y*0.
	if n_elements(weights) eq 0 then weights = y * 0.d + 1.d
	; weight is currently a vector.  normalize it.
	c = 1./total(weights) ; normalizing factor
	; now turn it into a 2D thing
	weight = c * weights

	if keyword_set(prior_err) then begin
		; We'll evaluate the eigenvalues of Kt' ## K'
		; where K' = Sy^-1/2 ## K ## Sa^1/2
		Ktwiddle = transpose(Kt)
		for i = 0, np-1 do Ktwiddle[i,*] = Ktwiddle[i,*] / meas_err
		Ktwiddle = Ktwiddle * prior_err
		lambda = eigen( transpose(Ktwiddle) ## Ktwiddle )
	endif

	; Prior Knowledge (if any)
	if n_elements(Sa) eq (np*np) then Sainv= c * invert_symmetric(Sa) else Sainv = fltarr(np,np)
	if n_elements(xa) lt np then xa = fltarr(np)

	KtSyinv = Kt
	for i = 0, np-1 do KtSyinv[*,i] = weight * Kt[*,i]

	S = invert_symmetric(KtSyinv ## transpose(Kt) + Sainv) ; get the output covariance matrix

	p = transpose(S ## (KtSyinv ## transpose(y) + Sainv ## transpose(xa)))
	S = S * c ; get output covariance matrix back into correct units
	yfit = Kt # p ; best-fit y values
	if n_elements(meas_err) eq 0 then S = S * total( (y-yfit)^2 ) ; when no meas errors, assume chisq=1

	; now convert P into amplitudes and phase offsets in units of time.
	; Y = p[0] + p[1]*cosw(t-p[2]) + p[3]*cosw(t-p[4]) + ...
	if ~keyword_set(noconvert) then begin
    	K = fltarr(np,np) ; Kmatrix of the conversion
	    K[0,0] = 1
		for i = 1, N do begin
			amp = sqrt(p[2*i-1]^2 + p[2*i]^2)
			t0 = atan(p[2*i-1],p[2*i]) * period / (2*!pi*i)
			K[2*i-1, 2*i-1] = p[2*i-1] / amp
			K[2*i, 2*i-1] = p[2*i] / amp
			K[2*i-1, 2*i] = p[2*i] / amp^2 * period/(2*!pi*i)
			K[2*i, 2*i] = -p[2*i-1] / p[2*i] * K[2*i-1, 2*i]

			p[2*i-1] = amp
			p[2*i] = t0
		endfor
		covar = K ## (S ## transpose(K) )
	endif else begin
		covar = S
	endelse

	return, P

end
