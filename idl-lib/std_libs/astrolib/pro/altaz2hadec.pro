PRO altaz2hadec, alt, az, lat, ha, dec

; Converts Alt-Az to Hour Angle and Declination.
; Can deal with the NCP singularity
; Intended mainly to be used by program hor2eq.pro

; INPUTS
;   alt: the local apparent altitude, in DEGREES.
;	az : the local apparent azimuth, in DEGREES.
;   lat: the local geodetic latitude, in DEGREES
;
; OUTPUTS
;   ha : the local apparent hour angle, in DEGREES.
;   dec: the local apparent declination, in DEGREES.

d2r = !dpi/180.

;*******************************************************************************************
; find local HOUR ANGLE (in degrees, from 0. to 360.)
ha = atan(sin(az_*d2r)*cos(alt*d2r),cos(az_*d2r)*sin(lat*d2r)*cos(alt*d2r)-sin(alt*d2r)*cos(lat*d2r))
ha = ha / d2r
w = where(ha LT 0.)
if w[0] ne -1 then ha[w] = ha[w] + 360.
ha = ha mod 360.

; Find declination (positive if north of Celestial Equator, negative if south)
sindec = sin(lat*d2r)*sin(alt*d2r) + cos(lat*d2r)*cos(alt*d2r)*cos(az_*d2r)
dec = asin(sindec)/d2r  ; convert dec to degrees


END