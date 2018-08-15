function rcs, x, errs, nomean = nomean, prob=prob

; calculates the simple reduced chi-squared of array x with errors errs.
; 	(ie, your model is that x = 0)

; nomean : subtract off the mean (ie, your model is x = mean(x) )

N  = n_elements(x)
df = N
if keyword_set(nomean) then begin
	m = mean(x)
	rcs_ = 1.0/(N-1.)*total( ((x-m)/errs)^2 )
	df = N-1
endif else begin
	rcs_ = 1./N * total( (x/errs)^2 )
endelse

if keyword_set(prob) then begin
	print, 'The probability of exceeding this RCS is ',rcsprob(rcs_,df)
endif
return, rcs_

end