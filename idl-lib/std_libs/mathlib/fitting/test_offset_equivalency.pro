; little batch to test equivalence of offset-removal mods to covariance matrix

err = [1.,3., 2.]
S = diag(err^2)
n = n_elements(err)
Sinv = diag(1./err^2)

e = transpose(fltarr(n) + 1.)
et = transpose(e)
I = identity(n)
PI_1 = I - e ## (1./(et ## e)[0] * et)
PI = I - 1./(et ## (Sinv ## e))[0] * (e ## (et ## Sinv))

C_1 = PI_1 ## (S ## transpose(PI_1))
C = PI ## S

Cinv = Sinv ## PI ; this is the normal one


; eigenvalues:
print, 'C eigenvalues = ', eigen(C, /sym)
print, 'C_1 eigenvalues = ', eigen(C_1, /sym)

; is this also the "inverse" of C_1?
; test usual relationship
print
print, PI ## (C ## Cinv - I)
print
; test new relationship
print, PI_1 ## (C_1 ## Cinv - I)
print
; another version of the new relationship
print, PI ## (C_1 ## Cinv - I)

; yet another version of the new relationship
print, PI_1 ## (C ## Cinv - I)



END