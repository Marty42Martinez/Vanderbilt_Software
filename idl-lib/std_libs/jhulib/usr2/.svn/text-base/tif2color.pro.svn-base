;-------------------------------------------------------------
;+
; NAME:
;       TIF2COLOR
; PURPOSE:
;       Convert a TIFF image to a standard color image.
; CATEGORY:
; CALLING SEQUENCE:
;       tif2color, [file], [img, r, g, b]
; INPUTS:
;       file = optional tif image file name.  in
;         If file is given tif image is loaded before conversion.
; KEYWORD PARAMETERS:
;       Keywords:
;         /NOLOAD means do not load image or color table.
;         XMAG=xm Magnification factor in X (def=1).
;         YMAG=ym Magnification factor in Y (def=1).
;         NX0 = X size of original image.
;         NY0 = Y size of original image.
; OUTPUTS:
;       img = optional output image.          out
;       r,g,b = optional output color table.  out
; COMMON BLOCKS:
; NOTES:
;       Notes: currently loaded image is assumed to be a tif
;         image and is converted to a standard color image by
;         separating the R,G,B components and putting them back
;         together using color_quan with CUBE=6.  The converted
;         image is then redisplayed and the color table is loaded.
; MODIFICATION HISTORY:
;       R. Sterner, 27 Aug, 1993
;       R. Sterner, 1994 May 6 --- Added /NOLOAD, XMAG, YMAG.
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro tif2color, file, c, rc, gc, bc, noload=noload, $
	  xmag=xmag, ymag=ymag, nx0=nx0, ny0=ny0, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Convert a TIFF image to a standard color image.'
	  print,' tif2color, [file], [img, r, g, b]'
	  print,'   file = optional tif image file name.  in'
	  print,'     If file is given tif image is loaded before conversion.'
	  print,'   img = optional output image.          out'
	  print,'   r,g,b = optional output color table.  out'
	  print,' Keywords:'
	  print,'   /NOLOAD means do not load image or color table.'
	  print,'   XMAG=xm Magnification factor in X (def=1).'
	  print,'   YMAG=ym Magnification factor in Y (def=1).'
	  print,'   NX0 = X size of original image.'
	  print,'   NY0 = Y size of original image.'
	  print,' Notes: currently loaded image is assumed to be a tif'
	  print,'   image and is converted to a standard color image by'
	  print,'   separating the R,G,B components and putting them back'
	  print,'   together using color_quan with CUBE=6.  The converted'
	  print,'   image is then redisplayed and the color table is loaded.'
	  return
	endif
 
	if n_elements(xmag) eq 0 then xmag = 1.
	if n_elements(ymag) eq 0 then ymag = 1.
 
	if n_elements(file) ne 0 then begin
	  t = tiff_read(file,r,g,b,order=order)
	  if n_elements(r) eq 0 then begin
	    r = bindgen(256)
	    g = r
	    b = r
	  endif
          sz = size(t)
          nx0 = sz(1)
          ny0 = sz(2)
	  t = congrid(t,nx0*xmag,ny0*ymag)
	  if not keyword_set(noload) then begin
	    sz = size(t)
	    nx = sz(1)
	    ny = sz(2)
	    window,xs=nx,ys=ny
	    if n_elements(order) eq 0 then order = 0
	    tvlct,r,g,b
	    tv,t, order=order
	  endif
	  if order ne 0 then t=reverse(t,2)
	endif
 
	if n_elements(file) eq 0 then begin
	  tvlct,r,g,b,/get
	  t = tvrd()
          sz = size(t)
          nx0 = sz(1)
          ny0 = sz(2)
	  t = congrid(t,nx0*xmag,ny0*ymag)
	endif
	rr = r(t)
	gg = g(t)
	bb = b(t)
	c = color_quan(rr,gg,bb,rc,gc,bc,cube=6)
	if not keyword_set(noload) then begin
	  tvlct,rc,gc,bc
	  tv,c
	endif
 
	return
	end
