FUNCTION two_series, c, N

; return two gaussian time series with unit variance and correlation of c.

	r = fltarr(N, 2)
	r[*,0] = randomn(seed, N)
	r[*,1] = (randomn(seed, N) + c / sqrt(1.-c^2) * r[*,0] ) * sqrt(1. - c^2)

	return, r

END
