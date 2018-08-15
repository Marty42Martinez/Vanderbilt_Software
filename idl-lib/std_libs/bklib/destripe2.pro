pro destripe2, dat, sig,finalmap,finalcovar,offsets,startpix, reduced=reduced

;same as maxdestripe.pro except computes offsets vs.
;chunks as well

;;;FOR TESTING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sig = dblarr(2,360)
;dat = dblarr(2,360)

;sig(0,*)= 1.d + abs(randomn(121,360))
;sig(1,*)=  sig(0,*);10.d + 0.d*randomn(11,360)

;dat(0,*)= 0.*sin(2.d*!dpi*indgen(360)/359)+.2d;+sig(0,*)
;dat(1,*)= 0.*sin(2.d*!dpi*indgen(360)/359)+.3d;+sig(1,*);
;dat(0,0:100) = 0.d
;dat(1,0:100) = 0.d
;sig(0,0:100) = 0.d
;sig(1,0:100) = 0.d

;takes in m chunk-maps ,and errors vectors (not cov MATRICES
;(ie just sqrt(N_ii)), each has 360 pixels, 0's)
;where not measured

;input matrices: data vectors arranged as
;dat = m columns, 360 rows
;sig = m columns, 360 rows
;;;END OF TESTING;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

m = N_ELEMENTS(dat[*,0]); number of sub maps
print, "No. of Submaps: ", m
if keyword_set(reduced) then begin
	npix = n_elements(dat[0,*])
endif else begin
	measmappix = dblarr(360);HOLDS 1'S WHERE AT LEAST ONE
	;SUB-MAP IS MEAS. WE NEED AT LEAST ONE MAP TO FIND
	;THE MIN. VAR. BEST FIT TO THE STRIPES

	print, 'Figuring out Pixels'
	for r = 0,359 do begin
		n = (where(sig[*,r]))
		if n[0] NE (-1) then measmappix[r] = 1.
	endfor
	mp=where(measmappix)
	startpix = mp[0]
	npix = N_ELEMENTS(mp)
	print, 'starting RA bin is:',startpix;START R.A. OF MAP

	dat = dat[*,mp]		; Keep only relevant parts of the maps (saves memory)
	sig = sig[*,mp]
endelse

ident = identity(npix, /double)

print, 'creating pointing matrices'
A = bytarr(m,npix+m,npix)
At= bytarr(m,npix,npix+m); m transpose matrices of A
for q = 0,m-1 do begin
	A[q,0:npix-1,0:npix-1] = ident
	A[q,npix+q,*] = 1
endfor


;NB: MUST USE DOUBLE PRECISION ON ALL FOR INVERSES


;FOR EACH SUB-MAP, THERE ARE 2 NOISE MATRICES
;ONE IS FOR THE PIXEL ERRORS/IGNORANCES
;N_ij^1 = \SIGMA_ii IF MEAS, OR b^2 IF NOT
;EACH ROW OF SECOND MATRIX HAS b^2 FOR ELEMENTS WHICH
;WERE MEASURED, AND 0 WHERE NOT MEASURED

b = 1000.d; big number [in mK] for errors
;noise1 = fltarr(npix,npix); holds all m covar matrices
;diagonal with pixel weights [variances where measured]
;and b^2 [where not meas].
;noise2 = fltarr(npix,npix); holds all m covar matrices
;diagonal with offset ignorance [b^2 where measured]
;and zeros [where not meas]
noisetot = fltarr(m, npix, npix)

print, 'making noise matrices'
;FIRST, DETERMINE WHAT WAS MEASURED
for q = 0,m-1 do begin
	meas = where(sig[q,*] NE 0.0)
;	print, 'measured pixels=',meas
;	print, 'input offsets=',mean(dat[q,meas])
	;notmeas = where(dat[q,*] EQ 0.0d)
	;noise1diag[meas] = (sig[q,meas])^2.
	noise1 = fltarr(npix,npix)
	noise2 = fltarr(npix,npix)
;NOW BUILD UP THE 2 NOISE MATRICES
	for i = 0,npix-1 do begin
		if sig[q,i] NE 0.0d then begin
			noise1[i,i] = (sig[q,i])^2.
			noise2[meas,i] = b^2.
		endif else noise1[i,i] = b^2.
	endfor
	noisetot[q,*,*] = noise1 + noise2 ;...ADD THEM TOGETHER
endfor


;'A' IS LIKE A POINTING MATRIX IN MAX TEG NOTATION
;THERE ARE M OF THEM [ONE FOR EACH SUBMAP]
;EACH  HAS N+M COLUMNS AND N ROWS
;FOR ANY A-MATRIX [A_j] THE FIRST NxN BLOCK IS IDENTITY MATRIX
;COLUMNS N+1 TO M ARE ZERO VECTOR [M-ROWS OF ZEROS], EXCEPT
;THE jTH COLUMN WHICH IS ALL-ONES
print, 'create lots of big matrices'
;AtNinv= fltarr(m,npix,npix+m); VARIOUS MATRIX PAIRS
;AtNinvA= fltarr(m,npix+m,npix+m)
;AtNinvX= fltarr(m,npix+m)

AtNinvAsum = dblarr(npix+m,npix+m)
AtNinvXsum = dblarr(npix+m)
print, 'begin guts of calculation'
for q = 0,m-1 do begin
	AtNinv =  transpose(A[q,*,*])##invertspd(reform(noisetot[q,*,*]),/double)
	AtNinvAsum = AtNinvAsum + AtNinv ## reform(A[q,*,*])
	AtNinvXsum = AtNinvXsum + AtNinv ## reform(dat(q,*))
	print, 'Submap  ',q
endfor

print, 'final inversions...'
finalcovar = invertspd(AtNinvAsum[0:npix-1,0:npix-1],/double);final covar matrix of map and offsets
finalmap = finalcovar##atninvxsum[0:npix-1];final noise weighted map

;plot,finalmap

offsets = npix*invertspd(AtNinvAsum[npix:*,npix:*], /double)##atninvxsum[npix:*]
;THESE ARE THE FINAL NUMBERS WHICH TELL YOU HOW BY MUCH
;SUB-MAP j WAS OFF FROM THE BEST-FIT VALUES, IN DATA UNITS

print, 'output offsets=',offsets

offsets = reform(offsets)
finalmap = reform(finalmap)

end

