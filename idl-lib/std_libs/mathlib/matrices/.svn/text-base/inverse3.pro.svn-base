function inverse3, A

; A : a vector of matrices, such as [npix, ncol, nrow1]

; return, vector of inverse(A) matrices, [npix, nrow2, nrow1], such that each
; matrix in the vector is the inverse of the corresponding matrix in the vector A

npix = n_elements(A[*,0,0])
ncol = n_elements(A[0,*,0])
nrow = n_elements(A[0,0,*])

if ncol ne nrow then begin
	print, 'Error: Matrices are not square!'
	RETURN, -1
endif

out = A*0.
det = a[*,0,0]*(a[*,2,2]*a[*,1,1]-a[*,1,2]*a[*,2,1]) - $
	  a[*,0,1]*(a[*,2,2]*a[*,1,0]-a[*,1,2]*a[*,2,0]) + $
	  a[*,0,2]*(a[*,2,1]*a[*,1,0]-a[*,1,1]*a[*,2,0])

idet = 1./det

out[*,0,0] = idet*(a[*,2,2]*a[*,1,1] - a[*,1,2]*a[*,2,1])
out[*,1,0] = idet*(a[*,1,2]*a[*,2,0] - a[*,2,2]*a[*,1,0])
out[*,2,0] = idet*(a[*,2,1]*a[*,1,0] - a[*,1,1]*a[*,2,0])
out[*,0,1] = idet*(a[*,0,2]*a[*,2,1] - a[*,2,2]*a[*,0,1])
out[*,1,1] = idet*(a[*,2,2]*a[*,0,0] - a[*,0,2]*a[*,2,0])
out[*,2,1] = idet*(a[*,0,1]*a[*,2,0] - a[*,2,1]*a[*,0,0])
out[*,0,2] = idet*(a[*,1,2]*a[*,0,1] - a[*,0,2]*a[*,1,1])
out[*,1,2] = idet*(a[*,0,2]*a[*,1,0] - a[*,1,2]*a[*,0,0])
out[*,2,2] = idet*(a[*,1,1]*a[*,0,0] - a[*,0,1]*a[*,1,0])

return, out

END
