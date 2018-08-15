function circregmult, A, C, L=L

; c : row0 of the circulant matrix
; a : the matrix to multiply c by

; default : do C ## A

N = n_elements(c)
out = A*0.
if size(c,/type) eq 5 then out = double(out)
if n_elements(L) eq 0 then begin
	for row = 0,N-1 do out[*,row] = shift(c, row) ## A
endif else begin  ; we have an L, let's use it!
		; first do 2 corner pieces
		tri = c[N-L:*] ; last bit of row0
		tri = upper(circ(tri),/diag) ; this is my little triangular LxL matrix
		out2 = A * 0.
		out2[*,0:L-1] = tri ## A[*,(N-L):*]
		out2[*,(N-L):*] = transpose(tri) ## A[*,0:L-1]
		;now must form band-diag part
		sym = [c[N-L:*], c[0:L]]
		for row=0,L-1 do out[*,row] = sym[L-row:2*L]  ## A[*,0:row+L]
		for row=N-L,N-1 do out[*,row] = sym[0:(L+N-1-row)] ## A[*,row-L:*]
		for row=L,N-L-1 do out[*,row] = sym ## A[*,row-L:row+L]
		out = out + out2
endelse

return, out

end