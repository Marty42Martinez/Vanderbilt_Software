function correlation_error, N, c

	; N = number of samples being correlated
	; c = calculated correlation coefficient

	; this formula was estimated empirically, and is only approximate.
	; it has trouble for very low N (<~ 10) or very high c ( > 0.99) .

	return, (1.-c^2)/sqrt(N-1.) + sqrt(1.-c^2) / (N-1.)^1.5

end