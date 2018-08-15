; for fun, calculate, sun max altitudes over observing times

d2r = !dpi/180.
lat = 43.0783
jd0 = juliandate('03/16/00','10:00:00',tzone=6.)
jd1 = juliandate('05/30/00','07:00:00',tzone=5.)

n = 10001

jd = (jd1-jd0)/double(n-1)*dindgen(n) + jd0
sunpos, jd, sunra, sundec, /rad
maxalt = asin(sin(lat*d2r)*sin(sundec)+cos(lat*d2r)*cos(sundec))/d2r

end