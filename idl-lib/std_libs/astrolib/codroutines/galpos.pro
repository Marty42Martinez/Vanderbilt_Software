function galpos, jd, degrees=degrees, _extra=_extra

; JD2GAL takes current julian date, calculates the ra and dec for pbo (Default),
; and then tells you what your current galactic latitude and longitude are.

; INPUT
; 	jd	: 	Julian date in J2000 {can also enter array of jd's}

; KEYWORDS
;	lat :	latitude of observing site (default is PBO)
;	lon :   longitude of observing site (default is PBO)
;	degrees:	all inputs and outputs in degrees (default is radians)


; RETURN	A struct containing b and l {b,l}, may be arrays depending on input

; DEPENENCIES
; 	cozenpos.pro,
;	ct2lst.pro

r2d = 180./!dpi

cozenpos, jd, ra, dec, lat=lat,lng=lng,_extra=_extra  ; gives radians unless you tell it otherwise

; convert radian (ra,dec) to degrees
ra = ra * r2d
dec = dec * r2d
; now ra and dec are definitely in DEGREES

; next, calculate (b,l) using EULER (which wants everything in degrees)
euler, ra,dec,l,b,1

; convert (b,l) to radians if necessary
if n_elements(degrees) eq 0 then begin
	b = b/r2d
	l = l/r2d
endif

return, {b:b,l:l}

END