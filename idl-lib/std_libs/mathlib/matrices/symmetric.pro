function Symmetric, C, tolerance = tolerance, diff=diff

;	Check if the correlation matrix C is
;	really symmetric, as it *should* be.

;   returns 1 if symmetric, 0 if otherwise
	tolerance = 1e-8
;  	print, 'Checking the symmetry...'
	diff = mean(abs(C-transpose(C))) / mean(abs(C))
	if diff LT tolerance then out = 1 else out = 0

	return, out
end