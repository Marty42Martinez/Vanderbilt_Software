function t_func, x, N

	return, (1 + x^2 / (N-1.) )^(-0.5*N)

end
function correlation_significance, r, N

; r is the correlation coefficient
; N is the number of data points in each data set

	NN = 1e4

	t = abs(r) / sqrt( (1.-r^2)/(N-2.) )

	x0 = 20.
	if N LT 5. then x0 = -50.

	x = findgen(NN)/(NN-1.) * 2*x0 - x0

	w = where( x LE t)
	significance = int_midpoint(x[w], t_func(x[w],N) ) / int_midpoint(x, t_func(x,N))

	return, significance

end