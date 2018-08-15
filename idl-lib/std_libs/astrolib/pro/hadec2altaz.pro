PRO hadec2altaz, ha, dec, lat, alt, az, WS=WS

; Converts apparent Hour Angle and Declination to Horizon (alt-az) coordinates.
; Can deal with NCP/SCP singularity
; Intended mainly to be used by program eq2hor.pro

; INPUTS
;  ha : the local apparent hour angle, in DEGREES.
;  dec: the local apparent declination, in DEGREES.
;  lat: the local latitude, in DEGREES

; OUTPUTS
;   alt: the local apparent altitude, in DEGREES.
;	az : the local apparent azimuth, in DEGREES.

d2r = !dpi/180.

sh = sin(ha*d2r) & ch = cos(ha*d2r)
sd = sin(dec*d2r) & cd = cos(dec*d2r)
sl = sin(lat*d2r) & cl = cos(lat*d2r)

x = - ch * cd * sl + sd * cl
y = - sh * cd
z = ch * cd * cl + sd * sl
r = sqrt(x^2 + y^2)
; now get Alt, Az

az = dec * 0.d
alt = dec * 0.d

w = where(r ne 0.)
if w[0] ne -1 then begin
	; these are NOT the local Zenith or Nadir (and hence have a well-defined AZ)
	az[w] = atan(y[w],x[w]) /d2r
endif
alt = atan(z,r) / d2r

; correct for negative AZ
w = where(az LT 0)
if w[0] ne -1 then az[w] = az[w] + 360.

; convert AZ to West from South, if desired
if keyword_set(WS) then begin
	az = az - 180.
	w = where(az LT 0)
	if w[0] ne -1 then az[w] = az[w] + 360.
endif


END