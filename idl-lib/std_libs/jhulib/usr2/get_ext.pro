;-------------------------------------------------------------
;+
; NAME:
;       GET_EXT
; PURPOSE:
;       Return a list of unique file extensions (and count).
; CATEGORY:
; CALLING SEQUENCE:
;       get_ext, dir, list
; INPUTS:
;       dir = directory to examine.  in
; KEYWORD PARAMETERS:
;       Keywords:
;         /QUIET means don't display information.
; OUTPUTS:
;       list = list of extensions.   out
; COMMON BLOCKS:
; NOTES:
;       Notes: each extension is followed by the number of
;         files having that extension.
; MODIFICATION HISTORY:
;       R. Sterner, 3 Feb, 1993
;       R. Sterner, 16 Feb, 1993 --- modified to display *.ext (was .ext).
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro get_ext, dir, list, quiet=quiet, help=hlp
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Return a list of unique file extensions (and count).'
	  print,' get_ext, dir, list'
	  print,'   dir = directory to examine.  in'
	  print,'   list = list of extensions.   out'
	  print,' Keywords:'
	  print,"   /QUIET means don't display information."
	  print,' Notes: each extension is followed by the number of'
 	  print,'   files having that extension.'
	  return
	endif
 
        ;-------  Find all files  ----------
	if not keyword_set(quiet) then begin
          printat,1,1,/clear
          print,' '
          print,' Finding extensions in '+dir+' . . .'
	endif
	spawn,'ls -Fl '+dir, txt
	txt = txt(1:*)
	ff = txt
	sz = lonarr(n_elements(txt))
	if txt(0) ne '' then begin
	  for i = 0, n_elements(txt)-1 do begin
	    ff(i) = getwrd(txt(i),/last)
	    sz(i) = getwrd(txt(i),4)+0L
	  endfor
	endif
 
	;-------  Look at list of files  --------
	w = where(strpos(ff,'/') ge 0, dcnt)		; Count directories.
	dsz = 0				
	if dcnt ne 0 then dsz = long(total(sz(w)))	; Bytes in subdir.
	w = where(strpos(ff,'/') lt 0, cnt)
	sz2 = sz
	ff0 = ff			; Just names of dirs and files.
	if cnt ne 0 then begin		; Drop directories.
	  ff = ff(w)			; Just files.
	  sz2 = sz(w)			; Just file sizes.
	endif
	fsz = 0
	if cnt ne 0 then fsz = long(total(sz(w)))	; Bytes in all files.
 
	if not keyword_set(quiet) then begin
          if cnt eq 0 then begin
            txtmess,'No files in '+dir
            return
          endif
        endif else begin
	  if cnt eq 0 then begin
	    list = ''
	    return
	  endif
	endelse
 
        ;-------  Extract unique extensions  --------
	f = ff
        for i=0, cnt-1 do f(i) = getwrd(ff(i),/last,delim='.')
        f = f(sort(f))
        t = shift(f,-1) ne f
	if max(t) eq 0 then begin
	  f2 = f(0) + string(n_elements(f)) + string(fsz)
	endif else begin
          f2 = f(where(t))
          w = [-1,where(t ne 0)]
          w = w(1:*) - w        	  ; File count.
          fcnt =  string(w,form='(i4)')   ; Number of files of each extension.
	  for i=0,n_elements(f2)-1 do begin	; Loop through extensions.
	    tmp = getwrd(f2(i))			; Get just extension.
	    w = where(strpos(txt,'.'+tmp) ge 0, wcnt)	; All files with ext.
;	    dot = '.'				; Assume tmp is an extension.
	    dot = '*.'				; Assume tmp is an extension.
	    if wcnt eq 0 then begin
	      w = where(tmp eq ff0)
	      dot = ''				; tmp was a filename.
	    endif
	    f2(i) = dot+f2(i)+spc(10,dot+f2(i))+' '+fcnt(i)+$
	      string(long(total(sz(w))))
	  endfor
	endelse
	f2 = ['Subdirs: '+string(dcnt,form='(i6)')+string(dsz),f2]
	list = f2
 
        ;-------  Display  -----------
	if keyword_set(quiet) then return
        f2 = ['Unique file extensions in '+dir,$
          'Files with no extension are listed with complete names.',$
	  'Ext          Count     Bytes',' ',f2,$
          ' ','Total files:  '+strtrim(cnt,2),$
	  'Total bytes:   '+string(fsz+dsz),$
	  ' ']
        printat,1,1,/clear
        more,f2
	txt = ''
        print,' ---==< Press any key to continue >==---'
	k = get_kbrd(1)
 
        return
        end
