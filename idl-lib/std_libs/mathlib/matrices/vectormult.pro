function vectormult, A, B

; A : a vector of matrices, such as [npix, ncol, nrow1]
; B : another vector of matrices, such as [npix, ncol, nrow2]

; return, vector of AxB matrices, [npix, nrow2, nrow1]

npix = n_elements(A[*,0,0])
ncol = n_elements(A[0,*,0])
ncol2 = n_elements(B[0,*,0])
nrow1 = n_elements(A[0,0,*])
nrow2 = n_elements(B[0,0,*])

if ncol ne ncol2 then begin
	print, 'Error: # of cols of A and B not equal!'
	RETURN, -1
endif

B_ = transpose(B, [0,2,1])
out = make_array(npix, nrow2, nrow1, type=size( A[0,0,0]*B[0,0,0], /type ) )
for i = 0, nrow1-1 do for j = 0, nrow2-1 do out[*,j,i] = total( A[*,*,i] * B_[*,*,j], 2 )

return, out

END
