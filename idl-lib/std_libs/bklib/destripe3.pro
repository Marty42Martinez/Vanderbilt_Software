pro destripe3, submaps,Qfinalmap,Qfinalcov,Qoffsets,Ufinalmap, Ufinalcov, Uoffsets, pixels

;Same as Destripe2, but takes in new struct form of submaps
; And, bonus feature, now I do Q and U simultaneously.

; INPUT VARIABLES
;		submaps : the struct containing the submaps
;
; OUTPUTS
;	 	finalmap : the final map
;     finalcovar : the final covariance
;	   offsets   : the offsets
;		pixels  : the RA pixels of the map (no info on any other pixels)

m = submaps.nmaps
NPIX = submaps.(0).(0).npix  ; # of total possible pixels

print, "No. of Submaps: ", m

print, 'Figuring out Pixels...'
for i = 0,m-1 do begin ; cycle through maps
	if i eq 0 then pixels = submaps.q.(i).pixels else pixels = [pixels,submaps.q.(i).pixels]
endfor
pixels = different(pixels)  ; pixels non-repeating
pixels = pixels[sort(pixels)] ; sort the measured pixels in ascending order

startpix = pixels[0]
npixels = N_ELEMENTS(pixels)
print, 'starting RA bin is:',startpix ; START R.A. OF MAP

MPA = intarr(NPIX) -1
for i=0,npixels-1 do MPA[pixels[i]] =where(pixels EQ pixels[i])  ; makes pixel mapping array


ident = identity(npixels)

print, 'creating pointing matrices'
A = bytarr(m,npixels+m,npixels)
At= bytarr(m,npixels,npix+m); m transpose matrices of A
for q = 0,m-1 do begin
	A[q,0:npixels-1,0:npixels-1] = ident
	A[q,npixels+q,*] = 1
endfor


;NB: MUST USE DOUBLE PRECISION ON ALL FOR INVERSES


;FOR EACH SUB-MAP, THERE ARE 2 NOISE MATRICES
;ONE IS FOR THE PIXEL ERRORS/IGNORANCES
;N_ij^1 = \SIGMA_ii IF MEAS, OR b^2 IF NOT
;EACH ROW OF SECOND MATRIX HAS b^2 FOR ELEMENTS WHICH
;WERE MEASURED, AND 0 WHERE NOT MEASURED

big = double(1e4); big number
huge = double(1e6); really big number
;noise1 = fltarr(npixels,npix); holds all m covar matrices
;diagonal with pixel weights [variances where measured]
;and b^2 [where not meas].
;noise2 = fltarr(npixels,npix); holds all m covar matrices
;diagonal with offset ignorance [b^2 where measured]
;and zeros [where not meas]

for qu = 0,1 do begin

	noisetot = dblarr(m, npixels, npixels)
	dat = dblarr(m, npixels)
	if qu eq 0 then print, 'making noise and data matrices for Q' else $
						print, 'making noise and data matrices for U'

	for i = 0,m-1 do begin  ; cycle through maps, get their info

		noise1 = fltarr(npixels,npixels)
		noise2 = fltarr(npixels,npixels)
		ipix = MPA(submaps.(qu).(i).pixels)
		np = n_elements(ipix)
		c = fltarr(np,np) + 1.

		dat[i, ipix] = submaps.(qu).(i).map ; data for measured pixels
		noise1 = matrix_insert(submaps.(qu).(i).covar,noise1,ipix)  ; what i have for covariance for measured pixels
	 	noise2= matrix_insert(c*big,noise2,ipix)	; add uncertainty to each of these for offset

		for p = 0, npixels-1 do if not elt(p,ipix) then noise1[p,p] = huge  ; add uncertainty to diags of unmeasured pixels

		noisetot[i,*,*] = noise1 + noise2 ;...ADD THEM TOGETHER
	endfor


	;'A' IS LIKE A POINTING MATRIX IN MAX TEG NOTATION
	;THERE ARE M OF THEM [ONE FOR EACH SUBMAP]
	;EACH  HAS N+M COLUMNS AND N ROWS
	;FOR ANY A-MATRIX [A_j] THE FIRST NxN BLOCK IS IDENTITY MATRIX
	;COLUMNS N+1 TO M ARE ZERO VECTOR [M-ROWS OF ZEROS], EXCEPT
	;THE jTH COLUMN WHICH IS ALL-ONES
	print, 'create lots of big matrices'
	;AtNinv= fltarr(m,npixels,npix+m); VARIOUS MATRIX PAIRS
	;AtNinvA= fltarr(m,npixels+m,npixels+m)
	;AtNinvX= fltarr(m,npixels+m)

	AtNinvAsum = dblarr(npixels+m,npixels+m)
	AtNinvXsum = dblarr(npixels+m)
	print, 'begin guts of calculation'
	for q = 0,m-1 do begin
		AtNinv =  transpose(A[q,*,*])##invertspd(reform(noisetot[q,*,*]),/double)
		AtNinvAsum = AtNinvAsum + AtNinv ## reform(A[q,*,*])
		AtNinvXsum = AtNinvXsum + AtNinv ## reform(dat[q,*])
		print, 'Submap  ',q
	endfor

	print, 'final inversions...'
	finalcovar = invertspd(AtNinvAsum[0:npixels-1,0:npixels-1],/double);final covar matrix of map and offsets
	finalmap = finalcovar##atninvxsum[0:npixels-1];final noise weighted map
	offsets = invertspd(AtNinvAsum[npixels:*,npixels:*], /double)##atninvxsum[npixels:*]

	;THESE ARE THE FINAL NUMBERS WHICH TELL YOU HOW BY MUCH
	;SUB-MAP j WAS OFF FROM THE BEST-FIT VALUES, IN DATA UNITS


	if qu eq 0 then begin
		print, 'output Q offsets = ',offsets
		Qoffsets = reform(offsets)
		Qfinalmap = reform(finalmap)
		Qfinalcov = reform(finalcovar)
	endif else begin
		print, 'output U offsets = ',offsets
		Uoffsets = reform(offsets)
		Ufinalmap = reform(finalmap)
		Ufinalcov = reform(finalcovar)
	endelse
endfor  ; Q/U loop

end

