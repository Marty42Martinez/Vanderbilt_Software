;-------------------------------------------------------------
;+
; NAME:
;       PICK_DIR
; PURPOSE:
;       Interactively pick a directory.
; CATEGORY:
; CALLING SEQUENCE:
;       pick_dir, pick
; INPUTS:
; KEYWORD PARAMETERS:
;       Keywords:
;         DIRECTORY=dir  set initial directory (def=current).
;         FLAG=flg  0 means OK, 1 means selection aborted.
; OUTPUTS:
;       pick = selected directory.    out
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 3 Feb, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro pick_dir, pick, directory=dir, flag=flag, help=hlp
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Interactively pick a directory.'
	  print,' pick_dir, pick'
	  print,'   pick = selected directory.    out'
	  print,' Keywords:'
	  print,'   DIRECTORY=dir  set initial directory (def=current).'
	  print,'   FLAG=flg  0 means OK, 1 means selection aborted.'
	  return
	endif
 
	if n_elements(dir) eq 0 then cd, current=dir
 
	cdir = dir
	sel = 2
 
loop:	ttl = 'Current directory: '+cdir
	spawn,'ls -F '+cdir+' | grep /', txt
	for i=0,n_elements(txt)-1 do begin
	  tmp = txt(i)
	  if tmp ne '' then txt(i)=getwrd(txt(i),delim='/')
	endfor
	if txt(0) eq '' then begin
	  txt = ['  Accept current','  Go up a level']
	endif else begin
	  txt = ['  Accept current','  Go up a level', txt]
	endelse
	sel = sel<(n_elements(txt)+1)
	txtpick, txt, xdir, title=ttl, abort='  Abort directory selection', $
	  selection=sel
 
	case sel of
1:	begin		; Abort directory selection.
	  flag = 1
	  return
	end
2:	begin		; Accept current directory.
	  flag = 0
	  pick = cdir
	  return
	end
3:	begin		; Go up a level.
	  cdir = '/'+getwrd(cdir,-99,-1,/last,delim='/')
	end
else:	begin
	if cdir eq '/' then cdir = ''
	cdir = cdir+'/'+txt(sel-2)
	end
	endcase
 
	goto, loop
 
	end
