FUNCTION ELLIPSE_DIST, RMIN, RMAX, PHI, POS

; Compute length of a vector from the center of an ellipse
; to a point on the ellipse given
;
; RMIN     Semi-minor axis (arbitrary units)
; RMAX     Semi-major axis (arbitrary units)
; PHI      Rotation angle of vector (deg) measured clockwise from Y axis.
; POS      Position angle of semi-major axis (deg),
;          measured counter-clockwise from the X axis.

x = rmin * cos(!dtor * phi)
y = rmax * sin(!dtor * phi)
cosang = cos(!dtor * pos)
sinang = sin(!dtor * pos)
xprime = x * cosang - y * sinang
yprime = x * sinang + y * cosang
distance = sqrt(xprime^2 + yprime^2)
return, distance

END
