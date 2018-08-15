function poly_basis, x, n=n

	if n_elements(n) eq 0 then n = 1 ; default to linear

	nx = n_elements(x)
	out = fltarr(nx, n+1) + x[0] * 0.

    out[*,0] = 1.0
	for i = 1, n do out[*,i] = x^i

	return, out

end