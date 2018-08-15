;+
;  NAME:
;     CO_ABERRATION
;
; (updated Dec 2, 2002)
;
; PURPOSE:
;     Calculate changes to Ra and Dec due to "the effect of aberration",
; EXPLANATION:
;      as described in Meeus, Chap 23.
; CALLING SEQUENCE:
;      co_aberration, jd, ra, dec, d_ra, d_dec, [EPS = , /FAST]
; INPUTS
;       jd      : Julian Date [scalar or vector]
;       ra, dec : Arrays (or scalars) of the ra  and dec's in degrees
;   Note: if jd is a vector, ra and dec MUST be vectors of the same length.
;
; OUTPUTS
;       d_ra, d_dec: the corrections to ra and dec due to aberration (must then
;                     be added to ra and dec to get corrected values).
; OPTIONAL INPUT KEYWORD:
;       eps : set this to the true obliquity of the ecliptic (in radians), or
;         it will be set for you if you don't know it (in that case, set it to
;                 an empty variable).
;		fast: set this to do assume all jd's are the same.

; EXAMPLE:
;   Compute the change in RA and Dec of Theta Persei (RA = 2h46m,11.331s, Dec =
;   49d20',54.54" on 2028 Nov 13.19 TD
;
;      IDL> jdcnv,2028,11,13,.19*24,jd      ;Get Julian date
;      IDL> co_aberration,jd,ten(2,46,11.331)*15,ten(49,20,54.54),d_ra,d_dec
;
;      ==> d_ra = 30.045"    d_dec = 6.697"
; NOTES:
;  These formula are from Meeus, Chapters 23.  Accuracy is much better than 1
;   arcsecond.
;
; REVISION HISTORY:
;   Written, June 2002,      Chris O'Dell, U. of Wisconsin
;-

PRO co_aberration, jd, ra, dec, d_ra, d_dec, eps=eps, fast=fast

 d2r = !dpi/180.
 T = (jd -2451545.0)/36525.0 ; julian centuries from J2000 of jd.
 if keyword_set(fast) then T = T[0]

 if n_elements(eps) eq 0 then begin ; must calculate obliquity of ecliptic
        if keyword_set(fast) then nutate, jd[0], d_psi, d_epsilon $
        	else nutate,jd,d_psi, d_epsilon
        eps0 = ten(23,26,21.448)*3600.d - 46.8150*T - 0.00059*T^2 +  $
               0.001813*T^3
        eps = (eps0 + d_epsilon)/3600.*d2r ; true obliquity of the ecliptic
;                                            in radians
endif

if (keyword_set(fast) AND (n_elements(jd) GT 1)) then begin
	; do simple interpolation to get sun longitudes fast
	 jdmn = min(jd)
	 jdmx = max(jd)
	 sunpos, [jdmn,jdmx], sunra, sundec, sunlon
	 sunlon = sunlon[0] + (sunlon[1]-sunlon[0]) * (jd-jdmn)/(jdmx-jdmn)
endif else sunpos, jd, sunra, sundec, sunlon

; Earth's orbital eccentricity
 e = 0.016708634d - 0.000042037d*T - 0.0000001267d*T^2
; longitude of perihelion, in degrees
pi = 102.93735 + 1.71946*T + 0.00046*T^2
k = 20.49552 ;constant of aberration, in arcseconds

;Useful Trig Functions
cd = cos(dec*d2r) & sd = sin(dec*d2r)
ce = cos(eps) & te = tan(eps)
cp = cos(pi*d2r) & sp = sin(pi*d2r)
cs = cos(sunlon*d2r) & ss = sin(sunlon*d2r)
ca = cos(ra*d2r) & sa = sin(ra*d2r)

term1 = (ca*cs*ce+sa*ss)/cd
term2 = (ca*cp*ce+sa*sp)/cd
term3 = (cs*ce*(te*cd-sa*sd)+ca*sd*ss)
term4 = (cp*ce*(te*cd-sa*sd)+ca*sd*sp)

d_ra = -k * term1 + e*k * term2
d_dec = -k * term3 + e*k * term4

END