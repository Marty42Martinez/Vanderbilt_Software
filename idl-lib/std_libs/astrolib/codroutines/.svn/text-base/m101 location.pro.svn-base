; batch file to find AZ, EL of M101

 jd = juliandate('05/05/2003','16:58:40', tz=4)

; M101 Coordinates
ra = ten(14,3,12.7)*15
dec = ten(54.,20.,54.)

; FCRAO Coordinates
LAT = ten(43,23.5,0)
LON = -ten(72,20.7,0)

eq2hor, ra, dec, jd, alt, az, lat=lat, lon=lon, /verb

print, az, alt
END