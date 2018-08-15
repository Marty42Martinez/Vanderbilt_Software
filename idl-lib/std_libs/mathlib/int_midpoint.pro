function int_midpoint, x_ , y_, double = double, sort = sort

	; does the midpoint method for integration; automatically sorts x.
	; does not change either input.

	double = keyword_set(double)

	if keyword_set(sort) then begin
		s = sort(x_)
		x = x_[s]
		y = y_[s]
	endif else begin
		x = x_
		y = y_
	endelse

	if size(x, /type) eq 5 OR size(y, /type) eq 5 then double = 1
	if double then HALF = 0.5d else HALF = 0.5

	dx = x[1:*] - x
	ybar = (y[1:*] + y) * HALF

	return, total(dx * ybar)

END



