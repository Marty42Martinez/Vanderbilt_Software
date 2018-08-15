function mult2D, array, i, normalize = normalize

; multiplies all the elements in the same dimension together of an input array,
; returns the vector of 1 lower dimension containing the multiplies

; i should be 0 or 1

if i eq 1 then begin
	M = reform(array[0,*])
	n = n_elements(M)
	for j=0,n-1 do M[j] = cmproduct(double(reform(array[*,j])))
endif else begin
	M = reform(array[*,0])
	n = n_elements(M)
	for j=0,n-1 do M[j] = cmproduct(double(reform(array[j,*])))
endelse
if keyword_set(normalize) then M = M/max(M)
return, M

end

