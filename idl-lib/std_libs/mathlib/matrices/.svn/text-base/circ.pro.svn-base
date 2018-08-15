function circ, row0

; given the 0th row of a circulant matrix, form the whole matrix

n = n_elements(row0)
out =replicate(row0[0], n,n)
out[*,0] = row0
for i = 1,n-1 do out[*,i] = shift(out[*,i-1],1)

return, out

end