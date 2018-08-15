function OE_moments, x, err
; attempt to fit for mean and stddev of an underlying distribution,
; that you unfortunately measured with noise on your instruments.

	mn = 1/total(1/err^2) * total(x/err^2) ; weighted mean

	y = (x - mn)^2
	erry = 2*err ; probably a bit low

	mn2 = 1/total(1/erry^2) * total(y/erry^2) ; weighted mean of (x-mn)^2
	nx= n_elements(x)

	return, [mn, sqrt(nx/(nx-1.)) * sqrt(mn2)]

END
