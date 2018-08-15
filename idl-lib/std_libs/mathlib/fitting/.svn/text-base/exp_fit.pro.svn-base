function exp_fit, X_, Y_, Yerr, ERRMSG=errmsg, $
                     COVAR=covar, STATUS=status , yfit=yfit, perror=perror

	; X_ : array of X values
	; Y_ : array of Y values
	; Yerr : (optional) array of Y 1-sigma errors
	; yfit = fit values for each X_
	; covar : parameter covariance matrix
	; perror: formal (1-sigma) errors of parameter values, taken from diagonals of covar I think.
	;
	; return value: Best fit Parameter Values.


	expr = 'P[0] + P[1]*exp(P[2] * X)'

	s = sort(X_)
	X = X_[s]
	Y = Y_[s]
	n = n_elements(X_)

	P2 = 1./mean(X)
	e1 = exp(p2 * X[n-1])
	e0 = exp(p2 * X[0])
	P1 = (Y[n-1] - Y[0])/(e1-e0)
	P0 = Y[n-1] - P1 * e1

	P = [P0, P1, P2]
	if n_elements(Yerr) eq 0 then Yerr = fltarr(n) + 1.0

	pfit = mpfitexpr(expr, X, Y, Yerr, P, errmsg=errmsg, covar=covar,status=status,yfit=yfit, perror=perror, /quiet)

	yfit = yfit[s]

	return, pfit
end








