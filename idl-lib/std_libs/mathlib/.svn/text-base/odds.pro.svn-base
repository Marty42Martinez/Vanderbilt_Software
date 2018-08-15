FUNCTION odds, integerarr

; PURPOSE
; returns the odd elements of an integer arrary.
; if array is floating point, will convert to long integers first, so beware!
; (but returns same type as original array)

N = n_elements(integerarr)
good = lonarr(N)
for i=0, N-1 do if not ((long(integerarr[i])/2) eq (integerarr[i]/2.0)) then good[i] = 1
return, integerarr(where(good))

END
