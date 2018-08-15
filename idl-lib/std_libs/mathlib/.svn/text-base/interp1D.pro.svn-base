
function interp1D, x, y, xgrid

	ygrid = xgrid * 0. + y[0]*0.
	nx = n_elements(x)
	loc = interpol(findgen(nx), x, xgrid)
	ygrid= interpolate(y, loc)
	return, ygrid
END