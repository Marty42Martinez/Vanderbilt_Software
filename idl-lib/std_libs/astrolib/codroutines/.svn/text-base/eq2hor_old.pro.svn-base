pro eq2hor_old, ra, dec, jd, alt, az, ha, lat=lat, lng=lng, EN=EN, B1950 = B1950
;
; EQ2HOR - Converts equatorial (celestial, ra-dec) coords of something to
;         local horizon coords (alt-az)
;
;
; INPUT VARIABLES
; RA - Right Ascension of object  (J2000) in degrees
; Dec - Declination of object (J2000) in degrees
; JD - Julian Date
; note: if JD and RA-DEC are arrays, then alt and az will also be arrays
;       but JD, RA, and DEC *must* have same dimensionality
;
; OPTIONAL KEYWORDS
; lat - north latitude of location in degrees
; lng = west longitude of location in degrees

; OUTPUT VARIABLES
; alt = altitude (in degrees)
; az = azimuth angle (in degrees, measured westward from south ala Meeus)
; ha = hour angle (in degrees) (optional)

; If no lat or lng entered, use PBO values
if n_elements(lat) eq 0 then lat = 43.0783 ; (btw, this is the dec of the zenith)
if n_elements(lng) eq 0 then lng = 89.685

; converstion factors
d2r = !dpi/180.
h2r = !dpi/12.
h2d = 15.d

; Precess coordinates to current date
; uses astro lib procedure PRECESS.pro
ra_ = ra
dec_ = dec
J_now = (JD - 2451545.0)/365.25 + 2000.0 ; compute current equinox
;if keyword_set(B1950) then begin
;	precess, ra_, dec_, 1950.0, J_now, /FK4
;endif else begin
;	precess, ra_, dec_, 2000.0, J_now
;endelse

;calculate local MEAN sidereal time
ct2lst, lmst, -1*lng, 0, jd  ; get LST (in hours) - note:this is indep of tzone since giving jd
lmst = lmst*h2d ; convert LMST to degrees (btw, this is the RA of the zenith)
; calculate local APPARENT sidereal time
nutate, jd, d_psi, d_epsilon ; nutation in longitude and obliquity of the ecliptic in arcseconds
T = (jd -2451545.0)/36525.0 ; julian centuries from J2000 of JD.
eps0 = ten(23,26,21.448)*3600.d - 46.8150*T - 0.00059*T^2 + 0.001813*T^3
; eps0 is the mean obliquity of the ecliptic and is good to about +/- 2000 yrs from J2000.
eps = eps0 + d_epsilon
LAST = lmst ;+ d_psi *cos(eps/3600.*d2r)/3600. ; add correction in degrees

print, 'LMST = ', n2dms(lmst/15.), '  LAST = ', n2dms(last/15.)

; find hour angle (in degrees), Measured West FROM South (ala Meeus)
ha = last - ra_
w = where(ha LT 0)
if w[0] ne -1 then ha[w] = ha[w] + 360.
ha = ha mod 360.

; find altitude
sh = sin(lat*d2r)*sin(dec_*d2r) + cos(lat*d2r)*cos(dec_*d2r)*cos(ha*d2r)
alt = asin(sh)/d2r

; find azimuth (measured westward from south)
az = atan(sin(ha*d2r),cos(ha*d2r)*sin(lat*d2r)-tan(dec_*d2r)*cos(lat*d2r))
az = az /d2r ; convert AZ to degrees (-180 to +180)

; convert AZ to east-from-north, if desired
if keyword_set(EN) then AZ = AZ + 180.

end