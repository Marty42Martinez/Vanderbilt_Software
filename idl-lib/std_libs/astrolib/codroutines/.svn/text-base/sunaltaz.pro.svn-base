pro sunaltaz, jd, alt, az, lat=lat,lon=lon
; SUNALTAZ
;
; INPUT VARIABLES
; JD - Julian Date
; note: if JD is an array of dates, then alt and az will also be arrays
;
; OPTIONAL KEYWORDS
; lat = north latitude of location in degrees
; lon = east longitude of location in degrees

; OUTPUT VARIABLES
; alt = sun's altitude (in degrees)
; az = sun's azimuth angle (in degrees, measured westward from south ala Meeus)

; If no lat, lng, or tzone entered, use PBO values
if n_elements(lat) eq 0 then lat = 43.0783 ; (btw, this is the dec of the zenith)
if n_elements(lng) eq 0 then lng = 89.685

; converstion factors
d2r = !dpi/180.
h2r = !dpi/12.

sunpos, jd, sunra, sundec

eq2hor, sunra, sundec, jd, alt, az, lat=lat, lon=lon, precess=0, /fast, ref=1

end