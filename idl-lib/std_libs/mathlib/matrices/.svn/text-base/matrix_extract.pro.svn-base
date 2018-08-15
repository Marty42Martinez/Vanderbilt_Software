function Matrix_Extract, M, r

; M is a square NxN matrix
; r is an array of unique values (between 0 and N-1),
;	which tells me what part of M to keep

; return value : M[[r],[r]]  (how it should be in IDL but isn't!)
nr = n_elements(r)
N = n_elements(M[*,0])
out = M[0:nr-1,0:nr-1]

for row = 0, nr-1 do out[*,row] = M[r,r[row]]

return, out

end