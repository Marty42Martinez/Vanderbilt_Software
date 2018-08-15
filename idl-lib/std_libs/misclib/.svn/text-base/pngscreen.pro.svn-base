;-------------------------------------------------------------
;+
; NAME:
;       PNGSCREEN
; PURPOSE:
;       Save current screen image and color table to a PNG file.
; CATEGORY:
; CALLING SEQUENCE:
;       pngscreen, [file]
; INPUTS:
;       file = name of PNG file.   in
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: Prompts for file if called with no args.
; MODIFICATION HISTORY:
;       R. Sterner, 1996 Feb 11
;
; Copyright (C) 1996, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------

	pro pngscreen, file, help=hlp

	if keyword_set(hlp) then begin
	  print,' Save current screen image and color table to a PNG file.'
	  print,' pngscreen, [file]'
	  print,'   file = name of PNG file.   in'
	  print,' Notes: Prompts for file if called with no args.'
	  return
	endif

	if n_elements(file) eq 0 then begin
	  print,' '
	  print,' Save current screen image and color table to a PNG file.'
	  file = ''
	  read,' Enter name of PNG file: ',file
	  if file eq '' then return
	endif

	;---------  Handle file name  -------------
	filebreak,file,dir=dir,name=name,ext=ext
	if ext eq '' then begin
	  print,' Adding .png as the file extension.'
	  ext = 'png'
	endif
	if ext ne 'png' then begin
	  print,' Warning: non-standard extension: '+ext
	  print,' Standard extension is png.'
	endif
	name = name + '.' + ext
	fname = dir + name

	;--------  Read color table  ------------
	tvlct,r,g,b,/get

	;--------  Read screen image  -----------
	if !d.n_colors GT 1e6 then begin
		snapshot = tvrd(true=1)
		image2D = Color_Quan(snapshot, 1, r, g, b)
	endif else begin
		image2D = tvrd()
	endelse

	;--------  Write png file  -------------

	dir = file_dirname(fname + '*', /mark)
	direxists =  file_test(dir)

	if (direxists eq 0) then begin
		file_mkdir, dir
		print, 'Created directory '+dir
	endif

	write_png,fname,image2D,r,g,b

	print,' Image saved in PNG file '+fname+'.'
	return

	end
