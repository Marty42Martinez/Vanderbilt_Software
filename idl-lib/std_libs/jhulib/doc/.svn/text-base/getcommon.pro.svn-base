;-------------------------------------------------------------
;+
; NAME:
;       GETCOMMON
; PURPOSE:
;       Get list of commons from an IDL routine.
; CATEGORY:
; CALLING SEQUENCE:
;       getcommon, file, list
; INPUTS:
;       file = name of IDL procedure file.   in
; KEYWORD PARAMETERS:
; OUTPUTS:
;       list = text array listing commons.   out
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 19 Sep, 1989.
;
; Copyright (C) 1989, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro getcommon, file, list, help=hlp
 
	if (n_params(0) lt 2) or keyword_set(hlp) then begin
	  print,' Get list of commons from an IDL routine.'
	  print,' getcommon, file, list'
	  print,'   file = name of IDL procedure file.   in'
	  print,'   list = text array listing commons.   out'
	  return
	endif
 
	get_lun, lun
	on_ioerror, err
	openr, lun, file
	list = ['']
	txt = ''
	readf, lun, txt
 
	while not eof(lun) do begin
	  readf, lun, txt
	  txt2 = strlowcase(txt)
	  if strpos(txt2,'pro ') ge 0 then goto, next
	  if strpos(txt2,'function ') ge 0 then goto, next
	endwhile
	goto, done
 
next:	while not eof(lun) do begin
	  readf, lun, txt
	  wd = strtrim(getwrd(txt,0),2)
	  if strlowcase(wd) eq 'common' then begin
	    wd = getwrd(txt,1)
	    wd = strmid(wd,0,strlen(wd)-1)
	    list = [list, wd]
	  endif
	endwhile
	goto, done
 
err:	print,' Could not open file '+file
 
done:	close, lun
	free_lun, lun
	return
	end
