N = 10000

ra = randomu(seed, N)*360
dec = randomu(seed, N)*180 - 90.

jd0 = 2452415.0
jd = jd0 + randomu(seed, N)*80.*365. - 40.

eq2hor, ra, dec, jd, alt, az
hor2eq, alt, az, jd, ra2, dec2

end