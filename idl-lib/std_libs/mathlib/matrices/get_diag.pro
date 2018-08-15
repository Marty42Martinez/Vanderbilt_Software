function get_diag, A

;given a square matrix A, I return it's diagonal
; now works for A[n,n,npix]

n = n_elements(A[0,*,0])
npix = n_elements(A[0,0,*])
out = replicate(A[0,0], n, npix)
for i=1,n-1 do out[i,*] = A[i,i,*]

return, out

end
