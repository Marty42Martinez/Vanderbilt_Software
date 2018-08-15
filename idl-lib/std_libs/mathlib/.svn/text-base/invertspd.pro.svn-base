function invertSPD, A, double=double

; A is symmetric and postive-definite.

; returns the inverse of A
type = size(A,/type)
N = n_elements(A[0,*])
if keyword_set(double) then b = dblarr(N) else b=fltarr(N)
I = diag(b+1.)
if keyword_set(double) then A_ = double(A) else A_=A

Ainv = A_*0.
choldc, A_, p, double=double
b[0] = 1
Ainv[0,*] = cholsol(A_, p, b, double=double)
for col = 1,N-1 do begin
	b[col-1]=0 & b[col] = 1
	Ainv[col,*] = cholsol(A_, p, b,double=double)
endfor

;if type eq 4 then Ainv = float(Ainv)
return, Ainv

end