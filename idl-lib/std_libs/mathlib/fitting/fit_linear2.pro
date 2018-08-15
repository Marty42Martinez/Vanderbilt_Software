function fit_linear2, y, x, functname, meas_err = meas_err, weights=weights, yfit=yfit, $
			double=double, improve = improve, _extra = _extra, basis=basis, $
			errors = errors, covar=covar, chisq=chisq

; Uses direct matrix solution to fit a model that is linear in its parameters
; to a data vector.  Can do multiple fits simultaneously, provided the
; independent vector (x) is the same every time.  The x-vector does
; not have to be sorted, or have evenly spaced samples.
; this version allows for a 2D version of the weights or measurement errors.
;  it is therefore slower than the other version,having to calculate npix matrix inversions
;  instead of just one.

; y : The data.  Note : this may be 2D (n, npix)
; x : [OPTIONAL] The independent points.  This must be 1D (n) !
; functname : [OPTIONAL] The function that creates the basis.  Only used if basis
;			keyword not set.

; yfit : the best-fit values of y
; meas_err : the 1-sigma error values. 2D
; weights : set this optional keyword to a (2D) vector of weights.
; 			for guassian errors, the weight proportional to 1/sigma^2, where
; 			sigma is the 1-sigma error.  Weights will be automatically normalized.
;			This keyword is ignored if meas_err is set.

; basis : the basis to fit to.  Must be (Nx,Np) where Np=# parameters.
;		  If used, then functname is ignored.

; _extra : keywords to be passed to the user-supplied function

; MODEL :
; f(x) = P[0] * f0(x) + P[1] * f1(x) + P[2]*f2(x) + ...
;
; 	This must be contained in a user-named function.  The fj(x) are
;		the "basis vectors". The function must take an input vector (x),
;		and return ALL the basis vectors for that input vector (each
;		a different row).  Keywords can be passed through _extra.



	sd = size(y)
	n = sd[1]
	if sd[0] eq 1 then npix = 1 else npix = sd[2]
	if n_elements(x) eq 0 then x = findgen(n)

	; the basis is basically the K-matrix in optimal estimation.
	if n_elements(basis) eq 0 then basis = CALL_FUNCTION(functname, x, _extra = _extra)
	np = n_elements(basis[0,*])

	; create the weights vectors
	if n_elements(meas_err) eq n then weights = 1./meas_err^2
	if n_elements(weights) eq 0 then weights = y * 0.d + 1.d
	; now I must normalize the weights
	c = 1./total(weights, 1)
	w = c * weights

	if keyword_set(double) then e = dblarr(npix)+1. else e = fltarr(npix)+1.

	; create the "A" matrix in AX = B
	A = make_array(np, np, npix, type = 4 + keyword_set(double))
	for i = 0, np-1 do begin
	for j = i, np-1 do begin
		v = basis[*,i] * basis[*,j] # e
		A[i,j,*] = total(v * w, 1)
		if i ne j then A[j,i,*] = A[i,j,*]
	endfor
	endfor
	; A2 is np,np, and is tranpose(K) K.
	; Create A (np,np,npix) which is tranpose(K) K Syinv.

	; create the "B" vector in Ax = b, created by hitting y with each basis vector.
	b = make_array(np, npix, type=4+keyword_set(double))
	for i = 0, np-1 do begin
		v = basis[*,i] # e
		b[i,*] = total(v * w * y,1)
	endfor

	P = b * 0.
	if np GT 1 then begin
		; because we have potentially many pixels, we must use
		; a faster method than repeated choleski decomposition.
		; many fits have 3 or fewer parameters, so we'll try invert_symmetric.
		S = invert_symmetric(A)
		for i = 0, np-1 do p[i,*] = p[i,*] + total( reform(S[*,i,*]) * b, 1 )

		if keyword_set(errors) then begin
			covar = S
			for i = 0, npix-1 do covar[*,*,i] = S[*,*,i] * c[i]
		endif
	endif else begin
		S = reform(1./A)
		p[0,*] = S * reform(b)
		if keyword_set(errors) then covar = S * c
	endelse

	yfit = basis # P ; get the best-fit y values

	if n_elements(meas_err) GT 0 then begin
		chisq = total( (y-yfit)^2/meas_err^2, 1 ) / (n-np)
	endif


	return, P

END