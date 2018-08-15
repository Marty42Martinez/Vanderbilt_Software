;-------------------------------------------------------------
;+
; NAME:
;       TIF
; PURPOSE:
;       TIFF image viewer.
; CATEGORY:
; CALLING SEQUENCE:
;       tif
; INPUTS:
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
;       tif_com
; NOTES:
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
 
	pro tif, help=hlp
 
	common tif_com, dir, wild, nd
 
	if keyword_set(hlp) then begin
	  print,' TIFF image viewer.'
	  print,' tif'
	  print,'   No args, prompts for image file names.'
	  return
	endif
 
	if (!d.window ne -1) and (!d.n_colors ne 256) then begin
	  print,' Must exit IDL and get back in to use tif.'
	  return
	endif
 
	window,colors=256
 
	if n_elements(dir) eq 0 then begin
	  cd,curr=dir
	  wild = '*.tif'
	  nd = 2
	endif
 
loop:	txtgetfile, file, dir=dir, $
	  title='Select TIFF image to view',wild=wild, $
	  abort_text='Quit TIFF viewer', $
	  numdef=nd, $
	  option1=['Zoom','zoom_dum'], $
	  option2=['Convert TIFF to BW','tif2bw'], $
	  option3=['Convert TIFF to color','tif2color'], $
	  option4=['Convert TIFF file to GIF file','tif2gif'], $
	  option5=['Delete this TIFF image','tif_del']
	if file eq 'none' then begin
	  printat,1,1,/clear
	  return
	endif
 
	a = tiff_read(file,r,g,b, order=order)
	if n_elements(r) eq 0 then begin
	  r = bindgen(256)
	  g = r
	  b = r
	endif
	sz = size(a)
	nx = sz(1)
	ny = sz(2)
	window,xs=nx,ys=ny
	tvlct,r,g,b
	if n_elements(order) eq 0 then order = 0
	tv,a, order=order
 
	goto, loop
	end
