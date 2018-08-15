PRO caldat_str, julian, mm, dd, yyyy, hh, minmin, ss

	caldat, julian, month, day, year, hour, minute, second

	w = where(month LT 10)
	mm = sc(month)
	if w[0] ne -1 then mm[w] = '0' + mm[w]

	w = where(day LT 10)
	dd = sc(day)
	if w[0] ne -1 then dd[w] = '0' + dd[w]

	yyyy = sc(year)
	w = where(year LT 1000)
	if w[0] ne -1 then yyyy[w] = '0' + yyyy[w]

	w = where(hour LT 10)
	hh = sc(hour)
	if w[0] ne -1 then hh[w] = '0' + hh[w]

	w = where(minute LT 10)
	minmin = sc(minute)
	if w[0] ne -1 then minmin[w] = '0' + minmin[w]

	w = where(second LT 10)
	ss = sc(second)
	if w[0] ne -1 then ss[w] = '0' + ss[w]

END


