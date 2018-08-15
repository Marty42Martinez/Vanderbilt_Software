; this program tests the speed of my code
N = 3e4
ra = randomu(seed, N, /double) * 360.0
dec = randomu(seed,N, /double) * 180 - 90.
temp = randomu(seed, N)*20. + 273.

jd0 = juliandate('1/1/00','12:00:00', tz=0)
jd = randomu(seed,N,/double)*365.25*80 - 40.0 + jd0

eq2hor, ra, dec, jd, alt, az, temp=temp, ref=0, nut=0, pre=0, ab=0

END