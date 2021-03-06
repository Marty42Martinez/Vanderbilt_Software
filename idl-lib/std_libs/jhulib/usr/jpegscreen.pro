;-------------------------------------------------------------
;+
; NAME:
;       JPEGSCREEN
; PURPOSE:
;       Save current screen image and color table to a JPEG file.
; CATEGORY:
; CALLING SEQUENCE:
;       jpegscreen, [file]
; INPUTS:
;       file = name of JPEG file.   in
; KEYWORD PARAMETERS:
;       Keywords:
;         QUALITY=q  JPEG quality value (0=bad, 100=best, def=75).
;           Low values give better compression but poorer quality.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: Prompts for file if called with no args.
; MODIFICATION HISTORY:
;       R. Sterner, 1996 Jan 17
;
; Copyright (C) 1996, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro jpegscreen, file, quality=q, help=hlp

	if keyword_set(hlp) then begin
	  print,' Save current screen image and color table to a JPEG file.'
	  print,' jpegscreen, [file]'
	  print,'   file = name of JPEG file.   in'
	  print,' Keywords:'
	  print,'   QUALITY=q  JPEG quality value (0=bad, 100=best, def=75).'
	  print,'     Low values give better compression but poorer quality.'
	  print,' Notes: Prompts for file if called with no args.'
	  return
	endif

	if n_elements(q) eq 0 then q=75

	if n_elements(file) eq 0 then begin
	  print,' '
	  print,' Save current screen image and color table to a JPEG file.'
	  file = ''
	  read,' Enter name of JPEG file: ',file
	  if file eq '' then return
	endif

	;---------  Handle file name  -------------
	filebreak,file,dir=dir,name=name,ext=ext
	if ext eq '' then begin
	  print,' Adding .jpg as the file extension.'
	  ext = 'jpg'
	endif
	if ext ne 'jpg' then begin
	  print,' Warning: non-standard extension: '+ext
	  print,' Standard extension is jpg.'
	endif
	name = name + '.' + ext
	fname = dir + name

	tvlct,r,g,b,/get

	;--------  Read screen image and color table   -----------
	if !d.n_colors GT 1e6 then begin
		snapshot = tvrd(true=3)
		a = Color_Quan(snapshot, 3, r, g, b, cube=6)
	endif else begin
		a = tvrd()
	endelse

	sz=size(a) & nx=sz(1) & ny=sz(2)	; Size.

	;---------  Repackage as 24 bit image  ----------
	img = bytarr(nx,ny,3)
	img(0,0,0) = r(a)	; Extract and insert red component.
	img(0,0,1) = g(a)	; Extract and insert grn component.
	img(0,0,2) = b(a)	; Extract and insert blu component.

	;--------  Write JPEG file  -------------


	dir = file_dirname(fname + '*', /mark)
	direxists =  file_test(dir)

	if (direxists eq 0) then begin
		file_mkdir, dir
		print, 'Created directory '+dir
	endif

	write_jpeg,fname,img,true=3,quality=q

	print,' Image saved in JPEG file '+fname+'.'
	return

	end
