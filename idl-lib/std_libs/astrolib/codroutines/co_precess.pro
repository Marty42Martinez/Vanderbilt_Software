pro co_precess, ra, dec, jd, ra_out, dec_out, B1950=B1950

; Precesses J2000 coordinates (FK5) to the specified date.
; will precess from B1950 (FK4) with optional keyword.

; INPUTS
; ra : right ascension in degrees (may be array)
; dec : declination in degrees (may be array)
;
; jd : Julian date desired for the current equinox.

; OPTIONAL KEYWORDS
; B1950 : precess with respect to B1950 (FK4) coordinates instead of J2000.

; OUTPUT
; ra_out : right ascension in degrees wrt new equinox.
; dec_out : declination in degrees wrt new equinox

; DEPENDENCIES
; JPRECESS.pro, in the Astronomy User's Library (precesses B1950 to J2000.)

d2r = !dpi/180.
r2d = 180./!dpi

; Precess input coordinates to J2000, if necessary
if keyword_set(B1950) then begin
	jprecess, double(ra), double(dec), ra2000, dec2000
endif else begin
		ra2000 = double(ra)
		dec2000 = double(dec)
endelse

; convert ra and dec (j2000) to radians of arc.
ra2000 = ra2000 * d2r
dec2000 = dec2000 * d2r

; Calculate 1st Order Precession Correction
; this is accurate to about 1 arcsecond for a given date within 20 years of the year 2000.
y = (jd - 2451545.0)/365.25 ; time in years from j2000 date (january 1, 2000) to jd.
dra1 = (3.075 + 1.336*sin(ra2000) * tan(dec2000)) * y ; in seconds of time
ddec1 = 20.04 * cos(ra2000) * y
; convert both these to degrees of arc.
dra1 = dra1 * 15. /3600.d
ddec1 = ddec1 / 3600.d

; Now Calculate Nutation Effect (good to about an arcsecond)
d = jd - 2451545.0 ; same as y??!
dL = -17.3 * sin((125.0 - 0.05295 * d)*d2r) - 1.4 * sin((200.0 + 1.97129*d)*d2r)
dE =   9.4 * cos((125.0 - 0.05295 * d)*d2r) + 0.7 * cos((200.0 + 1.97129*d)*d2r)

dra2 = (0.9175 + 0.3978 * sin(ra2000) * tan(dec2000)) * dL - $
	   cos(ra2000) * tan(dec2000) * dE

ddec2 = 0.3978 * cos(ra2000) * dL + sin(ra2000) * dE

dra2 = dra2 /3600.d
ddec2 = ddec2 / 3600.d
ra_out = ra + dra1 + dra2
dec_out = dec + ddec1 + ddec2

end