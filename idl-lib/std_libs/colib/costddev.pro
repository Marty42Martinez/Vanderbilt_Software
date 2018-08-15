function costddev, x, weights=weights, xbar=xbar

; can handle single-element arrays, and weights!
Nx = n_elements(x)
if Nx eq 1 then begin
	m=0.
	xbar = x[0]
endif else begin
	if n_elements(weights) eq 0 then m = stddev(x) else begin
		w = weights / total(weights)
		xbar = total(w*x)
		m = sqrt( 1./(Nx-1.)*total(w * (x-xbar)^2) )
	endelse
endelse
return, m[0]
end