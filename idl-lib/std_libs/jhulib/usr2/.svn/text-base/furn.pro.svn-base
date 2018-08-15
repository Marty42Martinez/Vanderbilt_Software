;-------------------------------------------------------------
;+
; NAME:
;       FURN
; PURPOSE:
;       Plot a set of furniture and a room floor plan.
; CATEGORY:
; CALLING SEQUENCE:
;       furn
; INPUTS:
; KEYWORD PARAMETERS:
;       Keywords:
;         /HARD means make hard copy.
;         SCALE=s  set scale, def=4: 4 feet per inch.
;         ROOM=[dx,dy]  Plot room: dx X dy feet (def=none).
;         FILE=name  name of furniture file.     in
;           File format:
;           Each piece of furniture has a line in the file like:
;             dx dy name
;           where dx ,dy = x, y size in inches, name = label.
;           Ex:
;             24 24 Chair
;             24 24 Chair
;             60 36 Table
;             30 15 File
;             30 15 File
;             66 12 Book Case
;             48 12 Book Case
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 8 Dec, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro furn, help=hlp, hard=hard, file=file, scale=scale, room=room
 
	if keyword_set(hlp) then begin
	  print,' Plot a set of furniture and a room floor plan.'
	  print,' furn'
	  print,'   All args are keywords.'
	  print,' Keywords:'
	  print,'   /HARD means make hard copy.'
	  print,'   SCALE=s  set scale, def=4: 4 feet per inch.'
	  print,'   ROOM=[dx,dy]  Plot room: dx X dy feet (def=none).'
	  print,'   FILE=name  name of furniture file.     in'
	  print,'     File format:'
	  print,'     Each piece of furniture has a line in the file like:'
	  print,'       dx dy name'
	  print,'     where dx ,dy = x, y size in inches, name = label.'
	  print,'     Ex:'
	  print,'       24 24 Chair
	  print,'       24 24 Chair
	  print,'       60 36 Table
	  print,'       30 15 File
	  print,'       30 15 File
	  print,'       66 12 Book Case
	  print,'       48 12 Book Case
	  return
	endif
 
	if n_elements(scale) eq 0 then scale = 4.	; Feet/inch.
	scale = float(scale)
 
 
	;============  Furniture  ==================
	chinit, hard=hard
 
	;--------  try to read an input file  ---------
	txt =  ['24 24 Chair',$
		'24 24 Chair',$
		'24 24 Chair',$
		'60 36 Desk/Table',$
		'48 36 Computer Table',$
		'60 36 Desk/Table',$
		'60 36 Desk/Table',$
		'48 12 Book Case',$
		'48 12 Book Case',$
		'48 12 Book Case',$
		'30 15 File',$
		'30 15 File',$
		'30 15 File',$
		'36 36 Computer',$
		'36 36 Computer']
	if n_elements(file) ne 0 then txt = getfile(file)
 
	;---------  Set up text  -----------
	if keyword_set(hard) then begin		; Printout.
	  tsz = 1.2
	  tyoff = .06
	  clr = 220
	endif else begin			; Screen.
	  tsz = .8
	  tyoff = .04
	  clr = 150
	endelse
	
	;--------  Interpret input file  -----------
	n = n_elements(txt)
	dx = fltarr(n)
	dy = fltarr(n)
	nam = strarr(n)
	for i = 0, n-1 do begin
	  dx(i) = getwrd(txt(i),0)/12./scale
	  dy(i) = getwrd('',1)/12./scale
	  nam(i) = getwrd('',2,99)
	endfor
 
	;---------  Plot input file  -----------
	bx = [0,1,1,0,0]		; A unit box.
	by = [0,0,1,1,0]
	y0 = 1.				; Bottom margin.
	x0 = .5				; Left margin.
	xmx = 7.			; Right margin.
	ht = 0.				; Line height.
	x = x0				; Starting point.
	y = y0
 
	;--------  Do scale first  --------
	mxf = fix((7.4-x0)*scale)
	plots,[0,mxf]/scale+x0, [y0,y0]-.25
	for t=0.,mxf do plots,[t,t]/scale+x0,[y0,y0-.05]-.25
	for t=0.,mxf do xyouts,t/scale+x0,y0-.4-2*tyoff, $
	  strtrim(fix(t),2),align=.5,charsize=tsz
	xyouts,.5*mxf/scale+x0,y0-.8,align=.5,'FEET',charsize=tsz
 
	;--------  Do pieces  ------------
	for i = 0, n-1 do begin
	  tx = dx(i)			; Pull out x size,
	  ty = dy(i)			;   y size, and
	  nm = nam(i)			;   name.
	  if (x+tx) gt xmx then begin	; Newline.
	    x = x0 			; Move back to left margin.
	    y = y+ht			; Move up one line.
	    ht = 0.			; Reset max line height.
	  endif
	  px = x+bx*tx			; Piece outline.
	  py = y+by*ty
	  polyfill, px, py, color=clr	; Fill piece.
	  plots, px, py			; Plot outline.
	  lx = x + .5*tx		; Label positoin.
	  ly = y + .5*ty - tyoff
	  xyouts,lx,ly,align=.5,nm,charsize=tsz	 ; Label.
	  x = x + tx			; Next x.
	  ht = ht>ty			; Next y?
	endfor
	tmp = ''
	if keyword_set(hard) then psterm else read,' Press RETURN',tmp
 
 
	;============  Room  ==================
        ;-------  Plot room if requested  --------
        if n_elements(room) ne 0 then begin
	  x0 = .5
	  y0 = .5
          chinit, hard=hard
          dx = room(0)/scale
          dy = room(1)/scale
          plots,[0,dx,dx,0,0]+x0, [0,0,dy,dy,0]+y0,thick=5
          x=makex(0,room(0),5)/scale
          y=makex(0,room(1),5)/scale
          for i=0,n_elements(y)-1 do plots,[0,dx]+x0,[y(i),y(i)]+y0,lines=3
          for i=0,n_elements(x)-1 do plots,[x(i),x(i)]+x0,[0,dy]+y0,lines=3
          x=makex(0,room(0),1)/scale
          y=makex(0,room(1),1)/scale
          for i=0,n_elements(y)-1 do plots,[0,dx]+x0,[y(i),y(i)]+y0,lines=1
          for i=0,n_elements(x)-1 do plots,[x(i),x(i)]+x0,[0,dy]+y0,lines=1
	  if keyword_set(hard) then psterm
        endif
 
	return
	end
