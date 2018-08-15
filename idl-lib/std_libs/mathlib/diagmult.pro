function diagmult, d, A

; multiplies a diagonal matrix d by a square matrix A of the same size

n = n_elements(d[0,*])

out= A

for r = 0,n-1 do out[*,r] = d[r,r]*A[*,r]
return, out

end