function get_diag, A

;given a square matrix A, I return it's diagonal

n = n_elements(A[0,*])
out = A[0,*]
for i=1,n-1 do out[i] = A[i,i]

return, out

end