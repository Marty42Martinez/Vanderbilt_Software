function Uinvert, U

; returns the inverse of an upper triangular matrix U, using back substitution.

N = n_elements(U[*,0])
B = upper(U) + diag(1./get_diag(U)) ; now only need off-diag terms

for c = 1, N-1 do for r=c-1,0,-1 do B[c,r] = -1*B[r,r]*total(U[r+1:c,r]*B[c,r+1:c])

return, B

end
