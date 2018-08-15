function eigeninv, A, inverse=inverse, evec = evec, double=double

; this function computes the eigenvalues & eigenvectors
; of a symmetric matrix A using the QL method.  It
; uses this info to compute the inverse of A if there are no zero eigenvalues.

; Basically, this makes use of the fact that if you've taken the trouble
; to get the eigenvalues of something, you've also done the work necessary
; to get the inverse.

lambda = EIGENQL( A, /asc, double=double, eigenvector=evec)

bad = where(lambda eq 0.)
if bad[0] ne -1 then begin
	print, 'This matrix is singular.'
	return, lambda
endif
n = n_elements(A[*,0])
Dinv = fltarr(n,n)
for i = 0, n-1 do Dinv[i,i] = 1./lambda[i]

inverse = transpose(evec) ## (Dinv ## evec)

return, lambda

END

