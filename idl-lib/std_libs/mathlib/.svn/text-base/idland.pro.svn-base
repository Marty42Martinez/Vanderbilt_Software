function IDLand, x1, x2

; x1 and x2 are vectors
; returns the vector of elements that are common between both (multiples not counted).

; not very efficient...

n1 = n_elements(x1)
n2 = n_elements(x2)

if n2 gt n1 then begin
	x = x1
	y = x2
	Nx = n1
	Ny = n2
endif else begin
	x = x2
	y = x1
	Nx = n2
	Ny = n1
endelse

out = x * 0.

; x has the shorter array, y has the longer array.
cur = 0
for i = 0, Nx-1 do begin ; (cycle through the shorter array).
	if  elt(x[i],y) then begin
		out[cur] = x[i]
		cur = cur+1
	endif
endfor

if cur GT 0 then out = out[0:cur-1] else out = -1

return, out

end

