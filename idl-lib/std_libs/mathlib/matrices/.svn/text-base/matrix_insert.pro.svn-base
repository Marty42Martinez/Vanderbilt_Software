function Matrix_Insert, A, B, r

; A is a square MxM matrix
; B is a square NxN matrix (N GE M)
; r is an array of unique values (between 0 and N-1) of length M

; returns B, but with B[r,r] = A  (how it should be in IDL but isn't!)

m = n_elements(A[*,0])
N = n_elements(B[*,0])

out = B

for i= 0, m-1 do out[r[i],r] = A[i,*]

return, out

end