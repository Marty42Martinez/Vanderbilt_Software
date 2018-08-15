function gamma_fit, X_, Y_, Yerr, ERRMSG=errmsg, quiet=quiet, $
                     COVAR=covar, STATUS=status , yfit=yfit, perror=perror, start=P, $
                     log=log
	; X_ : array of X values
	; Y_ : array of Y values
	; Yerr : (optional) array of Y 1-sigma errors
	; yfit = fit values for each X_
	; covar : parameter covariance matrix
	; perror: formal (1-sigma) errors of parameter values, taken from diagonals of covar I think.
	;
	; return value: Best fit Parameter Values.

	; f(x) = P[0] * X^P[1] * exp(-P[2] * X^P[3])

	s = sort(X_)
	X = X_[s]
	Y = Y_[s]
	n = n_elements(X_)
	if n_elements(Yerr) eq 0 then Yerr = fltarr(n) + 1.0
	dumm = max(x, maxloc)
	P2 = 1/x[maxloc]
	P0 = P2^2 * int_midpoint(x, y) ; integral
	P1 = 1.
	P3 = 1.

	if ~keyword_set(log) then begin
		expr = 'P[0] * X^P[1] * exp(-1 * P[2] * X^P[3])'
		if n_elements(P) eq 0 then P = [P0, P1, P2, P3]
		pfit = mpfitexpr(expr, X, Y, Yerr, P, errmsg=errmsg, covar=covar,status=status,yfit=yfit, perror=perror, quiet=quiet)
	endif else begin
		; do fit in log(y) space, to give tail points a greater weight.
		Y = alog(y)
		expr = 'P[0] + P[1] * alog(X) - P[2] * X^P[3]'
	    P0 = alog(P0)
	    if n_elements(P) eq 0 then P = [P0, P1, P2, P3]
		pfit = mpfitexpr(expr, X, Y, Yerr, P, errmsg=errmsg, covar=covar,status=status,yfit=yfit, perror=perror, quiet=quiet)
		pfit[0] = exp(pfit[0])
		yfit = exp(yfit)
	endelse
	yfit = yfit[s]

	return, pfit
end








