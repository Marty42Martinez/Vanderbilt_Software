FUNCTION GMST, JD

; Given the Julian Date, returns the Greenwich Mean Sidereal Time, in hours from UT1=0h
; Date must have occurred after 2000-01-01 at UT1=0h (else you need a different formula)

T = (JD - 2451545.0)/36525.0

Gsec = 24110.54841 + 8640184.812866*T + 0.093104*T^2 - 0.0000062*T^3

return, Gsec/3600. mod 24.0

END