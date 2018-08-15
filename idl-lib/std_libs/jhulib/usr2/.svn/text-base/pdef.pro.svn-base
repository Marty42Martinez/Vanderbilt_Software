;-------------------------------------------------------------
;+
; NAME:
;       PDEF
; PURPOSE:
;       Set some custom plot defaults.
; CATEGORY:
; CALLING SEQUENCE:
;       pdef
; INPUTS:
; KEYWORD PARAMETERS:
;       Keywords:
;         /OFF  means undo custom defaults.
; OUTPUTS:
; COMMON BLOCKS:
;       pdef_com
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 1994 Jun 15
;
; Copyright (C) 1994, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro pdef, off=off, help=hlp
 
	common pdef_com, psave, rsave, gsave, bsave
 
	if keyword_set(hlp) then begin
	  print,' Set some custom plot defaults.'
	  print,' pdef'
	  print,'   No args.'
 	  print,' Keywords:'
	  print,'   /OFF  means undo custom defaults.'
	  return
	endif
 
	if total(!p.position) eq 0 then begin
	  psave = !p
	  tvlct, rsave,gsave,bsave,/get
	endif
 
	if keyword_set(off) then begin
	  !p = psave
	  tvlct, rsave,gsave,bsave
	  return
	endif
 
	;-------  Set plot defaults  -----------
	window,/free,xs=10,ys=10
	wdelete
	!p.charsize = 1.5
	!p.position = [.14,.145,.90,.85]
	xyouts,0,0,'!17',/dev
	tvlct,0,0,80,0
	tvlct,140,255,155,!d.n_colors-1
	tvlct,60*(indgen(12) mod 6),(100-(indgen(12) ge 6)*67)/100.,$
	  fltarr(12)+1., 1, /hsv
 
	return
 
	end
