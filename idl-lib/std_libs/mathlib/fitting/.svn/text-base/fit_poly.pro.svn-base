function fit_poly, y, x, yfit=yfit, double=double,  N=N, improve=improve, weights=weights, $
	meas_err = meas_err, errors = errors, covar=covar

; x : independent variable, 1D (Nx)
; y : The data.  Note : this may be 2D (Nx, npix)
; N : the order of the polynomial (1=line, 2=quadratic, etc)
; weights : the weight for each data point.  Gaussian errors have weights propto 1/error^2.

	y_ = y
	sy = size(y)
	if n_elements(x) eq 0 then begin
		Nx = sy[1]
		x = findgen(Nx)
	endif else Nx = n_elements(x)

	if n_elements(N) eq 0 then N = 1
	P = fit_linear(y, x, 'poly_basis', N=N, yfit=yfit, weights=weights, $
				double=double, improve = improve, period=period, $
				meas_err = meas_err, errors = errors, covar=covar)


	return, P

end