function ChiSqDiff, x1, x2, N1, N2, singular=singular, old=old, quiet=quiet, $
			verbose=verbose, pvalue=pvalue

; Procedure does a simple chi-squared test to see if x1-x2
; is consistent with noise.

; want this to work even if N1 or N2 have modes removed.
; somehow must specify if you made those eigenvalues 0 or infinity.
; i imagine it will matter.


x = x1 - x2 ; these are ROW vectors
N = N1 + N2
D = n_elements(x)

eta= 1.0e2*(stddev(N))/D
if keyword_set(singular) then N = N + eta

if keyword_set(old) then begin
		chi = x ## ( invertspd(N,/doub) ## transpose(x))
endif else begin
	choldc, N, p, /double ; now the lower triangle of N contains the lower triangle of L
										 ; p is the diagonal of L
	;		logdetsqM = total(alog(p)) ; this is the log of sqrt of the determinant of M (trace of log(L))
	y = cholsol(N,p,x, /double)
	chi = total(x * y)
endelse

pvalue = 1-chisqr_pdf(chi, D - keyword_set(singular))

if n_elements(quiet) eq 0 then print, 'Chi-Squared Equals: ', chi, '    P-Value Equals    : ', pvalue

return, chi

end