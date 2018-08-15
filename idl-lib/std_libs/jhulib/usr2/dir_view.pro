;-------------------------------------------------------------
;+
; NAME:
;       DIR_VIEW
; PURPOSE:
;       Directory viewing utility.
; CATEGORY:
; CALLING SEQUENCE:
;       dir_view
; INPUTS:
; KEYWORD PARAMETERS:
; OUTPUTS:
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
 
	pro dir_view, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Directory viewing utility.'
	  print,' dir_view'
	  print,'   No args.  Interactive.'
	  return
	endif
 
	cd, curr=cdir
	in = 'DIR'
 
loop:	menu = ['|5|3|Directory Viewing Utility||',$
		'|5|5|Current directory|'+cdir+'|DIR|',$
		'|5|7|View Subtree| |TREE|',$
		'|5|9|View extensions in directory| |EXT|',$
		'|5|11|List directory| |LIST|',$
		'|5|13|QUIT| |QUIT|']
 
	txtmenu, init=menu
	txtmenu, select=in, uvalue=uval
 
	case uval of
'QUIT':	begin
	  printat,1,1,/clear
	  return
	end
'DIR':	begin
	  pick_dir, cdir, dir=cdir
	end
'TREE':	begin
	  subtree, cdir
	end
'EXT':	begin
	  get_ext, cdir
	end
'LIST':	begin
	  printat,1,1,/clear
	  print,' Listing for '+cdir
	  spawn,'ls -aF '+cdir+' | more'
	  txt = ''
	  print,' ---==< Press any key to continue >==---'
	  k = get_kbrd(1)
	end
	endcase
 
	goto, loop
 
	end
