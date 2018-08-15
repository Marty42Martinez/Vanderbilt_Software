FUNCTION constraint_matrix, ny, modes, Zfull = Zfull, double = double

; ny is the number of elements in the data vector.
; returns a ny by ny (square) constraint matrix.
; form the constraint matrix that removes the POLYNOMIAL modes specified, from
; 0 (offset), 1 (slope) to n_elements(y) - 1 (highest order polynomial possible in this data set).

; i've made it so the removed modes ARE orthonormal!

nm = n_elements(modes)
d = keyword_set(double)
for i = 0, nm-1 do begin
	m = modes[i] ; this is the mode to remove
	z = transpose((findgen(ny))^m) ; make z the column vector you want!
	if d then z = double(z)
	; first you want to guarantee orthogonality
	if i gt 0 then begin
		for j = 0, i-1 do begin	; make current mode orthogonal to jth mode
			zj = zfull[j,*]
			z = z - total(zj * z) * zj
		endfor
	endif
	z = z/sqrt(total(z^2)) ; normalize this z
	if i eq 0 then Zfull = z else Zfull = [Zfull, z]
endfor

; test orthonormality of the whole thing
;print, 'Z^t Z = ', transpose(zfull) ## zfull

return, zfull ## transpose(zfull)

END