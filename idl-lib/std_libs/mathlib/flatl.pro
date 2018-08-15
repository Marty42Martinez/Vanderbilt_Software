function flatL, x, cov, delta, double=double, verbose=verbose

; Returns the liklihood L of data vector x and covariance matrix:
;
; C = Cth + Cdat  (where Cth = delta^2 * Identity Matrix)
; this is about the simplest of all liklihoods
; normalizes to the maximum liklihood

v = keyword_set(verbose)

	Cth = Identity(n_elements(x),double=double)
nd = n_elements(delta)
logL = fltarr(nd)
if keyword_set(double) then logL = double(logL)

if v then begin
progressBar = Obj_New("SHOWPROGRESS", message='Computing Likelihood...',color='GREEN')
progressBar->Start
endif

for i=0,nd-1 do begin
	;if v then print, 'delta = ', i

	A = Cov + delta[i]^2 * Cth
	choldc, A, p, double=double ; now the lower triangle of A contains the lower triangle of L
										 ; p is the diagonal of L
	logdetsqM = total(alog(p)) ; this is the log of sqrt of the determinant of M (trace of log(L))

	y = cholsol(A,p,x , double=double)
	yyt = total(x * y)

	logL[i] = -0.5 * yyt - logdetsqM
	if v then progressBar->Update, fix((i+1.)/float(nd)*100)
endfor

if v then begin
 progressBar->Destroy
 Obj_Destroy, progressBar
 @startup
endif

if n_elements(logL) eq 1 then logL = logL[0]

M = max(logL)
maxL = delta[where( logL eq M)]
L = exp(logL-max(logL))

return, L

end