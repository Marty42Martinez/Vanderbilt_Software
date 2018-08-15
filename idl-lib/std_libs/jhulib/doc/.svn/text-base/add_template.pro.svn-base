;-------------------------------------------------------------
;+
; NAME:
;       ADD_TEMPLATE
; PURPOSE:
;       Add a near standard IDL template to a given IDL routine file.
; CATEGORY:
; CALLING SEQUENCE:
;       add_template, file
; INPUTS:
;       file = input IDL routine file name.     in
; KEYWORD PARAMETERS:
;       Keywords:
;         /INIT forces getmodhist to use new .idl_id file.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Note: Existing front end, up to the pro or function
;         statement, are replaced by the new template.
;         Original file is copied to tmp.tmp as a backup.
;         If routine does not contain built-in help text then it
;         is not modified.
;         Trouble-shooting:
;           If template not filled in check that the routine
;           has a help keyword and tests for keyword_set(hlp).
;           Function or pro statement must come after any old style
;           template.
; MODIFICATION HISTORY:
;       R. Sterner, about Sep 1989 at Sac Peak.  The exact date was
;       probably lost by this routine itself.
;       R. Sterner, 13 Dec, 1993 --- dropped spawn to copy files.
;       R. Sterner, 11 Mar, 1993 --- handled no help text case.
;
; Copyright (C) 1989, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro add_template, file, init=ini, help=hlp
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Add a near standard IDL template to a given IDL routine file.'
	  print,' add_template, file'
	  print,'   file = input IDL routine file name.     in'
          print,' Keywords:'
          print,'   /INIT forces getmodhist to use new .idl_id file.'
	  print,' Note: Existing front end, up to the pro or function'
	  print,'   statement, are replaced by the new template.'
	  print,'   Original file is copied to tmp.tmp as a backup.'
	  print,'   If routine does not contain built-in help text then it'
	  print,'   is not modified.'
	  print,'   Trouble-shooting:'
	  print,'     If template not filled in check that the routine'
	  print,'     has a help keyword and tests for keyword_set(hlp).'
	  print,'     Function or pro statement must come after any old style'
	  print,'     template.'
	  return
	endif
 
	;-------  Extracting help text from file  -------
	print,' '+file
	extracthlp, file, helptxt, /array, error=err
 
	;-------  No help text found.  No change.  --------
	if err ne 0 then return
 
	;-------  Make backup copy of file  ---------
	tmp = getfile(file)
	putfile,'tmp.tmp',tmp
 
	;-------  Open file for processing  --------
	get_lun, lun
	openw, lun, file
 
	printf, lun, $
	  ';-------------------------------------------------------------', $
	  format='(a)'
	printf, lun, ';+', format='(a)'
	brk_help, 'name', helptxt, name
	printf, lun, '; NAME:', format='(a)'
	if name(0) ne '' then printf, lun, $
	  ';       '+strtrim(name(0),2), format='(a)'
	brk_help, 'purp', helptxt, purp
	printf, lun, '; PURPOSE:', format='(a)'
	if purp(0) ne '' then printf, lun, $
	  ';       '+strtrim(purp(0),2), format='(a)'
	printf, lun, '; CATEGORY:', format='(a)'
	printf, lun, '; CALLING SEQUENCE:', format='(a)'
	brk_help, 'call', helptxt, call
	if call(0) ne '' then printf, lun, $
	  ';       '+strtrim(call(0),2), format='(a)'
	printf, lun, '; INPUTS:', format='(a)'
	brk_help, 'in', helptxt, txt
	p = 99
	for i = 1, n_elements(txt)-1 do begin
	  t = txt(i)
	  p2 = firstchar(t) & if p2 lt 0 then p2 = 99
	  p = p<p2
	  printf, lun, ';       '+strmid(t,p,99) , format='(a)'
	endfor
	printf, lun, '; KEYWORD PARAMETERS:', format='(a)'
	brk_help, 'key', helptxt, txt
	p = 99
	for i = 1, n_elements(txt)-1 do begin
	  t = txt(i)
	  p2 = firstchar(t) & if p2 lt 0 then p2 = 99
	  p = p<p2
	  printf, lun, ';       '+strmid(t,p,99) , format='(a)'
	endfor
	printf, lun, '; OUTPUTS:', format='(a)'
	brk_help, 'out', helptxt, txt
	p = 99
	for i = 1, n_elements(txt)-1 do begin
	  t = txt(i)
	  p2 = firstchar(t) & if p2 lt 0 then p2 = 99
	  p = p<p2
	  printf, lun, ';       '+strmid(t,p,99) , format='(a)'
	endfor
	getcommon, 'tmp.tmp', txt 
	printf, lun, '; COMMON BLOCKS:', format='(a)'
	p = 99
	for i = 1, n_elements(txt)-1 do begin
	  t = txt(i)
	  p2 = firstchar(t) & if p2 lt 0 then p2 = 99
	  p = p<p2
	  printf, lun, ';       '+strmid(t,p,99) , format='(a)'
	endfor
	printf, lun, '; NOTES:', format='(a)'
	brk_help, 'note', helptxt, txt
	p = 99
	for i = 1, n_elements(txt)-1 do begin
	  t = txt(i)
	  p2 = firstchar(t) & if p2 lt 0 then p2 = 99
	  p = p<p2
	  printf, lun, ';       '+strmid(t,p,99) , format='(a)'
	endfor
	getmodhist, 'tmp.tmp', txt, year, init=ini
	printf, lun, '; MODIFICATION HISTORY:', format='(a)'
	p = 99
	for i = 1, n_elements(txt)-1 do begin
	  t = txt(i)
	  p2 = firstchar(t) & if p2 lt 0 then p2 = 99
	  p = p<p2
	  printf, lun, ';       '+strmid(t,p,99) , format='(a)'
	endfor
	printf,lun,';'
	printf,lun,'; Copyright (C) '+year+', Johns Hopkins University/'+$
	  'Applied Physics Laboratory'
	printf,lun,'; This software may be used, copied, or redistributed as'+$
	  ' long as it is not'
	printf,lun,'; sold and this copyright notice is reproduced on each '+$
	  'copy made.  This'
	printf,lun,'; routine is provided as is without any express or'+$
	  ' implied warranties'
	printf,lun,'; whatsoever.  Other limitations apply as described'+$
	  ' in the file disclaimer.txt.'
	printf, lun, ';-', format='(a)'
	printf, lun, $
	  ';-------------------------------------------------------------', $
	  format='(a)'
;	printf, lun, ' ', format='(a)'
 
;	print,' Writing routine . . .
	get_lun, lun2
	openr, lun2, 'tmp.tmp'
	txt = ''
	while not eof(lun2) do begin
	  readf, lun2, txt
	  txt2 = strlowcase(txt)
	  wd = strtrim(getwrd(txt2,0),2)
	  if wd eq ';-' then begin	; If template end read 2 lines.
	    readf, lun2, txt
	    readf, lun2, txt
	    if txt eq '' then txt = ' '
	    goto, next
	  endif
	  if (wd eq 'pro') or (wd eq 'function') then goto, next
	endwhile
	print,' Error: not an IDL routine. Restoring original file.'
;	spawn, 'copy tmp.tmp '+file
	tmp = getfile('tmp.tmp')
	putfile,file,tmp
	return
 
next:	printf, lun, txt
	while not eof(lun2) do begin
	  readf, lun2, txt
	  if txt eq '' then txt = ' '
	  printf, lun, txt, format='(a)'
	endwhile
 
	close, lun, lun2
	free_lun, lun, lun2
;	print,file+' complete.'
 
	return
	end
