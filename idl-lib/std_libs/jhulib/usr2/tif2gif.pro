;-------------------------------------------------------------
;+
; NAME:
;       TIF2GIF
; PURPOSE:
;       Convert a TIFF file to a GIF file.
; CATEGORY:
; CALLING SEQUENCE:
;       tif2gif, file
; INPUTS:
;       file = tiff image file name.  in
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Note: output GIF file name is same but has extension .gif.
;         GIF file is written in current directory.
; MODIFICATION HISTORY:
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro tif2gif, file, help=hlp
 
	if (n_params() lt 1) or keyword_set(hlp) then begin
	  print,' Convert a TIFF file to a GIF file.'
	  print,' tif2gif, file'
	  print,'   file = tiff image file name.  in'
	  print,' Note: output GIF file name is same but has extension .gif.'
	  print,'   GIF file is written in current directory.'
	  return
	endif
 
	a = tiff_read(file,r,g,b,order=ord)
	if n_elements(r) eq 0 then begin
	  r = bindgen(256)
	  g = r
	  b = r
	endif
	if ord eq 1 then a = reverse(a,2)
	filebreak, file, name=name
	write_gif,name+'.gif',a,r,g,b
 
	return
	end
