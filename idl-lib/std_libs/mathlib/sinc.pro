function sinc, x

y = x*0 ; this is the output; initially set all elts to zero.

w = where(x) ; locations where x is NOT zero.
y[w] = sin(x[w])/x[w]

return, y

END