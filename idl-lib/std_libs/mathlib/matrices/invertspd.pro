function invertspd, A, double=double, diagonal=diagonal, verbose=verbose

; A is symmetric and postive-definite.

; returns the inverse of A using Choleski decomposition
v = keyword_set(verbose)

type = size(A,/type)
N = n_elements(A[0,*])
I = identity(N, double=double)
if keyword_set(double) then A_ = double(A) else A_=A
s = 1./stddev(A_)
A_ = s * A_
ns = strcompress(string(n), /rem)

if v then begin
progressBar = Obj_New("SHOWPROGRESS", message='Inverting '+ns+' by '+ns+' Matrix',color='GREEN')
progressBar->Start
endif

if keyword_set(diagonal) then begin
	Ainv = A * 0.
	for i = 0, N-1 do Ainv[i,i] = 1./A[i,i]
endif else begin
if n_elements(A_) eq 1 then begin
	Ainv = 1./A_
endif else begin
	b = A[*,0] * 0.
	Ainv = A_*0.
	la_choldc, A_, double=double, status=status ; get the choleski factorization
	if status ne 0 then begin
		print, 'Problem with Choleski Factorization of A!'
		print, 'The leading minor eigenvalue is : ', status
		print, 'The eigenvalues of A are: '
		print, eigen(A)
		print, 'Quitting...'
		STOP
	endif
	b[0] = 1
	Ainv[0,*] = la_cholsol(A_, b, double=double)
	for col = 1,N-1 do begin
		b[col-1]=0 & b[col] = 1
		Ainv[col,*] = la_cholsol(A_, b,double=double)
		if v then progressBar->Update, fix((col+1.)/float(N)*100)
	endfor
endelse
endelse

if v then begin
 progressBar->Destroy
 Obj_Destroy, progressBar
endif

;if type eq 4 then Ainv = float(Ainv)
return, Ainv*s

end