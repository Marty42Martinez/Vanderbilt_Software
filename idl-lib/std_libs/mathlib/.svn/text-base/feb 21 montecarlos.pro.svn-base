; more monte-carloing

D = 100 ; length of delta
M = 100 ; # of liklihoods to montecarlo
n = 100 ; amount of data in each map

delta = findgen(D)
r = 50*randomn(seed, n)
noise = fltarr(n) + stddev(r)
plot, flatL(r,noise,delta)
climit = fltarr(M)
sigma = fltarr(M)
likes = fltarr(M,D)
for i = 0, M-1 do begin
	print, i+1, '/',M
	r = 50*randomn(seed, n)
	sigma[i] = stddev(r)
	noise = fltarr(n) + sigma[i]
	L = flatL(r,noise,delta)
	Likes[i,*] = L
	oplot, L , col = 2*i
	climit[i] = confidencelimit(L,0.68)
endfor

end