function cor, x1, x2

; x1 the first function
; x2 the second function (must be same length as the first)
; m the # of time lags to evaluate at
; this will only evaluate out to ~ 1/2 the length of the vector, which is usually plenty far.

N = n_elements(x1)
if n_params() lt 2 then x2 = x1
X1_ = fft(x1-mean(x1))
X2_ = fft(x2-mean(x2))
s1 = sigma(x1)
s2 = sigma(x2)
cc = fft(X1_*conj(X2_),/inverse)
cc = cc/(s1*s2)
cc = real(cc[0:(N/2.-1)])

return, cc

end