pro maxdestripeandoffset, dat, sig,finalmap,finalcovar,offsets,startpix

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
maxpix = 4
measmappix = dblarr(MAXPIX);HOLDS 1'S WHERE AT LEAST ONE
;SUB-MAP IS MEAS. WE NEED AT LEAST ONE MAP TO FIND
;THE MIN. VAR. BEST FIT TO THE STRIPES

print, 'Figuring out Pixels'
for r = 0,maxpix-1 do begin
	n = (where(sig[*,r]))
	if n[0] NE (-1) then measmappix[r] = 1.
endfor
mp=where(measmappix)
startpix = mp[0]
npix = N_ELEMENTS(mp)
print, 'starting RA bin is:',startpix;START R.A. OF MAP


ident = fltarr(npix,npix)
for i = 0,npix-1 do ident[i,i] =1.; IDENTITY MATRIX

dat = dat[*,mp]		; Keep only relevant parts of the maps (saves memory)
sig = sig[*,mp]


print, 'creating pointing matrices'
A = bytarr(m,npix+m,npix)
At= bytarr(m,npix,npix+m); m transpose matrices of A
for q = 0,m-1 do begin
	A[q,0:npix-1,0:npix-1] = ident
	A[q,npix+q,*] = 1
	At[q,0:npix-1,0:npix-1] = ident
	At[q,*,npix+q] = 1
endfor


;NB: MUST USE DOUBLE PRECISION ON ALL FOR INVERSES


;FOR EACH SUB-MAP, THERE ARE 2 NOISE MATRICES
;ONE IS FOR THE PIXEL ERRORS/IGNORANCES
;N_ij^1 = \SIGMA_ii IF MEAS, OR b^2 IF NOT
;EACH ROW OF SECOND MATRIX HAS b^2 FOR ELEMENTS WHICH
;WERE MEASURED, AND 0 WHERE NOT MEASURED

b = 10000.d; big number [in mK] for errors
noise1 = dblarr(m,npix,npix); holds all m covar matrices
;diagonal with pixel weights [variances where measured]
;and b^2 [where not meas].
noise2 = dblarr(m,npix,npix); holds all m covar matrices
;diagonal with offset ignorance [b^2 where measured]
;and zeros [where not meas]

print, 'making noise matrices'
;FIRST, DETERMINE WHAT WAS MEASURED
for q = 0,m-1 do begin
	meas = where(sig[q,*] NE 0.0d)
	print, 'measured pixels=',meas
	print, 'input offsets=',mean(dat[q,meas])
	;notmeas = where(dat[q,*] EQ 0.0d)
	;noise1diag[meas] = (sig[q,meas])^2.

;NOW BUILD UP THE 2 NOISE MATRICES
	for i = 0,npix-1 do begin
		if sig[q,i] NE 0.0d then begin
			noise1[q,i,i] = (sig[q,i])^2.
			noise2[q,meas,i] = b^2.
		endif else noise1[q,i,i] = b^2.
	endfor
endfor
print, 'add noise matrices together...'
;...ADD THEM TOGETHER
noisetot = (noise1) + (noise2)
noisetotinv = dblarr(q,npix,npix)

;'A' IS LIKE A POINTING MATRIX IN MAX TEG NOTATION
;THERE ARE M OF THEM [ONE FOR EACH SUBMAP]
;EACH  HAS N+M COLUMNS AND N ROWS
;FOR ANY A-MATRIX [A_j] THE FIRST NxN BLOCK IS IDENTITY MATRIX
;COLUMNS N+1 TO M ARE ZERO VECTOR [M-ROWS OF ZEROS], EXCEPT
;THE jTH COLUMN WHICH IS ALL-ONES
print, 'create lots of big matrices'
AtNinv= dblarr(m,npix,npix+m); VARIOUS MATRIX PAIRS
AtNinvA= dblarr(m,npix+m,npix+m)
AtNinvX= dblarr(m,npix+m)

AtNinvAsum = dblarr(npix+m,npix+m)
AtNinvXsum = dblarr(npix+m)
print, 'begin guts of calculation'
for q = 0,m-1 do begin
	noisetotinv[q,*,*] = (invertspd(reform(noisetot[q,*,*]),/double))
	AtNinv[q,*,*] =  reform(At[q,*,*])##reform(noisetotinv[q,*,*])
	AtNinvA[q,*,*] = reform(AtNinv[q,*,*]) ## reform(A[q,*,*])
	AtNinvX[q,*] =   reform(AtNinv[q,*,*]) ## reform(dat(q,*))

	AtNinvAsum = AtNinvAsum+AtNinvA[q,*,*]
	AtNinvXsum = AtNinvXsum+AtNinvX[q,*]
endfor

print, 'final inversions...'
finalcovar = invertspd(AtNinvAsum[0:npix-1,0:npix-1],/double);final covar matrix of map and offsets
finalmap = finalcovar##atninvxsum[0:npix-1];final noise weighted map

plot,finalmap

offsets = npix*invertspd(AtNinvAsum[npix:*,npix:*])##atninvxsum[npix:*]
;THESE ARE THE FINAL NUMBERS WHICH TELL YOU HOW BY MUCH
;SUB-MAP j WAS OFF FROM THE BEST-FIT VALUES, IN DATA UNITS

print, 'output offsets=',offsets

offsets = reform(offsets)
finalmap = reform(finalmap)

end

