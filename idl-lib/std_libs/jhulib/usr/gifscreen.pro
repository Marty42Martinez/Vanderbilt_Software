;-------------------------------------------------------------
;+
; NAME:
;       GIFSCREEN
; PURPOSE:
;       Save current screen image and color table to a GIF file.
; CATEGORY:
; CALLING SEQUENCE:
;       gifscreen, [file]
; INPUTS:
;       file = name of GIF file.   in
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

	pro gifscreen, file, help=hlp, force=force

	if keyword_set(hlp) then begin
	  print,' Save current screen image and color table to a GIF file.'
	  print,' gifscreen, [file]'
	  print,'   file = name of GIF file.   in'
	  print,' Notes: Prompts for file if called with no args.'
	  return
	endif

	if n_elements(file) eq 0 then begin
	  print,' '
	  print,' Save current screen image and color table to a GIF file.'
	  file = ''
	  read,' Enter name of GIF file: ',file
	  if file eq '' then return
	endif

   ;---------  Handle file name  -------------
	filebreak,file,dir=dir,name=name,ext=ext
	if ext eq '' then begin
	  print,' Adding .gif as the file extension.'
	  ext = 'gif'
	endif
	if ext ne 'gif' then begin
	  print,' Warning: non-standard extension: '+ext
	  print,' Standard extension is gif.'
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

	;--------  Write gif file  -------------
	dir = file_dirname(fname + '*', /mark)
	direxists =  file_test(dir)

	if (direxists eq 0) then begin
		file_mkdir, dir
		print, 'Created directory '+dir
	endif

	skipwarn:
	write_gif,fname,image2D,r,g,b

	print,' Image saved in GIF file '+fname+'.'
	return

SKIP:
	print, 'Image not saved.'
	return
	end
