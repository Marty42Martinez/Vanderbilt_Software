function lower, A, diagonal=diagonal

; returns the lower triangle of a sqruare matrix A, and optionally the diagonal
;
; diagonal : setting this will keep the diagonal in the returned matrix
N= n_elements(A[*,0]) ; # of columns

out = A

if keyword_set(diagonal) then x=1 else x=0

for c=x,N-1 do out[c,0:c-x] = 0.

return, out

end