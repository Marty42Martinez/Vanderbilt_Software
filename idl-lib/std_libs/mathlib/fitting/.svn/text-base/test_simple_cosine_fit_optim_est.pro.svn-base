; test program to understand adding a single data point to a diurnal cycle.


; new data points
local = [6.67]
lwp = [70.22]
err = [17.4541]
Syinv = diag(1/err^2)

; prior knowledge on diurnal cycle
sd = [10.48,      8.14102,      9.75069,      7.82987,      5.67240]
sd[0] = 100.
xa = [64.3296, 11.3939, 7.41114, -2.17592, -2.25605]
sa = diag(sd^2)
Sainv = diag(1/sd^2)

Kt = cosine_basis(local,period=24., N=2)

; S = ( Kt Sy^-1 K + Sa^-1 )^-1
Sinv = (Kt ## (Syinv ## transpose(Kt)) + Sainv)
S = invert_symmetric(Sinv)
fit = S ## ( Kt ## (Syinv ## lwp) + Sainv ## xa )
fit = transpose(fit)

phi1 = atan(fit[1], fit[2]) * 24. / (2*!pi)
phi2 = atan(fit[3], fit[4]) * 12. / (2*!pi)
; fit = S (Kt Sy^-1 y + Sa^-1 xa)
print, fit

; now try fit cosine2

fit2 = fit_cosine2(lwp, local, yfit=yfit, period=24., $
	double=double,  Nc=2, meas_err = err, $
	xa=xa, Sa=Sa, /noconvert)

print, fit2
print, xa
END