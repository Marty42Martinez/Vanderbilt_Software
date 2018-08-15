pro moonaltaz, jd, alt, az, moonha, lat=lat, lng=lng
; MOONALTAZ
;
; INPUT VARIABLES
; JD - Julian Date
; note: if JD is an array of dates, then alt and az will also be arrays
;
; OPTIONAL KEYWORDS
; lat - north latitude of location in degrees
; lng = west longitude of location in degrees

; OUTPUT VARIABLES
; alt = moon's altitude (in degrees)
; az = moon's azimuth angle (in degrees, measured westward from south ala Meeus)
; moonha = moon's hour angle (in degrees)

; If no lat, lng, or tzone entered, use PBO values
if n_elements(lat) eq 0 then lat = 43.0783 ; (btw, this is the dec of the zenith)
if n_elements(lng) eq 0 then lng = 89.685

; converstion factors
d2r = !dpi/180.
h2r = !dpi/12.

;calculate local sidereal time
ct2lst, lst, -1*lng, 0, jd  ; get LST (in hours) - note:this is indep of tzone since giving jd
lst = lst*h2r ; convert LST to radians (btw, this is the RA of the zenith)

; find ra and dec of moon at this julian date (in radians)
moonpos, jd, moonra, moondec, /rad

; find hour angle of moon (in radians)
moonha = lst - moonra

; find altitude of moon
sh = sin(lat*d2r)*sin(moondec) + cos(lat*d2r)*cos(moondec)*cos(moonha)
alt = asin(sh)/d2r

; find azimuth of moon
az = atan( sin(moonha), cos(moonha)*sin(lat*d2r)-tan(moondec)*cos(lat*d2r))/d2r

moonha = moonha/d2r
end