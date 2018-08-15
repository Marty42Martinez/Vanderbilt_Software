function randome, seed, n, mu

	if n_elements(mu) eq 0 then mu = 1.
	ONE = 1.d
	r = randomu(seed, n)
	x = mu * alog(ONE/(ONE-r))

	return, x

END


;amato's problem
; let's say we have an exponential distribution

; P(x) = 1/xbar * exp(-x/xbar)
; the mean of P(x) is xbar.

n = 10 ; # of points to draw from the parent distribution
M = 1000LL ; # of times to simulate the process.

xmean = 0.30 ; true mean of the parent distribution

x = randome(seed, M*n, xmean)
;x = randomn(seed, M*n) + xmean
mu = fltarr(M)
std = fltarr(M)

for i = 0L, M-1 do begin
	this = x[i*n : n*(i+1)-1]
	mu[i] = mean(this) ; get mean of daughter distribution
	std[i] = stddev(this) ; get standard dev of daughter distribution
endfor

hist, mu, xtit = 'Mean value for each simulation', ytit = '# of simulations with that mean'
print, "Actual 1-sigma error on the mean using " + $
	strcompress(string(n),/r) + ' points is ' + string(stddev(mu))

print, "Average estimated 1-sigma error from Gaussian formula is: " + $
	string(mean(std)/sqrt(n))


END

