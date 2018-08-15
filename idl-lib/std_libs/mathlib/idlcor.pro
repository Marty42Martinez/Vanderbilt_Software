function idlcor, x1, x2, M

; x1 the first function
; x2 the second function (must be same length as the first)
; m the # of time lags to evaluate at
; this will only evaluate out to ~ 1/2 the length of the vector, which is usually plenty far.


if n_params() lt 3 then begin
	M = x2
	out = fltarr(M)
	for i=0,M-1 do out[i] = a_correlate(x1,i[0])
endif else begin
	out = fltarr(M)
	for i=0,M-1 do out[i] = c_correlate(x1,x2,i[0])
endelse

return, out
end