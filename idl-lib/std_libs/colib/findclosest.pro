function findclosest, x, data, n=n

; Finds the n closest occurrences in data array to the value x.
; if n is 1 (default), returns, a scalar, otherwise returns a vector with n elements.
; returns the indices of the closest elements, not the elements themselves!

if not keyword_set(n) then n=1
residuals = abs(data-x)
if n eq 1 then begin
    m = min(residuals, p)
	return, p
endif else return, (sort(residuals))[0:(n-1)]

END

