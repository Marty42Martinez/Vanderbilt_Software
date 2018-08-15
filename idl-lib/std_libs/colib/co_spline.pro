function co_spline, X, Y, A, sigma

; X the known x-values
; Y the known y-values
; A the abcissa values for which the Y should be calculated

sx = sort(X)
s = sort(A) ;

if n_elements(sigma) eq 0 then $
	spl = spline(X[sx],Y[sx],A[s]) $
else  spl = spline(X[sx],Y[sx],A[s], sigma)

; now I need the "de-sorted" array!

return, spl[sort(s)]

end