FUNCTION Gauss, x, av, sd

; Returns the gaussian distribution value of x for a gaussian with mean 'av', and
; standard deviation sd.

n = n_elements(x)
w = where( abs(x-av)/sd LE 10) ;where within 10 standard deviations
g = fltarr(n)

g[w] = 1/(sd*sqrt(2*!pi))*exp(-0.5*((x[w]-av)/sd)^2)

return, g
END