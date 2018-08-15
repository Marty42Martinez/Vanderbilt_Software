function EBLike_E, q,u,qcov,ucov,ctheory, e=e, double=double, npix=npix,$
				verbose=verbose, maxL=maxL, pixels=pixels, singular=singular

; Returns the 1D liklihood L of data vector (q,u) and covariance matrix,
; given the theory cov matrix Ctheory.
;
; C = Cth + Cdat  (where Cth = sE^2 * E), works as well for B.
;
; this assumes flat band-power in l-space.  it's a 1D liklihood.
;
; normalizes to the maximum liklihood

; VARIABLES:
;	q, u : the q and u maps
;  qcov, ucov : the q and u covariance matrices
;  Ctheory: theory cov matrix (2npix x 2npix)
;
; KEYWORDS
;  E :  vector of E values (in micro-kelvins) to be calculated
;  double : force computation to be done in double-precision
;  verbose : print some shit out
;  maxL : will contain the location (1-dim form) of the maximum of the liklihood function
;  pixels : vector of pixel indices used in maps (must have same # of elements as maps)
;  npix : the pixelization required


if keyword_set(verbose) then v = 1 else v =0

if n_elements(E) eq 0 then E = findgen(25) * 2

N_e = n_elements(E)
logL = dblarr(N_e)
N = n_elements(pixels)

if n_elements(pixels) eq 0 then pixels = indgen(N)

eta= 1e2*(stddev(qcov) + stddev(ucov))/N
if n_elements(singular) eq 0 then eta = eta*0.

Cs = matrix_extract(Ctheory,[pixels,npix+pixels])
cdat = dblarr(2*N,2*N)
cdat[0:N-1,0:N-1] = qcov + eta
cdat[N:*,N:*] = ucov + eta
ydat = [q,u]


; Now we have Cdat and Cs!  Can calculate liklihoods now.

;****************************************************************
; THIS PART ZEROES THE QU PART OF Ctheory!!! (FOR TESTING ONLY)
;CE[0:N-1,N:*] = 0.
;CE[N:*,0:N-1] = 0.
;CB[0:N-1,N:*] = 0.
;CB[N:*,0:N-1] = 0.
;****************************************************************

if v then begin
  pBar = Obj_New("SHOWPROGRESS", message='Computing 1D Likelihood',color='GREEN')
  pBar->Start
endif
for i=0,N_e-1 do begin	; cycle through e-values
	A = Cdat + E[i]^2 * Cs  ; form full covariance matrix (data + theory)
	choldc, A, p, double=double ; now the lower triangle of A contains the lower triangle of L
									 ; p is the diagonal of L
	logdetsqM = total(alog(p)) ; this is the log of sqrt of the determinant of M (trace of log(L))
	y = cholsol(A,p,ydat, double=double)
	yyt = total(ydat * y)
	logL[i] = -0.5 * yyt - logdetsqM
	if v then pBar->Update, fix((i+1.)/N_e*100)
endfor
if v then begin
	pBar->Destroy
	Obj_Destroy, pBar
endif

if n_elements(logL) eq 1 then logL = logL[0]

M = max(logL)
maxL = where(logL eq M)
if keyword_set(unnormalize) then L = exp(logL) else L = exp(logL-M)

return, L

end