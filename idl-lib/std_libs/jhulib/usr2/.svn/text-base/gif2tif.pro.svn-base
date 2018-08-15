;-------------------------------------------------------------
;+
; NAME:
;       GIF2TIF
; PURPOSE:
;       Convert a GIF file to a TIFF file.
; CATEGORY:
; CALLING SEQUENCE:
;       gif2tif, file
; INPUTS:
;       file = gif image file name.  in
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Note: output TIF file name is same but has extension .tif.
;         TIFF file is written in current directory.
; MODIFICATION HISTORY:
;       R. Sterner, 2 Sep, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro gif2tif, file, help=hlp
 
	if (n_params() lt 1) or keyword_set(hlp) then begin
	  print,' Convert a GIF file to a TIFF file.'
	  print,' gif2tif, file'
	  print,'   file = gif image file name.  in'
	  print,' Note: output TIF file name is same but has extension .tif.'
	  print,'   TIFF file is written in current directory.'
	  return
	endif
 
	read_gif,file,a,r,g,b
	filebreak, file, name=name
	tiff_write,name+'.tif',reverse(a,2),1,red=r,green=g,blue=b
 
	return
	end
