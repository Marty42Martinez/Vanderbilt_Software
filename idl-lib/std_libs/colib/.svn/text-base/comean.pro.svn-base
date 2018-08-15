function comean, x, err=err, werr=werr, sdom=sdom

; can handle single-element arrays!
; AND it can handle error propagation

N = n_elements(x)
if n_elements(err) eq 0 then errors=0 else errors=1

if not errors then begin
	if N eq 1 then begin
		m=x
		sdom = x
	endif	else begin
		m = mean(x)
		sdom = stddev(x)/N
	endelse
endif else begin
	if N eq 1 then begin
		m = x
		werr = err
		sdom = err
	endif else begin
		w = 1./err^2
		wtot = total(w)
		m = total(x*w)/wtot
		werr = sqrt(1/wtot)
		sdom = stddev(x)/N
	endelse
endelse

return, m[0]

end