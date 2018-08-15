function reindex, M, order

; M is a Symmetric matrix (meant to be a covariance matrix).
; order is the new ordering in terms of the old ordering.
;
; return value: M in the new ordering.

N = n_elements(M[*,0])
R = M

for row = 0,N-1 do R[order,order[row]] = M[*,row]

return, R
end