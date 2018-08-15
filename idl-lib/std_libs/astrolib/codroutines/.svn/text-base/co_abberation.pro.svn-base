pro co_abberation, ra, dec, jd

; Given ra and dec referred to the "jd" equinox (FK5) (that is, precessed
; already from J2000) calculate the new ra and dec (referred to the "jd" equinox)
; due to the effect from annual aberration.
;
; Adopted from formulae in Meeus, Chapter 23
;

T = (jd - 2451545.)/36525. ; julian centuries from J2000
e = .016708634 - 0.000042037 * T - 0.0000001267*T^2 ; eccentricity of earth's orbit
pi = 102.93735 + 1.71946*T + 0.00046 * T^2 ; longitude of the perihelion (whatever that is :) )

dra =






