PRO wis_box, limit, _extra=_extra

; LIMIT : [lat0, lat1, lon0, lon1]

lat0 = limit[0]
lat1 = limit[1]
lon0 = limit[2]
lon1 = limit[3]
if lon0 GE 180 then lon0 = lon0-360
if lon1 GE 180 then lon1 = lon1-360

plots, limit[2], limit[0], _extra=_extra
plots, limit[2], limit[1], _extra=_extra, /cont
plots, limit[3], limit[1], _extra=_extra, /cont
plots, limit[3], limit[0], _extra=_extra, /cont
plots, limit[2], limit[0], _extra=_extra, /cont

END