;-------------------------------------------------------------
;+
; NAME:
;       SUBTREE
; PURPOSE:
;       Display size sorted directory subtree. Good for cleaning.
; CATEGORY:
; CALLING SEQUENCE:
;       subtree, dir
; INPUTS:
;       dir = starting directory.    in
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
 
	pro subtree, dir, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Display size sorted directory subtree. Good for cleaning.'
	  print,' subtree, dir'
	  print,'   dir = starting directory.    in'
	  return
	endif
 
	;------  Make sure directory is set  --------
	if n_elements(dir) eq 0 then cd, curr=dir
 
	;------  Get directory/size pairs  --------
	spawn,'ls -lFR '+dir+' | grep "^[/t]"', txt
	txt = [dir,txt]
 
	;------  Separate directories and sizes  ------
	n = n_elements(txt)
	dd = txt(makei(0,n-1,2))
	tsz = txt(makei(1,n-1,2))
 
	;-------  Sort on size  ------
	sz = lonarr(n/2)				     ; Size as a num.
	for i = 0, n/2-1 do sz(i)=long(getwrd(tsz(i),1))     ; Convert.
	is = reverse(sort(sz))				     ; Sort descending.
	for i = 0, n/2-1 do tsz(i)=string(sz(i),form='(i8)') ; Back to string.
 
	;------  Display tree in descending size order  -------
	printat,1,1,/clear
	print,'   Blocks  Subdirectory'
	more,tsz(is)+':  '+dd(is)
	print,'  Total blocks: ',total(sz)
	print,' ---==< Press any key to continue >==---'
	k = get_kbrd(1)
 
	return
	end
