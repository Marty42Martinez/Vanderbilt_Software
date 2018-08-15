;-------------------------------------------------------------
;+
; NAME:
;       BRK_HELP
; PURPOSE:
;       Return requested data from a help text array.
; CATEGORY:
; CALLING SEQUENCE:
;       brk_help, cmd, helptxt, out
; INPUTS:
;       cmd = one of: name, purp, call, in, out, key, note.    in
;       helptxt = text array from extract_help.                in
; KEYWORD PARAMETERS:
; OUTPUTS:
;       out = text array.                                      out
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
 
	pro brk_help, cmd, txtin, txtout, help=hlp
 
	if (n_params(0) lt 3) or keyword_set(hlp) then begin
	  print,' Return requested data from a help text array.'
	  print,' brk_help, cmd, helptxt, out'
	  print,'   cmd = one of: name, purp, call, in, out, key, note.    in'
	  print,'   helptxt = text array from extract_help.                in'
	  print,'   out = text array.                                      out'
	  return
	endif
 
	nlst = n_elements(txtin)-1
	txtout = ['']
	tab = string(9b)
 
	case strupcase(cmd) of
'NAME':	begin
	  t = strtrim(txtin(0), 2)
	  t = repchr(t,'/')
	  t = getwrd(t,nwrds(t)-1)
;	  l = strlen(t)
;	  txtout = [strmid(t,0,l-4)]
	  txtout = t
	end
'PURP':	begin
	  if nlst ge 1 then begin
	    t = strtrim(txtin(1),2)
	    txtout = [t]
	  endif
	end
'CALL':	begin
	  if nlst ge 2 then begin
	    t = strtrim(txtin(2),2)
	    txtout = [t]
	  endif
	end
'IN':	begin
	  txtout = ['']
	  mode = 'out'
	  for i = 3, nlst do begin
	    t = repchr(txtin(i), tab)
	    t = repchr(t, '.')
	    last = strlowcase(getwrd(t,nwrds(t)-1))
	    frst = strlowcase(getwrd(t,0))
	    frst = strmid(frst, 0, 4)
	    if frst eq 'keyw' then goto, indone
	    if frst eq 'note' then goto, indone
	    if last eq 'in' then mode = 'in'
	    if last eq 'out' then mode = 'out'
	    if mode eq 'in' then txtout = [txtout, txtin(i)]
	  endfor
indone:	
	end
'OUT':	begin
	  txtout = ['']
	  mode = 'in'
	  for i = 3, nlst do begin
	    t = repchr(txtin(i), tab)
	    t = repchr(t, '.')
	    last = strlowcase(getwrd(t,nwrds(t)-1))
	    frst = strlowcase(getwrd(t,0))
	    frst = strmid(frst, 0, 4)
	    if frst eq 'keyw' then goto, outdone
	    if frst eq 'note' then goto, outdone
	    if last eq 'in' then mode = 'in'
	    if last eq 'out' then mode = 'out'
	    if mode eq 'out' then txtout = [txtout, txtin(i)]
	  endfor
outdone:	
	end
'KEY':	begin
	  txtout = ['']
	  mode = 'xxx'
	  for i = 3, nlst do begin
	    t = repchr(txtin(i), tab)
	    frst = strlowcase(getwrd(t,0))
	    frst = strmid(frst, 0, 4)
	    if frst eq 'keyw' then mode = 'key'
	    if frst eq 'note' then mode = 'not'
	    if mode eq 'key' then txtout = [txtout, txtin(i)]
	  endfor
	end
'NOTE':	begin
	  txtout = ['']
	  mode = 'xxx'
	  for i = 3, nlst do begin
	    t = repchr(txtin(i), tab)
	    frst = strlowcase(getwrd(t,0))
	    frst = strmid(frst, 0, 4)
	    if frst eq 'keyw' then mode = 'key'
	    if frst eq 'note' then mode = 'not'
	    if mode eq 'not' then txtout = [txtout, txtin(i)]
	  endfor
	end
else:	begin
	  print,' Commands: name, purp, call, in, out, key, note'
	  return
	end
	endcase
 
	return
	end
