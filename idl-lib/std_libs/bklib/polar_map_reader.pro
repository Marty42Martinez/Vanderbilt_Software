pro polar_map_reader, NPix=Npix

;THIS PRO READS IN ALL MAPS THAT PASS COD-CUTS AND
;FORMS MATRICES FOR EACH CHANNEL AND STOKES PARAMETER
;THEN MAXDESTRIPEANDOFFSET.PRO IS CALLED FOR EACH
;CHANNEL/STOKES MATRIX
;THE FINAL MAPS, OFFSETS, AND COVAR MATRICES ARE RETURNED

;THE INPUT MAPS ARE IN STD. POLAR-FORMAT
;ascii data format:
;RA[deg]  DEC[deg]  FWHM[deg]  Q [microK] deltaQ1 deltaQ2  U  deltaU1 deltAU2

;BEST RESULTS COME WHEN USING TYPE 1 ERRORS, WHICH
;ARE E-PROP?. TYPE 1'S HAVE EQUAL dQ1 dU1 WHICH IS NOT
;CORRECT! SHOULD USE TYPE 2 [I THINK?] BUT THEY SEEM TO GIVE
;WORSE FINAL MAP VARIANCES/C_ls

;FIRST RESTORE THE ASCII TEMPLATE FOR READ_ASCII
restore,  'c:\polar\work\january\map_template.var'

if n_elements(npix) eq 0 then npix = 360

;THESE ARE THE SECTIONS THAT SURVIVE COD-CUT

nsections = [104,98,44]

for j = 1,3 do begin  ; cycle through channels

	nmaps = nsections[j-1]+1
	qmaps = dblarr(nmaps,npix)
	qmapsigma = dblarr(nmaps,npix)
	umaps = dblarr(nmaps,npix)
	umapsigma = dblarr(nmaps,npix)

	chan = sc('_j'+string(j)+'i')

;CYCLE OVER THE SUB MAPS TO BUILD UP THE BIG MATRIX
;THAT CONTAINS THEM ALL FOR Q AND U FOR ALL CHANNELS

for i = 0,nmaps-1 do begin
	print, chan,'  ', i
	q = i
	directory = 'c:\polar\work\feb\shortmaps_227\'
	datafile =strcompress(directory+'map'+string(q)+chan+'.dat',/remove_all)
	data = READ_ASCII(datafile, TEMPLATE=TEMPLATE)
	scale = 1.d	; IF DESIRED, micro Kelvin to milli K
	qmaps[i,*] = data.q/scale
	qmapsigma[i,*] = data.dq1/scale ; MUST USe COD TYPE 1 error?!!!
	umaps[i,*] = data.u/scale; to get correct offset vs. section???
	umapsigma[i,*] = data.du1/scale; type 1 has equal weight per ang bin and for Q and U?
endfor

;maxdestripeandoffset, qmaps,qmapsigma,qfinalmap,qfinalcov,qoffsets,startpix
;maxdestripeandoffset, umaps,umapsigma,ufinalmap,ufinalcov,uoffsets,startpix

save, file= directory + 'submaps'+chan+'.var', qmaps, qmapsigma, umaps, umapsigma

;save, qmaps,qmapsigma,qfinalmap,qfinalcov,qoffsets,$
;	  umaps,umapsigma,ufinalmap,ufinalcov,uoffsets, $
;	  startpix, section_set, filename = outputdatafile

endfor; loop over channels

end