;-------------------------------------------------------------
;+
; NAME:
;       IDL_CLEAN
; PURPOSE:
;       Cleans up IDL source code.  Puts in IDL standard format.
; CATEGORY:
; CALLING SEQUENCE:
;       idl_clean, name
; INPUTS:
;       name = IDL routine file name (prompts).  in
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: outputs results in the file name.clean
; MODIFICATION HISTORY:
;       R. Sterner, 1995 Apr 6
;
; Copyright (C) 1995, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro idl_clean, name, help=hlp
 
	if keyword_set(hlp) then begin
	  print," Cleans up IDL source code.  Puts in IDL standard format."
	  print,' idl_clean, name'
	  print,'   name = IDL routine file name (prompts).  in'
	  print,' Notes: outputs results in the file name.clean'
	  return
	endif
 
	if n_elements(name) eq 0 then begin
	  print,' '
	  print,' Clean up IDL source code.'
	  name = ''
	  read,' Enter name of IDL routine to clean up: ',name
	  if name eq '' then return
	endif
 
	;--------  Generate list file  -----------------
	print,' '
	print,' Generating listing file . . .'
	t = ['.run -L temp.tmp '+name,'exit']
	putfile, 'tmp.tmp',t
	spawn,'idl tmp.tmp'
 
	;---------  Read in list file  -----------------
	print,' Reading list file and dropping numbers . . .'
	t = getfile('temp.tmp')
	t = strmid(t,6,999)
 
	;---------  Save result  -----------------------
	putfile,name+'.clean',t(0:n_elements(t)-2)
 
	print,' Cleaned IDL code is in '+name+'.clean'
 
	return
	end
