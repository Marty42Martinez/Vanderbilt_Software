function fit_linear, y, x, functname, meas_err = meas_err, weights=weights, yfit=yfit, $
			double=double, improve = improve, _extra = _extra, basis=basis, $
			errors = errors, covar=covar, chisq=chisq

; Uses direct matrix solution to fit a model that is linear in its parameters
; to a data vector.  Can do multiple fits simultaneously, provided the
; independent vector (x) is the same every time.  The x-vector does
; not have to be sorted, or have evenly spaced samples.

; y : The data.  Note : this may be 2D (n, npix)
; x : [OPTIONAL] The independent points.  This must be 1D (n) !
; functname : [OPTIONAL] The function that creates the basis.  Only used if basis
;			keyword not set.

; yfit : the best-fit values of y
; meas_err : the 1-sigma error values. 1D
; weights : set this optional keyword to a (1D) vector of weights.
; 			for guassian errors, the weight proportional to 1/sigma^2, where
; 			sigma is the 1-sigma error.  Weights will be automatically normalized.
;			This keyword is ignored if meas_err is set.
; improve : set this to use LA_CHOLMPROVE to somehow improve the solution vectors
;			found by LA_CHOLSOL.
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


	; create the weights vectors

	sw = size(weights)
	if sw[0] eq 2 then begin
		; measurement error or weights are 2 dimensional!!!
		P = fit_linear2(y, x, functname, meas_err = meas_err, weights=weights, yfit=yfit, $
			double=double, improve = improve, _extra = _extra, basis=basis, $
			errors = errors, covar=covar, chisq=chisq)
	endif else begin
		; measurement error or weights are 1 dimensional!!!

	sd = size(y)
	n = sd[1]
	if n_elements(meas_err) eq n then weights = 1./meas_err^2
	if sd[0] eq 1 then npix = 1 else npix = sd[2]
	if n_elements(x) eq 0 then x = findgen(n)

	; the basis is basically the K-matrix in optimal estimation.
	if n_elements(basis) eq 0 then basis = CALL_FUNCTION(functname, x, _extra = _extra)
	np = n_elements(basis[0,*])




	if n_elements(weights) eq 0 then weights = y[*,0] * 0.d + 1.d
	; weight is currently a vector.  normalize it.
	c = 1./total(weights) ; normalizing factor
	; now turn it into a 2D thing
	weight = c * weights
	w = weight # (dblarr(npix) + 1.d)


	; create the "A" matrix in AX = B
	A = make_array(np, np, type = 4 + keyword_set(double))
	for i = 0, np-1 do begin
	for j = i, np-1 do begin
		A[i,j] = total( weight * basis[*,i] * basis[*,j])
		if i ne j then A[j,i] = A[i,j]
	endfor
	endfor

	; create the "B" vector in AX = B, created by hitting y with each basis vector.
	yvec = transpose(y * w) # basis

	if np GT 1 then begin
	  ; now let us use the Choleski Decomposition Method!
  		Ach = A
		LA_CHOLDC, Ach, double=double, status=status ; get the choleski factorization
		if status ne 0 then begin
			print, 'Problem with Choleski Factorization of A!'
			print, 'The leading minor eigenvalue is : ', status
			print, 'The eigenvalues of A are: '
			print, eigen(A)
			print, 'Quitting...'
			STOP
		endif

		P = LA_CHOLSOL(Ach, yvec, double=double) ; initial solution vector
		if keyword_set(improve) then P = LA_CHOLMPROVE(A, Ach, yvec, P, double=double)

		P = transpose(P)
	endif else begin
		P = 1./A * yvec
	endelse

	yfit = basis # P ; get the best-fit y values

	if keyword_set(errors) then begin
		; user wants us to calculate the covariance!
		covar = c * invert_symmetric(A)
	endif

	if n_elements(meas_err) eq n then begin
		me = meas_err # (fltarr(npix) + 1.)
		chisq = total( (y-yfit)^2/meas_err^2, 1 ) / (n-np)
	endif

	endelse

	return, P


END