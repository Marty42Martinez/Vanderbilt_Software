function dum_function, p, x, deriv=deriv

sinx = sin(x)
cosx = cos(x)
deriv = fltarr(n_elements(p), n_elements(x))
deriv[0, *] = sinx
deriv[1, *] = cosx
return, p[0] * sinx + p[1] * cosx

END


