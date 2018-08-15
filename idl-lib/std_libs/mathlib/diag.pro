function diag, p

; given a vector p, i return a (square) diagonal matrix with p along the diagonal

n = n_elements(p)
out = replicate(p[0]*0,n,n)
for i=0,n-1 do out[i,i] = p[i]

return, out

end