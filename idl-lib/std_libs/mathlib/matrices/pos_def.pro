function pos_def, M, craziness=craziness

; checks to see if the square matrix M is positive definite or not

M_ = M
TRIRED, M_, D, E
; Compute the eigenvalues (returned in vector D) and
; the eigenvectors (returned in the rows of the array A):
TRIQL, D, E, M_

w = where(D LT 0.)
if w[0] ne -1 then out = 0 else out = 1
craziness = min(abs(D))/max(abs(D))
return, byte(out)

end