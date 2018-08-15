; test program to test ra-dec to alt az spherical crap

d2r = !dpi/180.

ra =  333.
dec = -75.
last = 195.48246 ; last in degrees.
lat = -50.

ha = last - ra
w = where(ha LT 0)
if w[0] ne -1 then ha[w] = ha[w] + 360.
ha = ha mod 360.

;*******************************************************************************************
; Now do the spheical trig to get APPARENT alt,az.
hadec2altaz, ha, dec, lat, alt, az, WS=WS

; now have alt, az.  go back and get hour angle.

;*******************************************************************************************
; find local HOUR ANGLE (in degrees, from 0. to 360.)
ha = atan(-sin(az*d2r)*cos(alt*d2r),-cos(az*d2r)*sin(lat*d2r)*cos(alt*d2r)+sin(alt*d2r)*cos(lat*d2r))
ha = ha / d2r
w = where(ha LT 0.)
if w[0] ne -1 then ha[w] = ha[w] + 360.
ha = ha mod 360.

; Find declination (positive if north of Celestial Equator, negative if south)
sindec = sin(lat*d2r)*sin(alt*d2r) + cos(lat*d2r)*cos(alt*d2r)*cos(az*d2r)
dec2 = asin(sindec)/d2r  ; convert dec to degrees

ra2 = last - ha
if ra2 lt 0. then ra2 = ra2 + 360.



END