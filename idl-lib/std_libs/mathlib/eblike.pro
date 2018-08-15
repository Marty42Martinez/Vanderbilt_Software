function EBLike, q,u,qcov,ucov,E=E,B=B, double=double, unnormalize=unnormalize,$
				verbose=verbose, maxL=maxL, pixels=pixels, $
				goodpix=goodpix, npix=npix, $
				singular=singular, r=r, add = add, svd=svd, ctheory=ctheory

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



if keyword_set(verbose) then v = 1 else v =0

if n_elements(E) eq 0 then E = findgen(25) * 2
if n_elements(B) eq 0 then B = findgen(25) * 2
if n_elements(add) eq 0 then add = 0

N_e = n_elements(E)
N_b = n_elements(B)

logL = dblarr(N_e,N_b)

N = n_elements(pixels)
if n_elements(npix) eq 0 then npix = 360

if n_elements(ctheory) eq 0 then begin
	cdir = 'z:\projects\polar_analysis\angelica\'
	fname = 'eb' + sc(npix) + '.var'
	restore, cdir + fname ; get the theory covariance matrices CE and CB
endif else restore, ctheory

if n_elements(pixels) eq 0 then pixels = indgen(N)
if n_elements(goodpix) eq 0 then goodpix = pixels
N = n_elements(goodpix)

if n_elements(r) eq 0 then begin
; in this scenario, r is not set.  I will use as much of the measured data
; as fits into goodpix.  If parts of goodpix were not measured, goodpix will be
; rescaled to only include the measured parts.

;first, find places where goodpix wasn't measured

	meas = bytarr(N)
	for i = 0,N-1 do meas[i] = (where(goodpix[i] eq pixels))[0] ne -1
	unmeas = where(meas eq 0)
	wm = where(meas)
	goodpix = goodpix(wm)	; these are the actual pixels I will use
	N = n_elements(goodpix)

	; get the theory cov matrices
	CE = matrix_extract(CE,[goodpix,npix+goodpix])
	CB = matrix_extract(CB,[goodpix,npix+goodpix])

	; makes pixel mapping array
	use = intarr(N) -1
	for i=0,N-1 do use[i] =(where(pixels EQ goodpix[i]))[0]

	; CREATE FULL DATA COVARIANCE MATRIX
	Cdat = fltarr(2*N,2*N) + 0.*Identity(2*N, double=double)

	eta= 1e2*(stddev(qcov) + stddev(ucov))/N
	if n_elements(singular) eq 0 then eta = eta*0.
	eta = eta + add

	Cdat[0:N-1,0:N-1] = matrix_extract(qcov,use)+eta
	Cdat[N:*,N:*] = matrix_extract(ucov,use)+eta
	Cdat = Cdat + add

	; Create Data Map Vector [Q,U]

	Ydat = fltarr(2*N)
	ydat[0:N-1] = Q[use]
	ydat[N:*] = U[use]
endif else begin
	; in this scenario, r is set
	; anywhere goodpix wasn't measured, I will put large on-diagonal error
	; I will NOT eliminate any of those places.

	; it is tacitly assumed that r is a subset of pixels
	; if not, r will be rescaled so it is a subset of the measured pixels.
	; goodpix, however, will not be rescaled.

;first, make sure goodpix is a subset of measured pixels
	Ng = n_elements(goodpix)
	meas = bytarr(Ng)
	for i = 0,Ng-1 do meas[i] = (where(goodpix[i] eq pixels))[0] ne -1
	unmeas = where(meas eq 0)
	wm = where(meas)
	goodpix = goodpix(wm)	; these are the pixels where goodpix coincides with what was measured
	N = n_elements(goodpix)

;second, make sure r is a subset of goodpix
	Nr = n_elements(r)
	meas = bytarr(Nr)
	for i = 0,Nr-1 do meas[i] = (where(r[i] eq goodpix))[0] ne -1
	unmeas = where(meas eq 0)
	wm = where(meas)
	r = r(wm)	; these are the pixels where r coincides with goodpix
	Nr = n_elements(r)

; get the theory cov matrices
	CE = matrix_extract(CE,[goodpix,npix+goodpix])
	CB = matrix_extract(CB,[goodpix,npix+goodpix])

;now, form the map1 array that has the indices in pixels corresponding to r
;also, form the map2 array that has the indices in goodpix corresponding to r

	map1 = intarr(Nr) -1
	for i=0,Nr-1 do map1[i] =(where(pixels eq r[i]))[0]
	map2 = intarr(Nr) -1
	for i=0,Nr-1 do map2[i] =(where(goodpix eq r[i]))[0]

; now, make data covariance matrix
	Cdat = fltarr(2*N,2*N) + big*Identity(2*N, double=double)
	eta= 1e3*(stddev(qcov) + stddev(ucov))/N
	if n_elements(singular) eq 0 then eta = eta*0.
	eta = eta + add
	Cdat = matrix_insert(matrix_extract(qcov,map1)+eta,Cdat,map2)
	Cdat = matrix_insert(matrix_extract(ucov,map1)+eta,Cdat,map2+N)
	cdat = cdat + add

	; Create Data Map Vector [Q,U]

	Ydat = fltarr(2*N)
	ydat[map2] = Q[map1]
	ydat[map2+N] = U[map2]
endelse

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

		A = Cdat + E[i]^2 * CE + B[j]^2 * CB  ; form full covariance matrix (data + theory)
		if not keyword_set(svd) then begin
		choldc, A, p, double=double ; now the lower triangle of A contains the lower triangle of L
										 ; p is the diagonal of L
		logdetsqM = total(alog(p)) ; this is the log of sqrt of the determinant of M (trace of log(L))
		y = cholsol(A,p,ydat, double=double)
		yyt = total(ydat * y)

		endif else begin
			; do it the SVD way!
			SVDC, A, D, Mu, Mv, /double
			logdetsqM = total(alog(sqrt(D)))
			y = reform(Mu # ydat) * 1./sqrt(D)
			yyt = total(y^2)
		endelse
		logL[i,j] = -0.5 * yyt - logdetsqM
	endfor
endfor

if n_elements(logL) eq 1 then logL = logL[0,0]

M = max(logL)
maxL = where2D(logL eq M)
if keyword_set(unnormalize) then L = exp(logL-unnormalize) else L = exp(logL-M)

return, L

end