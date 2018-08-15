function Pmult, P1,P2

; P1: 1st P-matrix
; P2: 2nd P-matrix

; This routine uses the known properties of the
; P-matrices to compute their fast product
; hopefully it is faster than the native IDL
; multiplication routine!

; returns : row 0 of mult matrix

n = n_elements(P1[*,0])
m = n/2

A = P1[0:m-1,0] ; row of upper left matrix
X = P1[m:*,0] ; row of upper right matrix
;r1c = P1[0:m-1,m] ; row of lower left matrix
B = P1[m:*,m] ; row of lower right matrix

C = P2[0:m-1,0] ; row of upper left matrix
Y = P2[m:*,0] ; row of upper right matrix
;r2c = P2[0:m-1,m] ; row of lower left matrix
D = P2[m:*,m] ; row of lower right matrix

xy = circmult(X,Y)
F1 = circmult(A,C) - xy
F2 = circmult(A,Y) + circmult(X,D)
F3 = -circmult(X,C) - circmult(B,Y)
F4 = -xy + circmult(B,D)


P12 = P1*0.
for pix=0,m-1 do begin
	P12[0:m-1,pix] = shift(F1,pix)
	P12[m:*,pix] = shift(F2,pix)
	P12[0:m-1,pix+m] = shift(F3,pix)
	P12[m:*,pix+m] = shift(F4,pix)
endfor

return, P12

END
