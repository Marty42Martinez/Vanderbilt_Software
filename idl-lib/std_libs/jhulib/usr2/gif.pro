;-------------------------------------------------------------
;+
; NAME:
;       GIF
; PURPOSE:
;       GIF image viewer.
; CATEGORY:
; CALLING SEQUENCE:
;       gif
; INPUTS:
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
;       gif_com
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 2 Feb, 1993
;       R. Sterner, 4 Jun, 1993 --- Made remember wildcard and position.
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro gif, help=hlp
 
	common gif_com, dir, wild, nd
 
	if keyword_set(hlp) then begin
	  print,' GIF image viewer.'
	  print,' gif'
	  print,'   No args, prompts for image file names.'
	  return
	endif
 
	if (!d.window ne -1) and (!d.n_colors ne 256) then begin
	  print,' Must exit IDL and get back in to use gif.'
	  return
	endif
 
	window,colors=256
 
	if n_elements(dir) eq 0 then begin
	  cd,curr=dir
	  wild = '*.gif'
	  nd = 2
	endif
 
loop:	txtgetfile, file, dir=dir, $
	  title='Select GIF image to view',wild=wild, $
	  abort_text='Quit GIF viewer', $
	  numdef=nd, $
	  option1=['Zoom','zoom_dum'], $
	  option2=['Convert GIF to BW','gif2bw'], $
	  option3=['Convert GIF to color','gif2color'], $
	  option5=['Convert GIF file to TIFF file','gif2tif'], $
	  option4=['Delete this GIF image','gif_del']
	if file eq 'none' then begin
	  printat,1,1,/clear
	  return
	endif
 
	read_gif,file,a,r,g,b
	sz = size(a)
	nx = sz(1)
	ny = sz(2)
	window,xs=nx,ys=ny
	tvlct,r,g,b
	tv,a
 
	goto, loop
	end
