PRO COZENPOS, date, ra, dec, lat=lat, lng=lng, degrees=degrees
;+
; NAME:
;       COZENPOS
; PURPOSE:
;       Return the zenith RA and Dec in radians for a given Julian date.
;
; CALLING SEQUENCE:
;       ZENPOS, Date, Ra, Dec
;
; INPUT:
;       Date  The Julian date, in double precision, of the date and time
;               for which the zenith position is desired.
;
; OUTPUTS:
;       Ra    The right ascension in RADIANS of the zenith.
;       Dec   The declination in RADIANS of the zenith.
;
; PROCEDURE:
;       The local sidereal time is computed; this is the RA of the zenith.
;       It and the observatories latitude (corresponding to the Dec.) are
;       converted to radians and returned as the zenith direction.
;
 if N_elements (lat) eq 0 then lat = 43.0783
 if N_elements(lng) eq 0 then lng = 89.685

;
;                            Define the needed conversion factors.
;
 d2rad = !DPI / 180.D0
 h2rad = !DPI / 12.D0

;
;                            Get the sideral time corresponding to the
;                            supplied date.
;
 ct2lst, lst, -1*lng, 0, date
;
;                            Compute the RA and Dec.
;
 ra = lst * h2rad
 dec = ra*0. + lat * d2rad

; convert outputs to degrees if need be
 if keyword_set(degrees) then begin
 	ra = ra/d2rad
 	dec = dec/d2rad
 endif
;
 RETURN
 END
