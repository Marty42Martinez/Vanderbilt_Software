;-------------------------------------------------------------
;+
; NAME:
;       GIF2BW
; PURPOSE:
;       Convert a GIF image to a BW image.
; CATEGORY:
; CALLING SEQUENCE:
;       gif2bw, [file]
; INPUTS:
;       file = optional gif image file name.  in
;         If file is given gif image is loaded before conversion.
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: currently loaded image is assumed to be a gif
;         image and is converted to a pure BW image by
;         using the luminance of the current color table to
;         convert the image values.  The converted image is then
;         redisplayed and the BW color table is loaded.
; MODIFICATION HISTORY:
;       R. Sterner, 4 May, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro gif2bw, file, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Convert a GIF image to a BW image.'
	  print,' gif2bw, [file]'
	  print,'   file = optional gif image file name.  in'
	  print,'     If file is given gif image is loaded before conversion.'
	  print,' Notes: currently loaded image is assumed to be a gif'
	  print,'   image and is converted to a pure BW image by'
	  print,'   using the luminance of the current color table to'
	  print,'   convert the image values.  The converted image is then'
	  print,'   redisplayed and the BW color table is loaded.'
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
	lum= (.3 * r) + (.59 * g) + (.11 * b)
	t = tvrd()
	z = lum(t)
	loadct,0
	tv,z
 
	return
	end
