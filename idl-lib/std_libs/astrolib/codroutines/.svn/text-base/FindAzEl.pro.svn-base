PRO FindAzEl, date, time, daylight=daylight, lat=lat, lng=lng, ra=ra, dec=dec, $
	verbose=verbose, dms = dms

; default is to use PBO lat and lon.
; you must tell this program if daylight savings time is in effect
; (daylight=1 or /daylight when you call it)

; INPUTS
; time: the time you are curious about
;
; date: set this to a string containing the date of interest
;		  in 'mm/dd/yy' (it knows about the year 2000). NOTE: if this
;		  keyword is not set, it will use the current computer date (which
;	      is probably what you want).

; KEYWORDS
; 	daylight : set this if you're on daylight savings time
;
;

; OBJECT RA AND DEC:
;ra = 37.952 ; degrees
;dec = 89.264 ; degrees
v = keyword_set(verbose)
if n_elements(ra) eq 0 then ra = (5 + 34./60.+32./3600.) * 15.
if n_elements(dec) eq 0 then dec = 22.+ 0/60. + 52./3600.

if keyword_set(daylight) then tz = 5. else tz = 6.

jd = juliandate(date, time, tz=tz)
if v then print, jd, format='(F15.6)'
eq2hor, ra, dec, jd, alt, az, lat=lat, lng=lng, /EN ; find alt and az, az east from north.

if keyword_set(dms) then begin
	print, 'Altitude = ',n2dms(alt), '  Azimuth = ', n2dms(az)
endif else print, 'Altitude = ', alt, '   Azimuth = ', az

end
