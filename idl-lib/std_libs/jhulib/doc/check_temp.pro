;-------------------------------------------------------------
;+
; NAME:
;       CHECK_TEMP
; PURPOSE:
;       Determine if given file has an IDL template.
; CATEGORY:
; CALLING SEQUENCE:
;       check_temp, file
; INPUTS:
;       file = input IDL routine file name.     in
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: lists message on screen.
; MODIFICATION HISTORY:
;       R. Sterner, 18 July, 1990
;
; Copyright (C) 1990, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro check_temp, file, help=hlp
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Determine if given file has an IDL template.'
	  print,' check_temp, file'
	  print,'   file = input IDL routine file name.     in'
	  print,' Notes: lists message on screen.'
	  return
	endif
 
	openr,lun,file,/get_lun
 
	txt = ''
	while not eof(lun) do begin
	  readf, lun, txt
	  if strpos(txt,'; PURPOSE:') ge 0 then return
	endwhile
 
	free_lun, lun
 
	print,' No template in '+file
 
	return
	end
