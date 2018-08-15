function covar, x1, x2, expand=expand
; unnormalized covariance (as a function of lag)

; x1 the first function
; x2 the second function (must be same length as the first)
; m the # of time lags to evaluate at
; this will only evaluate out to ~ 1/2 the length of the vector, which is usually plenty far.

; expand : make covar have same # of elements as original vector

N = n_elements(x1)
if n_params() lt 2 then begin
	X1_ = fft(x1)
	X2_ = X1_
	s1 = sigma(x1)
	s2 = s1
endif else begin
	X1_ = fft(x1)
	X2_ = fft(x2)
	s1 = sigma(x1)
	s2 = sigma(x2)
endelse
cc = float(fft(X1_*conj(X2_),/inverse))
out = cc[0:(N/2.0-1)]
if keyword_set(expand) then begin
	N10 = N/10
	cc = fltarr(N) + mean(cc[(N/2-N10):(N/2)])
	cc[0:(N/2.0-1)] = out
	out = cc
endif

return, out

end