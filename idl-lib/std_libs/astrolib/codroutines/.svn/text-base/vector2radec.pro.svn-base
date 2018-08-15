PRO vector2radec, x, y, z, ra, dec

; INPUTS
; 	x,y,z	: Components of Equatorial Rectangular Coordinates (scalar or vector)

; OUTPUTS
;	ra, dec : Corresponding right ascension and declination (in DEGREES)

d2r = !dpi/180.

r = sqrt(x^2 + y^2 + z^2)
xyproj = sqrt(x^2 + y^2)

ra = x * 0.d
dec = x * 0.d

w1 = where( (xyproj eq 0) AND (z ne 0) )
w2 = where(xyproj ne 0)

; Calculate Ra and Dec in RADIANS (later convert to DEGREES)
if w1[0] ne -1 then begin
	; places where xyproj=0 (point at NCP or SCP)
	dec[w1] = asin(z[w1]/r[w1])
	ra[w1] = 0.
endif
if w2[0] ne -1 then begin
	; places other than NCP or SCP
	ra[w2] = atan(y[w2],x[w2])
	dec[w2] = asin(z[w2]/r[w2])
endif

; convert to DEGREES
ra = ra /d2r
dec = dec /d2r

w = where(ra LT 0.)
if w[0] ne -1 then ra[w] = ra[w] + 360.

END
