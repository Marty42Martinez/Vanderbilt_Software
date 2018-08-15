;-------------------------------------------------------------
;+
; NAME:
;       AUTOSCALE
; PURPOSE:
;       Autoscale given image as previously specified.
; CATEGORY:
; CALLING SEQUENCE:
;       out = autoscale(img)
; INPUTS:
;       img = image to scale.                  in
; KEYWORD PARAMETERS:
;       Keywords:
;         /SETUP  displays image and allows sub-area selection.
;            Sub-area used to find scaling for autoscaled images.
;            Histogram scaling parameters may be set during /SETUP.
;            Ex: x = autoscale(img, /SETUP)
;         MEM=n  selects parameter set for autoscaling (def=1).
;            Ex: tv, autoscale(img, mem=2).  Must do /SETUP before
;            autoscaling.
;         SAVE=file  saves image scaling memory in the given file.
;         RESTORE=file  restores image scaling from the given file.
; OUTPUTS:
;       out = scaled image (byte, 0 to 255).   out
; COMMON BLOCKS:
;       autoscale_com
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 16 Nov, 1989
;
; Copyright (C) 1989, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	function autoscale, img, setup=set, memory=mem, $
	  save=sav, restore=res, help=hlp
 
	common autoscale_com, flag, mlox, mhix, mloy, mhiy, mloh, mhih
 
	if keyword_set(hlp) then begin
	  print,' Autoscale given image as previously specified.'
	  print,' out = autoscale(img)'
	  print,'   img = image to scale.                  in'
	  print,'   out = scaled image (byte, 0 to 255).   out'
	  print,' Keywords:'	
	  print,'   /SETUP  displays image and allows sub-area selection.'
	  print,'      Sub-area used to find scaling for autoscaled images.'
	  print,'      Histogram scaling parameters may be set during /SETUP.'
	  print,'      Ex: x = autoscale(img, /SETUP)'
	  print,'   MEM=n  selects parameter set for autoscaling (def=1).' 
	  print,'      Ex: tv, autoscale(img, mem=2).  Must do /SETUP before'
	  print,'      autoscaling.
	  print,'   SAVE=file  saves image scaling memory in the given file.'
	  print,'   RESTORE=file  restores image scaling from the given file.'
	  return, -1
	endif
 
	if keyword_set(sav) then begin
	  save2, sav, flag, mlox, mhix, mloy, mhiy, mloh, mhih
	  print,' Image scaling memory saved in file '+sav
	endif
 
	if keyword_set(res) then begin
	  restore2, res, flag, mlox, mhix, mloy, mhiy, mloh, mhih
	  print,' Image scaling memory restored from file '+res
	endif
 
	if n_params(0) lt 1 then return, -1
 
	if n_elements(mlox) eq 0 then mlox = intarr(10)
	if n_elements(mhix) eq 0 then mhix = intarr(10)
	if n_elements(mloy) eq 0 then mloy = intarr(10)
	if n_elements(mhiy) eq 0 then mhiy = intarr(10)
	if n_elements(mloh) eq 0 then mloh = fltarr(10) + 1.
	if n_elements(mhih) eq 0 then mhih = fltarr(10) + 1.
 
	;---------  autoscale  -----------------
	if not keyword_set(set) then begin
	  if n_elements(flag) eq 0 then begin
	    print,' Must first do /SETUP.'
	    return, -1
	  endif
	  if flag ne 1 then begin
	    print,' Must first do /SETUP.'
	    return, -1
	  endif
	  if not keyword_set(mem) then mem = 1
	  lox = mlox((mem-1)>0<9)
	  hix = mhix((mem-1)>0<9)
	  loy = mloy((mem-1)>0<9)
	  hiy = mhiy((mem-1)>0<9)
	  loh = mloh((mem-1)>0<9)
	  hih = mhih((mem-1)>0<9)
 
	  sz = size(img)
	  hix = hix<sz(1)
	  hiy = hiy<sz(2)
	  if (hix eq 0) or (hiy eq 0) then begin
	    print,' Nothing in memory ',mem
	    return, -1
	  endif
	  tmp = ls(img(lox:hix,loy:hiy), loh, hih, mn, mx)
	  out = bytscl(img, min=mn, max=mx)
	  return, out
	endif
 
 
	;----------  setup  --------------
	if keyword_set(set) then begin
	  print,' Setup'
	  print,' Dislpaying image . . .'
	  tvscl,img
	  print,' Use box to select region to use to scale images.'
	  x = 100
	  y = 100
	  dx = 100
	  dy = 100
bloop:	  movbox, x, y, dx, dy, /exit, /com
	  lox = x
	  loy = y
	  hix = x+dx-1
	  hiy = y+dy-1
	  sz = size(img)
	  hix = hix<(sz(1)-1)
	  hiy = hiy<(sz(2)-1)
sloop:	  print,' '
	  print,' Enter % cutoff for histogram low and high ends (like 1, 1)'
	  lo = 0.
	  hi = 0.
	  read, lo, hi 
	  tmp = ls(img(lox:hix,loy:hiy),lo,hi,mn,mx)
	  out = bytscl(img,min=mn,max=mx)
	  tv, out
	  t = ''
	  print,' s = change lo,hi,   b = change box,   '+$
	    'q = quit,   return = continue.'
	  read, t
	  if strupcase(t) eq 'S' then goto, sloop
	  if strupcase(t) eq 'B' then goto, bloop
	  if strupcase(t) eq 'Q' then return, out
	  m = 0
	  read, ' Memory to store scaling in: ', m
	  mlox(m-1) = lox
	  mhix(m-1) = hix
	  mloy(m-1) = loy
	  mhiy(m-1) = hiy
	  mloh(m-1) = lo
	  mhih(m-1) = hi
	  print,' Saved in ',m
	  flag = 1
	  return, out
	endif
 
	return, -1
 
	end
