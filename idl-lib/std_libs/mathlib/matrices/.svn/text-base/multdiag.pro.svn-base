function multdiag, A,d

; multiplies a diagonal matrix d by a square matrix A of the same size

n = n_elements(d[0,*])

out= A

for c = 0,n-1 do out[c,*] = d[c,c]*A[c,*]
return, out

end