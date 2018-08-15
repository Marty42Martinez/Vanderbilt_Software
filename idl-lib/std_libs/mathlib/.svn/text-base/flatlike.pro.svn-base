function FlatLike, q,u,qcov,ucov,Sig=Sig, double=double, verbose=verbose, maxL=maxL, pixels=pixels, $
	npix=npix, singular=singular, logdetsqM =logdetsqM, l1 = l1, l2 = l2, svd=svd

; Returns the liklihood L of data vector (q,u) and covariance matrix:

; C = Cth + Cdat  (where Cth = sE^2 * E + sB^2 * B)
;
; this assumes flat band-power in l-space.  it's a 2D liklihood (depends on sE and sB)
;
; normalizes to the maximum liklihood

; VARIABLES:
;	q, u : the q and u maps
;  qcov, ucov : the q and u covariance matrices
;
; KEYWORDS
;  E :  vector of E values (in micro-kelvins) to be calculated
;  B :  vector of B values (in micro-kelvins) to be calculated
;  double : force computation to be done in double-precision
;  verbose : print some shit out
;  maxL : will contain the location (1-dim form) of the maximum of the liklihood function
;  pixels : vector of pixel indices used in maps (must have same # of elements as maps)
;  npix : the pixelization required
;  offset : the q or u data covariance matrix offset


if keyword_set(verbose) then v = 1 else v =0

if n_elements(Sig) eq 0 then S = findgen(100) else S = sig

N_s = n_elements(S)

logL = dblarr(N_s)
l1 = logL
l2 = logL

N = n_elements(q)  ; the # of q-values

if n_elements(npix) eq 0 then npix = 360

CS = identity(2*npix,double=double)

if n_elements(pixels) eq 0 then pixels = indgen(N)
CS = matrix_extract(CS,[pixels,npix+pixels])

; CREATE FULL DATA COVARIANCE MATRIX
if keyword_set(double) then Cdat = dblarr(2*N,2*N) else Cdat = fltarr(2*N,2*N)

Cdat[0:N-1,0:N-1] = qcov
Cdat[N:*,N:*] = ucov

eta=1e4*(stddev(qcov) + stddev(ucov))/N
if keyword_set(singular) then Cdat = blockadd(Cdat, eta)

if v then print, 'S'
for i=0,N_s-1 do begin	; cycle through s-values
	if v then print, S[i]
	A = Cdat + S[i]^2 * CS ; form full covariance matrix (data + theory)

	if not keyword_set(SVD) then begin
	choldc, A, p, /double ; now the lower triangle of A contains the lower triangle of L
									 ; p is the diagonal of L
	logdetsqM = total(alog(p)) ; this is the log of sqrt of the determinant of M (trace of log(L))
	y = cholsol(A,p,[q,u], /double)
	yyt = total(y*([q,u]))
	endif else begin
		; do it the SVD way!
		SVDC, A, D, Mu, Mv, /double
		logdetsqM = total(alog(sqrt(D)))
		y = reform(Mu # [q,u]) * 1./sqrt(D)
		yyt = total(y^2)
	endelse
	logL[i] = -0.5 * yyt - logdetsqM
	l1[i] = yyt
	l2[i] = -1 * logdetsqM
endfor


if n_elements(logL) eq 1 then logL = logL[0,0]

M = max(logL)
maxL = where(logL eq M)
L = exp(logL-max(logL))

return, reform(L)

end