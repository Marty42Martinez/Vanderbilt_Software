;-------------------------------------------------------------
;+
; NAME:
;       TIF2BW
; PURPOSE:
;       Convert a TIFF image to a BW image.
; CATEGORY:
; CALLING SEQUENCE:
;       tif2bw, [file]
; INPUTS:
;       file = optional tiff image file name.  in
;         If file is given tiff image is loaded before conversion.
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: currently loaded image is assumed to be a tiff
;         image and is converted to a pure BW image by
;         using the luminance of the current color table to
;         convert the image values.  The converted image is then
;         redisplayed and the BW color table is loaded.
; MODIFICATION HISTORY:
;       R. Sterner, 27 Aug, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro tif2bw, file, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Convert a TIFF image to a BW image.'
	  print,' tif2bw, [file]'
	  print,'   file = optional tiff image file name.  in'
	  print,'     If file is given tiff image is loaded before conversion.'
	  print,' Notes: currently loaded image is assumed to be a tiff'
	  print,'   image and is converted to a pure BW image by'
	  print,'   using the luminance of the current color table to'
	  print,'   convert the image values.  The converted image is then'
	  print,'   redisplayed and the BW color table is loaded.'
	  return
	endif
 
	if n_elements(file) ne 0 then begin
	  a = tiff_read(file,r,g,b,order=order)
	  if n_elements(r) eq 0 then begin
	    r = bindgen(256)
	    g = r
	    b = r
	  endif
	  sz = size(a)
	  nx = sz(1)
	  ny = sz(2)
	  window,xs=nx,ys=ny
          if n_elements(order) eq 0 then order = 0
	  tvlct,r,g,b,order=order
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
