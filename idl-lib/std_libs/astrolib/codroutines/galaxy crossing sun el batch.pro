; batch to find sun elevation of galaxy crossings throughout the year.

gal1 = 74.2 ; ra of 1st galaxy crossing
gal2 = 311.5 ; ra of 2nd galaxy crossing

jds1 = dblarr(365)
jds2 = dblarr(365)
jd0 = juliandate('01/01/00','12:00:00', tz = 6)
for day =0, 364 do begin
	jd = findgen(24*60)/(24*60) + jd0 + day
	cozenpos, jd, ra, dec, /deg
	dev1 = abs(ra - gal1)
	dev2 = abs(ra - gal2)
	w1 = (where( dev1 eq min(dev1)))[0]
	w2 = (where( dev2 eq min(dev2)))[0]
	jds1[day] = jd[w1]
	jds2[day] = jd[w2]
endfor

sunaltaz, jds1, alt1, az
sunaltaz, jds2, alt2, az

END
