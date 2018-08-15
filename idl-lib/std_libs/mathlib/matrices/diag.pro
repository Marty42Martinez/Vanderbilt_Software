function diag, p

; given a vector p, i return a (square) diagonal matrix with p along the diagonal
; now works for [n,nmatrices]

nmatrix = n_elements(p[0,*])
n = n_elements(p[*,0])
out = fltarr(n,n,nmatrix) + p[0]*0.0

for i=0,n-1 do out[i,i,*] = p[i,*]

return, out

end
