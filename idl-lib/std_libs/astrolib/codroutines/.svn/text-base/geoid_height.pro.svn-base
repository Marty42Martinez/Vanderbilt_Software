function geoid_height, lat

; lat is in degrees
; return value is in km

	a = 6378.137 ; earth's equatorial radius
	f = 1/298.25722356

	lat_geocentric = atan((1.-f)^2 * tan(lat * !pi/180.))

	; lat_geocentric is the geocentric latitude in degrees
	x = sin(lat_geocentric)^2



	; tan (geocentric lat) = (1-f)^2 * tan (geographic lat)
	return, a * (1. - f*x)

END