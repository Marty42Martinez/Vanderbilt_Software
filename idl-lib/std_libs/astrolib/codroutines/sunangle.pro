jd = JulianDate('06/22/00','12:59:00')
lat = 43.0783
lng = 89.685
d2r = 3.141592645/180.
ct2lst, lst, -1*lng, 5, jd  ; get LST (in hours)
lst = lst*!dpi/12. ; convert LST to radians

sunpos, jd, sunra, sundec, /rad

sh = sin(lat*d2r)*sin(sundec) + cos(lat*d2r)*cos(sundec)*cos(lst-sunra)
h = asin(sh)
print, 'El = ', h/d2r, ' degrees'

end