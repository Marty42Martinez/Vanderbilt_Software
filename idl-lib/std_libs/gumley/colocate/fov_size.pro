FUNCTION FOV_SIZE, Y0, A, S, Z

; Compute FOV across-track width (X) and along-track height (Y) given
;
; Y0    FOV along-track height (km) at nadir
; A     Altitude of satellite above earth surface (km)
; S     Slant range of a vector from the satellite to the center of the FOV (km)
; Z     Angle between nadir and a vector from the satellite to the surface (deg)

y = y0 * (s / a)
x = y / cos(!dtor * z)
dims = size(z, /dimensions)
return, reform([[x], [y]], dims[0], dims[1], 2)

END
