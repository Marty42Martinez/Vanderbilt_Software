function fit_nonlinear, y, funct_name, p_fg, x, $             ; input variables
            meas_err = meas_err, Sy=Sy, $                     ; input keywords
            min_iter=min_iter, max_iter=max_iter, $           ; input keywords
            max_chisq = max_chisq, tol=tol, limits=limits, $  ; input keywords
            Sa = Sa, apriori =apriori, special=special, $     ; input keywords
            autoderivative=autoderivative, verbose=verbose, $ ; input keywords
            perturbation=perturbation, _extra=_extra,       $ ; input keywords
            success=success, jacobian=jacobian, yfit=yfit, $  ; output keywords
            iter=iter ,covar=covar, chisq=chisq,quiet=quiet,path=path               ; output keywords
; PURPOSE
; ---------
; Uses Newton's iterative method to fit a model that is not linear in its parameters
; to a data vector.  Can do multiple fits simultaneously.
;
;
; HOW IT WORKS
; --------------
; See Rodgers book for details. "Inverse Methods for Atmospheric Sounding", Clive Rodgers, 2000.
;
; Start with a first guess state vector (called "p_fg")
; At this value of the state vector ("p"), calculate the jacobian matrix "K" as defined in Rodgers.
; K can either be calculated by the forward model or by using numerical forward
; differencing. Update the value of p using the following equation:
;
; p(i+1) = p(i) + (K^t Sy^-1 K + Sa^-1)^-1 (K^t Sy^-1 (y - f(p(i))) + Sa^-1 (p_a - p(i)))
;
; where i is the iteration number, p_a is the a-priori information, and all other variables
; are as in Rodgers.  Keep doing this until the chi-squared converges to a minimum value.
; The chi-squared is for Gaussian errors is defined as:
; chisq = (y-f(p))^t Sy^-1 (y-f(p)) + (p_a - p)^t Sa^-1 (p_a - p)

; Convergence occurs when either of the following conditions is met:
;   * The absolute value of the fractional change in the chi-squared between
;     iterations is less than TOL (default = 0.01 or 1%).
;   * The value of the chi-squared is less than MAX_CHISQ (default 0.3)
;
; Note that convergence occurs separately for each pixel, and thus on subsequent iterations,
; only those pixels that have not yet converged are iterated.  This is what makes
; this routine fast (that and the vectorization of the formulae in general).

; The returned values of p, yfit, jacobian, covar, and chisq correspond to the iteration with the
; smallest value of the chi-squared.  Note that this may not occur on the final iteration,
; as some iterations can make the chi-squared worse (usually only for highly nonlinear problems).

; VARIABLE DESCRIPTIONS:
; -------------------------
; General definitions used below:
; m    : number of points in observation space
; n    : number of points in state space (# retrieved parameters)
; npix : number of pixels or profiles
;
; INPUT VARIABLES
; y             : The observations.  May be a 1D vector (n) or 2D (n,npix).
; funct_name    : The user-defined function name.  Its form is specified below.
; p_fg          : First guess values for the parameters. 1D (n) or 2D (n,npix). REQUIRED!!
; x             : [optional] The independent points (like frequency or channel number).
;                 This MUST be 1D (n).

; RETURN VALUE  : Best-fit parameter values (n, npix).

; INPUT KEYWORDS:
; meas_err      : The 1-sigma error values. 1D (m) or 2D (m,npix).
;		          Not used if Sy has been set.
; Sy            : The measurement covariance matrix.  2D (m,m) or 3D (m,m,npix).
; _extra        : Keywords to be passed to the user-supplied function.
; autoderivative: If set, derivatives for the jacobian matrix will be calculated
;                 numerically with forward-differencing.
; tol           : Set this to the maximum percentage change in the chi-squared for iteration to stop.
; max_chisq     : Set this to the maximum chi-squared for iteration to stop.
; min_iter      : Minimum number of iterations to perform.
; max_iter      : Maximum number of iterations to perform.
; verbose       : Turns on verbose output.
; apriori       : Vector (n) of a-priori state of control vector (called x_a by Rodgers).
;                 Currently, must be the same for all pixels.
; Sa            : If a vector, interpreted as the 1-sigma (uncorrelated) error bars on the apriori.
;                 If a matrix, interpreted as the error covariance matrix on the apriori.
; special       : Index of pixel to print out on each iteration.  If not set, the pixel
;                 with the highest value of the chi-squared is printed for that iteration.
; perturbation  : Optional state vector perturbations if forward-differencing is used to calculate
;                 K.  Forward differencing occurs either if AUTODERIVATIVE is set or if the DERIV
;                 keyword in FUNCT_NAME returns nothing.  If not set, the default perturbation
;                 is 0.001 of the current parameter value.  May be 1D (n) or 2D (n,npix).
; limits		: Array of [min(p0), max(p0), min(p1), max(p1), ...] for parameters p0, p1, etc.
;				  Thus, the parameter values cannot go outside a prescribed range.

; OUTPUT KEYWORDS:
; yfit          : The best-fit values of y (m,npix)
; chisq         : Contains the final value of the total (a-priori plus measurement) chi-squared (npix).
; iter          : Number of iterations used for each pixel (npix)
; jacobian      : K-matrix (or senstivity matrix) for the last iteration for each pixel. (n,m,npix)
; success       : Vector specifying convergence status for each pixel. 0=failure, 1=success. (npix)
; covar         : Error covariance matrix of the best-fit parameters (n,n,npix)

; USER-SPECIFIED FUNCTION (aka "The Forward Model").
; --------------------------------------------------
; For each pixel, takes the state vector (p) as input and returns
; a vector of observations corresponding to that state.
; If you want FIT_NONLINEAR to work in vector form, this function
; must be able to accept vectorized input for p and x as specified below.
;
; f(x) = funct_name(p, x, deriv=deriv, _extra=_extra), same space as y.
; OR
; f(x) = funct_name(p, deriv=deriv, _extra=_extra)
; where
;	p     : Vector of parameters, (n) or (n,npix)
;   x     : Optional vector of indepedent data (like channel number), (m) or (m,mpix)
;   deriv : Output jacobian, (n,m,npix). Function MUST accept this keyword, though it need not
;		    do anything with it.  If nothing is returned in this keyword, numerical
;           derivatives will be calculated.
;   _extra: Represents any extra keyword information that can be passed to the function.
;   return value : Observations corresponding to the state(s) p.  Has dimensionality (m, npix).

; REQUIRED AUXILIARY FUNCTIONS:
; --------------------------------
; * INVERT_SYMMETRIC (itself requires INVERTSPD and EIGEN)

; MODIFICATION HISTORY:
; ------------------------
; Written by Chris O'Dell, January 2006 at ECMWF.
;
; March 2006, CWO   :   Bug fixes, added some keywords (jacobian and limits), updated header & comments.
;
;
;


    if n_elements(tol) eq 0 then tol = 0.01
	if n_elements(max_chisq) eq 0 then max_chisq = 0.3
	if n_elements(max_iter) eq 0 then max_iter = 10
	if n_elements(min_iter) eq 0 then min_iter = 1

; Set up first guess, measurement covariance matrix & inverse
	sizey = size(y)
	m = sizey[1]
	if sizey[0] eq 1 then npix = 1 else npix = sizey[2]
	sizex = size(x)
    if n_elements(x) ne 0 then begin
	   if n_elements(x) ne m then begin
		   print, 'Wrong # of elements in x (ind data) vector in FIT_NONLINEAR'
		   stop
	   endif
	endif
	use_x = n_elements(x) GT 0


	p = p_fg
	sizep = size(p)
	n = sizep[1]
	if sizep[0] eq 1 AND npix GT 1 then p = p # (fltarr(npix) + 1.)
	; p currently holds the first guess
	if n_elements(special) eq 0 then special = -1
	prior = 0
	Sainv = fltarr(n,n)
	if (size(apriori))[1] eq n then begin
		prior = 1
		pa = apriori ; assume same for all pixels!! (for now)
		if n_elements(Sa) eq 0 then begin
			for i = 0l, n-1 do Sainv[i,i] = 0.05 * p[i,0] ; give a 5% assumed error (highly constrained) by default
		endif else begin
			if n_elements(Sa) eq n then begin
				for i =0l, n-1 do Sainv[i,i] = 1./Sa[i]^2
			endif else Sainv = invert_symmetric(Sa)
		endelse
	endif
    
    path=p_fg

	no_errors = 0
	if n_elements(Sy) eq 0 then begin
		if n_elements(meas_err) eq 0 then no_errors=1 else begin
			Syinv = fltarr(m,m,npix)
			sizem = size(meas_err)
			for i = 0l, m-1 do Syinv[i,i,*] = 1./meas_err[i,*]^2
		endelse
	endif else begin
		if n_elements(size(sy, /dim)) eq 2 AND npix GT 1 then begin
			Syinv = fltarr(m,m,npix)
			temp = invert_symmetric(Sy) ; invert the input error covariance matrix
			for i = 0l, npix-1 do Syinv[*,*,i] = temp
		endif else Syinv = invert_symmetric(Sy)
	endelse

	if npix eq 0 then w = 0 else w = lindgen(npix)
	nw = npix
	chisq = fltarr(npix) + 99999999. ; initial chi-squared
	covar = fltarr(n,n,npix) ; will hold output covariance matrix
	iteration = 0
	if keyword_set(verbose) then begin
		 form = '(2i6, ' + strcompress(string(n)) + 'f12.5, 2f12.3)'
	endif

	iter = intarr(npix)
	best_chi = chisq
	best_p = p
	chi_a = chisq
	jacobian = fltarr(n,m,npix)
	yfit = fltarr(m,npix)
	repeat begin
	; EVALUATE p AND K for this iteration
		oldchisq = chisq

		if use_x then f = CALL_FUNCTION(funct_name, p[*,w], x, deriv=K, _extra = _extra) $
				 else f = CALL_FUNCTION(funct_name, p[*,w], deriv=K, _extra = _extra)
	    if keyword_set(autoderivative) and (n_elements(K) GT 0) AND iteration eq 0 then Ktest = K
		if n_elements(K) eq 0 OR keyword_set(autoderivative) then begin
		; must get numerical derivatives!!!
			K = fltarr(n,m,nw)
			dp = fltarr(n,nw)
			for ix = 0l, n-1 do begin ; cycle through input variables
				if n_elements(perturbation) eq 0 then delta = 1e-3 * reform(p[ix,*]) else delta = perturbation
				if n_elements(delta) ne (n*npix) then delta = delta # (fltarr(npix)+1.)
				wbad = where (delta eq 0.)
				if wbad[0] ne -1 then delta[wbad] = 1e-5 ; default perturbation
				dp[ix,*] = delta
				if use_x then f2 = CALL_FUNCTION(funct_name, p[*,w]+dp, x, _extra = _extra) $
						 else f2 = CALL_FUNCTION(funct_name, p[*,w]+dp, _extra = _extra)
				if m LT nw then for ii=0,m-1 do K[ix,ii,*] = (f2 - f)[ii,*] / delta $
					else for ii=0,nw-1 do K[ix,*,ii] = (f2-f)[*,ii] / delta[ii]
				dp[ix,*] = 0.
			endfor
		endif
		if n_elements(Ktest) GT 0 AND iteration eq 0 then begin
		    print, 'Ktest: '
		    print, Ktest
		    print, 'K:'
		    print, K
		endif

		; EVALUATE dP for this iteration
		if (size(K))[0] eq 3 then ot = [1,0,2] else ot = [1,0]
		if no_errors then KtSy = transpose(K, ot) else begin
			; evaluate K^T Sy^-1
			KtSy = fltarr(m,n,nw)
			if nw GT (n*m) then begin
				for i=0l,n-1 do for j=0l,m-1 do KtSy[j,i,*] = total(K[i,*,*] * Syinv[j,*,w], 2)
			endif else begin
				for i=0l, nw-1 do KtSy[*,*,i] = transpose(K[*,*,i]) ## Syinv[*,*,w[i]]
			endelse
		endelse

		; evaluate (K^T Sy^-1) K + Sa^-1
		Spinv = fltarr(n,n,nw) ; inverse of output error covariance matrix
		if nw GT (n*m) then begin
			for i=0l,n-1 do for j=0,n-1 do $
			  Spinv[j,i,*] = total(reform(KtSy[*,i,*]) * reform(K[j,*,*]), 1) + Sainv[j,i]
		endif else begin
			for i=0l,nw-1 do Spinv[*,*,i] = KtSy[*,*,i] ## K[*,*,i] + Sainv
		endelse

		;Sp = invert_symmetric(Spinv)
    sp = INVERT(spinv)

		; EVALUATE CHI-SQUARED
		dy = y[*,w] - f ; difference between measurement and forward model (m,nw)
		if no_errors then chisq[w] = total(dy * dy, 1) else begin
			if nw LT m then begin
				for i =0l,nw-1 do chisq[w[i]] = dy[*,i] ## (Syinv[*,*,w[i]] ## transpose(dy[*,i]))
			endif else begin
				Sydy = fltarr(m,nw)
				for i=0l,m-1 do Sydy[i,*] = total(reform(Syinv[*,i,w]) * dy, 1)
				chisq[w] = total( Sydy * dy, 1)
			endelse
		endelse

		; evaluate KtSydy
		KtSydy = fltarr(n, nw) ; really 1 x n (npix of them)
		if nw LT m then begin
			for i=0l,nw-1 do KtSydy[*,i] = KtSy[*,*,i] ## transpose(dy[*,i])
		endif else begin
			for i=0l,n-1 do KtSydy[i,*] = total(reform(KtSy[*,i,*]) * dy,1)
		endelse

		Sadp = fltarr(n,nw)
		if prior then begin
		; add Sainv # (pa-p) to KySydy.  pa is (n). p is (n,nw)
			if nw LT (2*n*n) then begin
				for i=0l,nw-1 do Sadp[*,i] = Sainv ## transpose(pa - p[*,w[i]])
				for i=0l,nw-1 do chi_a[w[i]] = total( Sadp[*,i] * (pa-p[*,w[i]]) )
			endif else begin
			; if nw is very large
				Sainv2 = fltarr(n,n,nw)
				da = fltarr(n,nw)
				for i=0l,n-1 do for j=0,n-1 do Sainv2[i,j,*] = Sainv[i,j]
				for i=0l,n-1 do da[i,*] = pa[i] - p[i,w]
				for i=0l,n-1 do Sadp[i,*] = total(reform(Sainv2[*,i,*]) * da,1)
				chi_a[w] = total(da * Sadp, 1)
			endelse
			KtSydy = KtSydy + Sadp ; update this change vector with apriori contribution
		endif else chi_a[w] = 0.0

		;evaluate dp (change in state vector)
		dp = fltarr(n, npix)
		if nw LT m then begin
			for i=0l,nw-1 do dp[*,w[i]] = Sp[*,*,i] ## transpose(KtSydy[*,i])
		endif else begin
			for i=0l,n-1 do dp[i,w] = total(reform(Sp[*,i,*]) * KtSydy,1)
		endelse

        wbest = where( (chisq[w] + chi_a[w]) LT best_chi[w])
		if wbest[0] ne -1 then begin
		  wwbest = w[wbest]
		  best_p[*,wwbest] = p[*,wwbest]
		  best_chi[wwbest] = (chisq+chi_a)[wwbest]
		  yfit[*,wwbest] = f[*,wbest]
		  jacobian[*,*,wwbest] = K[*,*,wbest]
		  covar[*,*,wwbest] = Sp[*,*,wbest]
        endif

		; TEST CONVERGENCE
		; can do this by change in the chi-squared (for now)
		iteration = iteration + 1
		dummy = temporary(K) ; delete K variable
		if special eq -1 then spec = (where(chisq eq max(chisq)))[0] else spec = special
		if keyword_set(verbose) then print, nw, iteration, p[*,spec], chisq[spec], chi_a[spec], form=form
        path=[[path],[p[*,spec]]]
		if iteration GE min_iter then begin
		    success = abs(chisq-oldchisq)/chisq LE tol OR chisq LE max_chisq
		    w = where(success eq 0, nw) ; where convergence has failed
		endif
		if nw GT 0 then begin
		    p[*,w] = p[*,w] + dp[*,w] ; only update those that do not meet chisq condition
		    iter[w] = iter[w] + 1
            if keyword_set(limits) then for i = 0, n-1 do p[i,w] = (p[i,w] > limits[2*i]) < limits[2*i+1]
		endif

	endrep until (iteration GE max_iter) OR (nw eq 0)
	if nw GT 0 and not(keyword_Set(quiet)) then print, 'CONVERGENCE FAILED FOR ' + sc(nw) + ' PROFILES.'
	p = best_p
	chisq = best_chi
	return, p

END
