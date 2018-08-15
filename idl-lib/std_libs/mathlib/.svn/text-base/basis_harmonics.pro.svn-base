function basis_harmonics, x, np = np

	nx = n_elements(x)
	out = fltarr(nx, 5)

	out[*,0] = x * 0. + 1.
	out[*,1] = sin(2 * !pi * x)
	out[*,2] = cos(2 * !pi * x)
	out[*,3] = sin(4 * !pi * x)
	out[*,4] = cos(4 * !pi * x)

	if n_elements(np) eq 0 then np = 5

	return, out[*, 0:np-1]

end

