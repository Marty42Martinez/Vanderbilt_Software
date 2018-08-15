function chisq, x, errs, nomean = nomean, p=p

; calculates the simple reduced chi-squared of array x with errors errs.
; 	(ie, your model is that x = 0)

; nomean : subtract off the mean (ie, your model is x = mean(x) )

N  = n_elements(x)

if n_elements(errs) eq 0 then errs = x*0. + 1.
if size(errs, /n_dim) eq 2 then err = sqrt(get_diag(errs)) else err = errs
if keyword_set(nomean) then begin
	m = mean(x)
	rcs = 1.0/(N-1.)*total( ((x-m)/errs)^2 )
	p = 1-chisqr_pdf(rcs*(N-1),N-1)
endif else begin
	rcs = 1./N * total( (x/err)^2 )
	p = 1-chisqr_pdf(rcs*N,N)
endelse

return, rcs

end