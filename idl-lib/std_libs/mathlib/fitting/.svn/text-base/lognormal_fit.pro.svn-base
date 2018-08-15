function planck_fit, X_, Y_, Yerr, ERRMSG=errmsg, quiet=quiet, $
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



	s = sort(X_)
	X = X_[s]
	Y = Y_[s]
	n = n_elements(X_)
	if n_elements(Yerr) eq 0 then Yerr = fltarr(n) + 1.0
	dum = max(y_, maxloc)
	xm = x_[maxloc]
	P1 = 1/xm
	P2 = 2.
	P0 = dum * (exp(P1*xm) - 1.) / xm^P2

	if ~keyword_set(log) then begin
		expr = 'P[0] * X^P[2] / (exp(P[1] * X) - 1.))'
		if n_elements(P) eq 0 then P = [P0, P1, P2]
		pfit = mpfitexpr(expr, X, Y, Yerr, P, errmsg=errmsg, covar=covar,status=status,yfit=yfit, perror=perror, quiet=quiet)
	endif else begin
		; do fit in log(y) space, to give tail points a greater weight.
		Y = alog(y)
		expr = 'P[0] - (alog(X) - P[1])^2 / (2*P[2]^2) - alog(X*P[2]*2*!pi)'
	    P0 = alog(P0)
	    if n_elements(P) eq 0 then P = [P0, P1, P2]
		pfit = mpfitexpr(expr, X, Y, Yerr, P, errmsg=errmsg, covar=covar,status=status,yfit=yfit, perror=perror, quiet=quiet)
		pfit[0] = exp(pfit[0])
		yfit = exp(yfit)
	endelse
	yfit = yfit[s]

	return, pfit
end








