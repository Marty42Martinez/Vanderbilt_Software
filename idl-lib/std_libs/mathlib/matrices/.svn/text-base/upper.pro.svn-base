function upper, A, diagonal=diagonal

; returns the upper triangle of a square matrix A, and optionally the diagonal
;
; diagonal : setting this will keep the diagonal in the returned matrix

N = n_elements(A[0,*]) ; # of rows

out = A

if keyword_set(diagonal) then x=1 else x=0

for r=x,N-1 do out[0:r-x,r] = 0.

return, out

end