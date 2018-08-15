function co_sunlongitude, jd

; Calculates the Sun's true solar longitude, based on the Julian Date.
;
; INPUTS
;  jd 	: Julian Date (scalar or vector)
;
; Return value : longitude of sun at JD, in DEGREES.
;
; Uses formuale from MEEUS, Chapter 25.

d2r = !dpi/180.
T = (jd -2451545.0)/36525.0 ; julian centuries from J2000 of jd.

; Find the MEAN longitude of the sun, referred to the mean equinox of jd, in DEGREES.
L0 = 280.46646 + 36000.76983*T + 0.0003032*T^2

; Find the mean anomaly of the sun, in RADIANS.
M = 357.52911 + 35999.05029*T - 0.0001537*T^2 ; (degrees)
M = M * d2r

; Find the Sun's "Equation of the Center", whatever that is :)
C = (1.914602 - 0.004817*T - 0.000014*T^2)*sin(M) + $
	(0.019993 - 0.000101*T) * sin(2*M) + $
	 0.000289 * sin(3*M)

sunlon = L0 + C

sunlon = sunlon mod 360.0d
w = where(sunlon LT 0)
if w[0] ne -1 then sunlon[w] = sunlon[w] + 360.

return, sunlon

END