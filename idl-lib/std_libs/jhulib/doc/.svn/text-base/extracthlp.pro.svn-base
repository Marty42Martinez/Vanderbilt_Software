;-------------------------------------------------------------
;+
; NAME:
;       EXTRACTHLP
; PURPOSE:
;       Extract help text from an IDL routine, full text or one liner.
; CATEGORY:
; CALLING SEQUENCE:
;       extracthlp, infile, [out]
; INPUTS:
;       infile = file to extract from.    in
;       out = output file or text array.  in
;             If file then appended to.
; KEYWORD PARAMETERS:
;       Keywords:
;         /LISTFILE to list file name on terminal screen.
;         /LINER extracts only first line in liner format.
;         /ARRAY return a text array with help text.
;         ERROR=err error flag. 0: OK, 1: no help text found.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: if outfile is not given then the
;         help text is sent to the terminal screen.
;         Extracthlp searches for the first occurrence
;         of keyword_set(hlp) or keyword_set(help),
;         assuming it is for /HELP.
; MODIFICATION HISTORY:
;       R. Sterner, 11 Sep, 1989.
;       R. Sterner, 26 Feb, 1991 --- Renamed from extract_help.pro
;       R. Sterner,  9 Mar, 1993 --- Looked for keyword hlp or help.
;       R. Sterner, 11 Mar, 1993 --- Added error flag to indicate NO HELP.
;	R. Sterner, 1994 May 31 --- Modified /LINER to show routine type.
;
; Copyright (C) 1989, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro extracthlp, infile, out, listfile=lst, liner=lnr, $
	  array=arr, help=hlp, error=err
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Extract help text from an IDL routine, full text or '+$
	    'one liner.'
	  print,' extracthlp, infile, [out]'
	  print,'   infile = file to extract from.    in'
	  print,'   out = output file or text array.  in'
	  print,'         If file then appended to.'
	  print,' Keywords:'
	  print,'   /LISTFILE to list file name on terminal screen.'
	  print,'   /LINER extracts only first line in liner format.'
	  print,'   /ARRAY return a text array with help text.'
	  print,'   ERROR=err error flag. 0: OK, 1: no help text found.'
	  print,' Notes: if outfile is not given then the'
	  print,'   help text is sent to the terminal screen.'
	  print,'   Extracthlp searches for the first occurrence'
	  print,'   of keyword_set(hlp) or keyword_set(help),'
	  print,'   assuming it is for /HELP.'
	  return
	endif
 
	;----  open input file  -------
	get_lun, inlun
	on_ioerror, err
	openr, inlun, infile
	filebreak,infile,name=fnam
 
	;----  open output file  --------
	if keyword_set(arr) then begin
	  out = ['']
	endif else begin
	  if n_params(0) lt 2 then begin
	    outlun = -1
	  endif else begin
	    get_lun, outlun
	    openu, outlun, out, /append
	  endelse
	endelse
 
	;-----  Search for start of help text  --------
	if not keyword_set(lnr) then begin
	  if keyword_set(arr) then begin
	    out = [out,strupcase(fnam)]
	  endif else begin
	    printf, outlun, ' '+strupcase(fnam)
	  endelse
	endif
	if keyword_set(lst) then print, ' '+strupcase(fnam)
	t = ''
 
	;--------  Find correct routine in multiroutine file  ------
	rnam = strlowcase(fnam)		    ; Routine name (lower case).
	while not eof(inlun) do begin
	  readf, inlun, t
	  t = strlowcase(strtrim(t,2))    ; Lower case & Drop extra spaces.
	  if strpos(t,'pro '+rnam+',') eq 0 then begin		; OK.
	    rtype = ':P '					; Was pro.
	    goto, fkws
	  endif
	  if strpos(t,'function '+rnam+',') eq 0 then begin	; OK.
	    rtype = ':F '					; Was function.
	    goto, fkws
	  endif
	  if strpos(t,'pro '+rnam+' ,') eq 0 then begin		; OK.
	    rtype = ':P '					; Was pro.
	     goto, fkws
	  endif
	  if strpos(t,'function '+rnam+' ,') eq 0 then begin	; OK.
	    rtype = ':F '					; Was function.
	    goto, fkws
	  endif
	endwhile
	goto, nhtxt		; No help text found.
 
	;--------  Search for start of help text  -----------
fkws:	while not eof(inlun) do begin
	  readf, inlun, t
	  t = strlowcase(t)
	  t = strcompress(t,/remove_all)
	  if strpos(t,'keyword_set(hlp)') ge 0 then goto, next
	  if strpos(t,'keyword_set(help)') ge 0 then goto, next
	endwhile
 
	;-------  No help text found  ---------
nhtxt:	err = 1					; Set no help found flag.
	if not keyword_set(lnr) then begin
	  if keyword_set(arr) then begin
	    out = [out,' No help text found.']
	  endif else begin
	    printf, outlun,' No help text found.'
	  endelse
	endif else begin
	  if keyword_set(arr) then begin
	    out = [out, fnam + ' = No help text found.']
	  endif else begin
	    printf, outlun, fnam + ' = No help text found.'
	  endelse
	endelse
	goto, done
 
	;-----  extract and dump help text  -------
next:	err = 0
	while not eof(inlun) do begin
rd:	  readf, inlun, t
	  if strpos(strlowcase(t),'endif') gt 0 then goto, done
	  if strpos(strlowcase(t),'print') lt 0 then goto, rd
	  p1 = strpos(t,"'") & if p1 lt 0 then p1=999
	  p2 = strpos(t,'"') & if p2 lt 0 then p2=999
	  p = p1<p2
	  delim = strmid(t,p,1)
	  flag = (strlen(t)-1) eq strpos(t,'$',0) ; Continued statement?
	  t = getwrd(t, 1, delim=delim, /notrim) ; Get text between quotes.
	  t2 = ''
	  if flag then begin  ; Process a continued statement.
	    t2 = ''
	    readf, inlun, t2
	    t2 = strtrim(t2,2)
	    t2 = strmid(t2,1,strlen(t2)-2)
	  endif	  
 
	  t = t + t2
 
	  if not keyword_set(lnr) then begin
	    if keyword_set(arr) then begin
	      out = [out,t]
	    endif else begin
	      printf, outlun, '  '+t,format='(a)'
	    endelse
	  endif else begin
	    if keyword_set(arr) then begin
	      out = [out,fnam+rtype+strtrim(t,2)]
	    endif else begin
	      printf, outlun, fnam+rtype+strtrim(t,2),format='(a)'
	    endelse
	    goto, done
	  endelse
	endwhile
	goto, done
 
err:	print,' Could not open file '+infile
	err = 1
 
done: 	if not keyword_set(lnr) then begin
	  if not keyword_set(arr) then printf, outlun, ' '
	endif
	on_ioerror, null
	if not keyword_set(arr) then begin
	  if outlun gt 0 then free_lun, outlun
	endif else begin
	  out = out(1:*)
	endelse
	free_lun, inlun
	return
 
	end
