function EBLike_dec, q,u,qcov,ucov,E=E,B=B, double=double, $
				verbose=verbose, maxL=maxL, pixels=pixels, $
				npix=npix, singular=singular, svd=svd

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
;	r : the range to use for the data covariance matrix

cdir = 'c:\polar\angelica\'

if keyword_set(verbose) then v = 1 else v =0

if n_elements(E) eq 0 then E = findgen(25) * 2
if n_elements(B) eq 0 then B = findgen(25) * 2

N_e = n_elements(E)
N_b = n_elements(B)

logL = dblarr(N_e,N_b)

N = n_elements(pixels)

if n_elements(npix) eq 0 then npix = 360
fname = 'eb' + sc(npix) + '.var'
restore, cdir + fname ; get the theory covariance matrices CE and CB

CE = matrix_extract(CE,[pixels,N+pixels])
CB = matrix_extract(CB,[pixels,N+pixels])

CEq = CE[0:N-1,0:N-1]
CEu = CE[N:*,N:*]
CBq = CB[0:N-1,0:N-1]
CBu = CB[N:*,N:*]

if keyword_set(singular) then $
	eta = stddev(qcov)/N * 1e3 else $
	eta = 0.

; Now we have Cdat, CE, and CB!  Can calculate liklihoods now.

;****************************************************************
; THIS PART ZEROES THE QU PART OF Ctheory!!! (FOR TESTING ONLY)
;CE[0:N-1,N:*] = 0.
;CE[N:*,0:N-1] = 0.
;CB[0:N-1,N:*] = 0.
;CB[N:*,0:N-1] = 0.
;****************************************************************

if v then print, 'E'
for i=0,N_e-1 do begin	; cycle through e-values
	if v then print, E[i]
	for j=0,N_b-1 do begin	; cycle through b-values

		Aq = qcov+ E[i]^2 * CEq + B[j]^2 * CBq + eta  ; form full covariance matrix (data + theory)
		Au = ucov + E[i]^2 * CEu + B[j]^2 * CBu + eta

		if not keyword_set(svd) then begin
			choldc, Aq, pq, double=double
			detq = total(alog(pq))
			yq = cholsol(Aq,pq,q, double=double)
			qqt = total(yq*q)

			choldc, Au, pu, double=double
			detu = total(alog(pu))
			yu = cholsol(Au,pu,u, double=double)
			uut = total(yu*u)
		endif else begin
			; do it the SVD way!
		Aq = qcov+ E[i]^2 * CEq + B[j]^2 * CBq + eta  ; form full covariance matrix (data + theory)
		Au = ucov + E[i]^2 * CEu + B[j]^2 * CBu + eta
 			SVDC, Aq, Dq, Mq, dummy, /double
			detq2 = total(alog(sqrt(Dq)))
			yq2 = reform(Mq # q) * 1./sqrt(Dq)
			qqt2 = total(yq2^2)

			SVDC, Au, Du, Mu, dummy, /double
			detu2 = total(alog(sqrt(Du)))
			yu2 = reform(Mu # u) * 1./sqrt(Du)
			uut2 = total(yu2^2)
		endelse
		logL[i,j] = -0.5 * qqt - detq - 0.5 * uut - detu
	endfor
endfor

if n_elements(logL) eq 1 then logL = logL[0,0]

M = max(logL)
maxL = where2D(logL eq M)
if keyword_set(unnormalize) then L = exp(logL) else L = exp(logL-M)

return, reform(L)

end