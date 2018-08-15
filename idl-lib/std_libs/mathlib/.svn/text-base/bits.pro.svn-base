function bits, x

	i = fix(x)
	bit = bytarr(8)
	b2 = 2^indgen(8)
	for b = 0, 7 do bit[b] = (i AND b2[b]) / (b2[b])
	return, bit

END
