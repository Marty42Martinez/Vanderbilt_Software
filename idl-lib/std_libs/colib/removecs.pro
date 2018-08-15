function removecs, y

; y is an array of [Q,Nhf] Q=9000.
; removes a cubic spline fitted to each hour file average.

Q = long(n_elements(y[*,0]))
ymean = total(y,1)/Q
nhf = n_elements(y[0,*])
N = n_elements(y)
xmean = lindgen(nhf)*Q + Q/2
x = lindgen(N)
return, y - spline(xmean,ymean,x)

end

