FUNCTION leap_year, year

;	year : scalar or vector

	ny = n_elements(year)
	out = bytarr(ny) ; set all to 0

	w = where((year mod 4) eq 0) & if w[0] ne -1 then out[w] = 1
	w = where((year mod 100) eq 0) & if w[0] ne -1 then out[w] = 0
	w = where((year mod 400) eq 0) & if w[0] ne -1 then out[w] = 1

	if ny eq 1 then out = out[0]
	return, out

END