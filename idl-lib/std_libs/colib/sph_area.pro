function sph_area, lat1, lat2, lon1, lon2, degrees = degrees

;	returns the FRACTIONAL area of a sphere covered by this
;	spherical path, specified by lat1 to lat2, lon1 to lon2

	if keyword_set(degrees) then d2r = !dpi/180. else d2r = 1.0d

	area = abs(longitude_difference(lon1*d2r, lon2*d2r, /rad))
	area = area * abs( sin(d2r*lat2) - sin(d2r*lat1) )

	return, area / (4*!dpi)

END