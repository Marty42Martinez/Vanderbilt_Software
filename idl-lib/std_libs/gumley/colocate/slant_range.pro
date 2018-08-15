FUNCTION SLANT_RANGE, RADIUS, ALTITUDE, SCANANG

; Compute slant range (km) from satellite to surface given
;
; RADIUS    Radius of earth (km)
; ALTITUDE  Altitude of satellite above earth surface (km)
; SCANANG   Angle between nadir and a vector from the satellite to the surface (deg)

rsat = radius + altitude
theta = !dtor * scanang
slant_range = (rsat * cos(theta)) - sqrt(radius^2 - (rsat * sin(theta))^2)
return, slant_range

END
