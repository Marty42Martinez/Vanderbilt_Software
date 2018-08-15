PRO plot_circle, lat, lon, radius, ratio, _extra = _extra, npoints=npoints

; lat, lon : in degrees - center of circle
; radius : in degrees, radius of circle
; ratio : makes it an ellipse, stretched by this factor in the lon direction

if n_elements(npoints) eq 0 then Npoints = 20
if n_elements(ratio) eq 0 then ratio = 1
angle = 2*!pi * findgen(npoints)/npoints
lats = lat + radius*sin(angle)
lons = lon + radius*cos(angle) * ratio
for i =0, npoints-1 do plots, lons[i], lats[i], cont=(i GT 0), _extra=_extra
plots, lons[0], lats[0], _extra=_extra, /cont

END


