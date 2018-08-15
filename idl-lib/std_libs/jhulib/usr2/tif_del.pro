;-------------------------------------------------------------
;+
; NAME:
;       TIF_DEL
; PURPOSE:
;       Delete specified TIFF file.  For use by tif.pro.
; CATEGORY:
; CALLING SEQUENCE:
;       tif_del, file
; INPUTS:
;       file = name of tif file to delete.  in
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 27 Aug, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro tif_del, file, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Delete specified TIFF file.  For use by tif.pro.'
	  print,' tif_del, file'
 	  print,'   file = name of tif file to delete.  in'
	  return
	endif
 
	printat,1,1,/clear
	printat,1,5,' '
	txt = ''
	read,' Delete '+file+'?  y/n: ',txt
	if strupcase(txt) ne 'Y' then begin
	  print,' '
 	  print,' File not deleted.'
	  wait,.5
	  return
	endif
 
	spawn,'rm '+file
	print,' '+file+' deleted.'
	wait,1
 
	return
	end
