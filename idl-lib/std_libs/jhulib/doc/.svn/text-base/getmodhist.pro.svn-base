;-------------------------------------------------------------
;+
; NAME:
;       GETMODHIST
; PURPOSE:
;       Get list of modification history from an IDL routine.
; CATEGORY:
; CALLING SEQUENCE:
;       getmodhist, file, list, year
; INPUTS:
;       file = name of IDL routine file to process.   in
; KEYWORD PARAMETERS:
;       Keywords:
;         /INIT forces new ident to be used.
; OUTPUTS:
;       hist = text array with history records.       out
;       year = returned copyright year.               out
; COMMON BLOCKS:
;       getmodhist_com
; NOTES:
;       Notes: needs the home directory file .idl_id
;         which gives the author's ID.  The format is:
;           last_name
;           first initial
;           first_name
;           initials
;         Comment lines start with ; in column 1 and are ignored.
;         An example file:
;           ;------  .idl_id = User ID used by getmodhist
;           sterner
;           r
;           ray
;           res
;         This allows you to just put your name (or initials) and
;         date at the front of a new routine and let add_template
;         fill in the standard template.
; MODIFICATION HISTORY:
;       R. Sterner, 19 Sep, 1989.
;       R. Sterner, 21 Mar, 1991 --- added copyright year.
;       R. Sterner, 14 Jan, 1993 --- moved ID info to .idl_id in HOME.
;       R. Sterner, 1995 Dec 15 --- Now drops all text found before
;       ; MODIFICATION HISTORY:
;
; Copyright (C) 1989, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro getmodhist, file, hist, year, init=ini, help=hlp
 
	common getmodhist_com, id
 
	if (n_params(0) lt 2) or keyword_set(hlp) then begin
	  print,' Get list of modification history from an IDL routine.'
	  print,' getmodhist, file, list, year'
	  print,'   file = name of IDL routine file to process.   in'
	  print,'   hist = text array with history records.       out'
	  print,'   year = returned copyright year.               out'
	  print,' Keywords:'
	  print,'   /INIT forces new ident to be used.'
	  print,' Notes: needs the home directory file .idl_id'
	  print,"   which gives the author's ID.  The format is:"
	  print,"     last_name
	  print,"     first initial
	  print,"     first_name
	  print,"     initials
	  print,'   Comment lines start with ; in column 1 and are ignored.'
	  print,"   An example file:"
	  print,'     ;------  .idl_id = User ID used by getmodhist'
	  print,'     sterner'
	  print,'     r'
	  print,'     ray'
	  print,'     res'
	  print,'   This allows you to just put your name (or initials) and'
	  print,'   date at the front of a new routine and let add_template'
	  print,'   fill in the standard template.'
	  return
	endif
 
	if (n_elements(id) eq 0) or keyword_set(ini) then begin
	  home = getenv('HOME')
	  id = getfile(filename(home,'.idl_id',/nosym), error=err)
	  if err ne 0 then begin
	    print,' Error in getmodhist: ID file .idl_id not found in'
 	    print,'   your home directory.  Do getmodhist,/help for details.'
	    return
	  endif
	  id = id(where(strmid(id,0,1) ne ';'))
	  id = strlowcase(id)
	  id(0) = strtrim(id(0))
	  id(1) = ' '+strmid(strtrim(id(1),2),0,1)+'.'
	  id(2) = ' '+strtrim(id(2),2)+' '
	  id(3) = ' '+strtrim(id(3),2)+' '
	endif
	
	get_lun, lun
	on_ioerror, err
	openr, lun, file
	hist = ['']
	txt = ''
	readf, lun, txt
	tab = string(9b)
 
	while not eof(lun) do begin
	  readf, lun, txt
	  txt2 = strlowcase(txt)
	  txt2 = repchr(txt2,tab)
	  wd = getwrd(txt2,0)
	  pos = strpos(txt2,'modification history')
	  if (pos ge 0) and (pos lt 4) then goto, old
	  if wd eq 'pro' then goto, done
	  if wd eq 'function' then goto, done
	  if strpos(txt2,id(0)) ge 0 then begin
	    p1 = strpos(txt2,id(1))  & if p1 lt 0 then p1 = 999
	    p2 = strpos(txt2,id(2)) & if p2 lt 0 then p2 = 999
	    p = p1 < p2
	    txt = strmid(txt, p, 99)
	    if txt ne '' then hist = [hist,txt]
	  endif
	  if strpos(txt2,id(3)) ge 0 then begin
	    p = strpos(txt2,id(3))
	    txt = strmid(txt, p, 99)
	    hist = [hist,txt]
	  endif
	endwhile
	goto, done
 
err:	print,' Could not open file '+file
	goto, done
 
old:	hist = ['']				; Ignore text before MOD. HIST.
	txt = getwrd(txt, 3, 99)		; From existing template.
	if txt ne '' then hist = [hist,txt]	; Add all mod text.
	tab = string(9b)
	while not eof(lun) do begin
	  readf, lun, txt
	  txt = repchr(txt,tab)
	  if nwrds(txt) lt 2 then goto, done
	  hist = [hist,getwrd(txt, 1, 99)]
	endwhile
 
done:	close, lun
	free_lun, lun
	;-------  try to get year  -------
	if n_elements(hist) le 1 then begin
	  bell, 3
	  print,' File has no modification history.'
	  year = 0
	endif else begin
	  wordarray, hist, ha
	  on_ioerror, ioerr
	  for i = 0, n_elements(ha)-1 do begin
	    ha(i) = ha(i) + 0
	    goto, skip
ioerr: 	    ha(i) = 0
skip:
	  endfor
	  w = where((ha gt 1900), cnt)
	  if cnt gt 0 then begin
	    ha = ha(w)
	    year = min(ha)
	  endif else begin
	    bell, 3
	    print,' File has no creation date.'
	    year = 0
	  endelse
	endelse
	if year lt 1900 then year = getwrd(systime(),/last)
	year = strtrim(year,2)
 
	return
	end
