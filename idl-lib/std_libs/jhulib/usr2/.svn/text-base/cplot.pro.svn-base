;-------------------------------------------------------------
;+
; NAME:
;       CPLOT
; PURPOSE:
;       Do a character plots on screen or into an array.
; CATEGORY:
; CALLING SEQUENCE:
;       cplot, x, y
; INPUTS:
;       x = array of x coordinates.   in
;       y = array of y coordinates.   in
; KEYWORD PARAMETERS:
;       Keywords:
;         CHAR=ch   Plot character.  Default is to use
;           characters selected to give a smooth curve.
;         /NOERASE  inhibits screen erase.
;         BYTE=byt  Plot into specified byte array.
;           Convert result to a string array by: txt=string(byt).
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: Coordinates are screen character positions.
;         X ranges from 1 to 80,
;         Y ranges from 1 to 24, with 1 at top.
; MODIFICATION HISTORY:
;       R. Sterner. 17 Jun, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro cplot, xa, ya, char=char, noerase=noerase, byte=byt, help=hlp
 
 
	if (n_params(0) lt 2) or keyword_set(hlp) then begin
	  print,' Do a character plots on screen or into an array.'
	  print,' cplot, x, y'
	  print,'   x = array of x coordinates.   in'
	  print,'   y = array of y coordinates.   in'
	  print,' Keywords:'
	  print,'   CHAR=ch   Plot character.  Default is to use'
	  print,'     characters selected to give a smooth curve.'
	  print,'   /NOERASE  inhibits screen erase.'
	  print,'   BYTE=byt  Plot into specified byte array.'
	  print,'     Convert result to a string array by: txt=string(byt).'
	  print,' Notes: Coordinates are screen character positions.'
	  print,'   X ranges from 1 to 80,'
	  print,'   Y ranges from 1 to 24, with 1 at top.'
	  return
	endif
 
	;--------  Clear screen or array  -------------
	if n_elements(byt) ne 0 then begin
	  if not keyword_set(noerase) then byt(*) = 32B
	endif else begin
	  if not keyword_set(noerase) then printat,1,1,/clear
	endelse
 
	n = n_elements(xa)
 
	;----------  Loop through all points  ------------
	for i1 = 0, n-2 do begin
	  i2 = (i1+1)<(n-1)
	  x1 = xa(i1)				; Look at next 2 points.
	  y1 = ya(i1)
	  x2 = xa(i2)
	  y2 = ya(i2)
	  linepts, x1, y1, x2, y2, xx, yy	; Connect them.
	  n2 = n_elements(xx)
	  for j = 0, n2-1 do begin		; Step through connecting pts.
	    j2 = (j+1)<(n2-1)
	    dx = xx(j2)-xx(j)			; Vector to next connecting pt.
	    dy = yy(j2)-yy(j)
	    ;-------  Determine plot character  -----------
	    if (abs(dx)+abs(dy)) eq 0 then begin
	      ch = '+'
	    endif else begin
	      recpol,dx+0.,dy+0.,r,a,/deg
	      a = fix((a + 22.5)/45.)
	      ch = (['-','.','|',",",'-',"'",'|',"'"])(a)
	    endelse
	    if n_elements(char) ne 0 then ch = char
	    ;--------  Plot a single point  ----------
	    if n_elements(byt) ne 0 then begin
	      byt(xx(j),yy(j)) = (byte(ch))(0)
	    endif else begin
	      printat,xx(j),yy(j),ch
	    endelse
	  endfor  ; j: linepts loop.
	endfor  ; i: plot array loop.
 
	return
 
	end
