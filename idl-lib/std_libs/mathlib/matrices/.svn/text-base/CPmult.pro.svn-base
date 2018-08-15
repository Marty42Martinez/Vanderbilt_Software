function CPmult, Q, P

; Computes the fast product of a matrix with a "Pol-Type Circulant Matrix"
;
; Q should probably be symmetric.  not sure if it will work otherwise.

; INPUTS
; 	 Q = symmetric n x n matrix (n is even!)
; 	 P = poltype circulant n x n matrix
;
; OUTPUTS
; the product P ## Q
;
;
; P is of the following form:
;       | A  Y |
;	P = | -Y B |
;  where A, Y, and B are all circulant, m x m matrices (m= n/2)


n = n_elements(P[*,0])
m = n/2

A = P[0:m-1,0] ; row of upper left matrix
Y = P[m:*,0] ; row of upper right matrix
;r1c = P1[0:m-1,m] ; row of lower left matrix
B = P[m:*,m] ; row of lower right matrix

fA = fft(A)
fB = fft(B)
fY = fft(Y)
outv = P[*,0]*0 ; dummy vector to hold out vectors
out = P*0
for v = 0,n-1 do begin ; cycle through vectors of Q
	x = Q[*,v] ; vth (row) vector of Q
	f1 = fft(x[0:m-1])
	f2 = fft(x[m:*])
	outv[0:m-1] = m*real(fft(fA*f1,/inverse) - fft(fY*f2,/inverse))
	outv[m:*] = m*real(fft(fY*f1, /inverse) + fft(fB*f2,/inverse))
	out[*,v] = outv
END

return, out

END
