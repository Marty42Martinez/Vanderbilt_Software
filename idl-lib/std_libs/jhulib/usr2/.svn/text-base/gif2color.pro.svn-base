;-------------------------------------------------------------
;+
; NAME:
;       GIF2COLOR
; PURPOSE:
;       Convert a GIF image to a standard color image.
; CATEGORY:
; CALLING SEQUENCE:
;       gif2color, [file]
; INPUTS:
;       file = optional gif image file name.  in
;         If file is given gif image is loaded before conversion.
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: currently loaded image is assumed to be a gif
;         image and is converted to a standard color image by
;         separating the R,G,B components and putting them back
;         together using color_quan with CUBE=6.  The converted
;         image is then redisplayed and the color table is loaded.
; MODIFICATION HISTORY:
;       R. Sterner, 1 June, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro gif2color, file, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Convert a GIF image to a standard color image.'
	  print,' gif2color, [file]'
	  print,'   file = optional gif image file name.  in'
	  print,'     If file is given gif image is loaded before conversion.'
	  print,' Notes: currently loaded image is assumed to be a gif'
	  print,'   image and is converted to a standard color image by'
	  print,'   separating the R,G,B components and putting them back'
	  print,'   together using color_quan with CUBE=6.  The converted'
	  print,'   image is then redisplayed and the color table is loaded.'
	  return
	endif
 
	if n_elements(file) ne 0 then begin
	  read_gif,file,a,r,g,b
	  sz = size(a)
	  nx = sz(1)
	  ny = sz(2)
	  window,xs=nx,ys=ny
	  tvlct,r,g,b
	  tv,a
	endif
 
	tvlct,r,g,b,/get
	t = tvrd()
	rr = r(t)
	gg = g(t)
	bb = b(t)
	c = color_quan(rr,gg,bb,rc,gc,bc,cube=6)
	tvlct,rc,gc,bc
	tv,c
 
	return
	end
