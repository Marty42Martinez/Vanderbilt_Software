;-------------------------------------------------------------
;+
; NAME:
;       XDC
; PURPOSE:
;       Display Xdefault colors or generate a color.
; CATEGORY:
; CALLING SEQUENCE:
;       xdc
; INPUTS:
; KEYWORD PARAMETERS:
;       Keywords:
;         FILE=file  Xdefaults color file (def=/usr/lib/X11/rgb.txt)
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 1995 Mar 3
;
; Copyright (C) 1995, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro xdc_colors, tb_hndle, lo, hi
 
	if n_elements(tb_hndle) eq 0 then return
 
	handle_value, tb_hndle, tb
	r = tb.r(lo:hi)
	g = tb.g(lo:hi)
	b = tb.b(lo:hi)
	s = tb.s(lo:hi)
 
	device,window_state=st
	if st(5) eq 0 then window,5,xs=400,ys=600,title='Colors'
	wset, 5
	erase
	tvlct,r,g,b,5
	for i=0,19 do begin
	  tv,bytarr(80,30)+i+5,0,600-30*(i+1)
	  txt = strtrim(lo+i,2)+' ('+string(r(i),g(i),b(i),form='(i3,i4,i4)')+$
	    ')  '+s(i)
	  xyouts, /dev, 90, 600-30*(i+1)+9, txt, chars=1.5
	endfor
 
	return
	end
 
 
;==============================================================
;	xdc_event = event handler
;	R. Sterner, 1995 Mar 3
;==============================================================
 
	pro xdc_event, ev
 
	widget_control, ev.id, get_uval=uval
	widget_control, ev.top, get_uval=m
 
	if uval eq 'QUIT' then begin
	  widget_control, ev.top, /dest
	  return
	endif
 
	if uval eq 'DEBUG' then begin
	  cat=dog
	  return
	endif
 
	if uval eq 'FRONT' then begin
	  tb = m.table
	  ntab = m.ntab
	  indx = m.indx
	  lo = 0
	  hi = (lo+19)<(ntab-1)
	  xdc_colors, tb, lo,hi
	  fr = long(100L*lo/float(ntab))
	  m.fr = fr
	  m.indx = lo
	  widget_control, ev.top, set_uval=m
	  widget_control, m.ids, set_val=fr
	  return
	endif
 
	if uval eq 'LAST' then begin
	  tb = m.table
	  ntab = m.ntab
	  indx = m.indx
	  lo = (indx-20)>0
	  hi = (lo+19)<(ntab-1)
	  xdc_colors, tb, lo,hi
	  fr = long(100L*lo/float(ntab))
	  m.fr = fr
	  m.indx = lo
	  widget_control, ev.top, set_uval=m
	  widget_control, m.ids, set_val=fr
	  return
	endif
 
	if uval eq 'NEXT' then begin
	  tb = m.table
	  ntab = m.ntab
	  indx = m.indx
	  lo = (indx+20)<(ntab-20)
	  hi = (lo+19)<(ntab-1)
	  xdc_colors, tb, lo,hi
	  fr = long(100L*lo/float(ntab))
	  m.fr = fr
	  m.indx = lo
	  widget_control, ev.top, set_uval=m
	  widget_control, m.ids, set_val=fr
	  return
	endif
 
	if uval eq 'END' then begin
	  tb = m.table
	  ntab = m.ntab
	  indx = m.indx
	  lo = ntab-20
	  hi = (lo+19)<(ntab-1)
	  xdc_colors, tb, lo,hi
	  fr = long(100L*lo/float(ntab))
	  m.fr = fr
	  m.indx = lo
	  widget_control, ev.top, set_uval=m
	  widget_control, m.ids, set_val=fr
	  return
	endif
 
	if uval eq 'MAKE' then begin
	  if m.mwin eq 0 then begin
	    window,4,xs=200,ys=100,title='Make a color'
	    erase, 255
	    tvlct,m.r, m.g, m.b
	    tv,bytarr(100,100),0
	    tv,bytarr(50,50)+1,25,25
	    tv,bytarr(50,50)+1,125,25
	    m.mwin = 4
	  endif
	  xced1, 1, /hsv, /wait
	  tvlct,r,g,b,/get
	  r=r(0:2) & g=g(0:2) & b=b(0:2)
	  txt = string('ffff'x*r(1)/255., 'ffff'x*g(1)/255.,'ffff'x*b(1)/255.,$
	    form='(1H#,3z4.4)')
	  txt = string(r(1),g(1),b(1),form='(3i4)')+'  '+txt
	  if m.table ne 0 then begin	; Find closest color.
	    wset, m.mwin
	    handle_value,m.table,tb	;   Read color table.
	    rl=long(r(1)) & gl=long(g(1)) & bl=long(b(1))
	    d = (rl-tb.r)^2+(gl-tb.g)^2+(bl-tb.b)^2	; Find dist to each clr.
	    w = where(d eq min(d))	; Find closest table color.
	    w = w(0)
	    d = sqrt(d(w))
	    txt = txt+'  '+tb.s(w)+' ('+strtrim(string(d,form='(f7.2)'),2)+')'
	    tvlct, tb.r(w),tb.g(w),tb.b(w),3
	    tv,bytarr(200,25)+3,0,0
	    clr = 0
	    lum = ct_luminance(tb.r(w),tb.g(w),tb.b(w))
	    if lum lt 128 then clr = 2
	    xyouts, .5, .07,/norm,col=clr,align=.5,chars=1.5,$
	      strtrim(w,2)+'  '+tb.s(w)
	  endif
	  widget_control, m.id_lab, set_val=txt
	  m.r=r & m.g=g & m.b=b
	  widget_control, ev.top, set_uval=m
	  return
	endif
 
	if uval eq 'SLIDE' then begin
	  widget_control, m.ids, get_val=fr
	  lo = long(fr*float(m.ntab)/100.)<(m.ntab-20)
          hi = (lo+19)<(m.ntab-1)
          xdc_colors, m.table, lo,hi
          fr = long(100L*lo/float(m.ntab))
          m.fr = fr
          m.indx = lo
          widget_control, ev.top, set_uval=m
	  return
	endif
 
	if uval eq 'OPEN' then begin
	  f = pickfile(path=m.dir, file=m.file, get_path=dir2)
	  if f eq '' then return
	  file = filename(dir2, f, /nosym)
	  xmess, 'Reading file '+file+' . . .', wid=wid, /nowait
	  t = getfile(file, err=err)
	  if err ne 0 then begin
	    widget_control, wid, /dest
	    bell
	    xmess,' Could not open file '+file, /wait
	    return
	  endif
	  widget_control, wid, /dest
	  xmess, 'Interpreting color file . . .', wid=wid, /nowait
	  n = n_elements(t)
	  r=intarr(n) & g=r & b=r & s=strarr(n)
	  tr=0 & tg=0 & tb=0 & ts=''
	  for i=0, n-1 do begin
	    reads,t(i),tr,tg,tb,ts
	    r(i) = tr
	    g(i) = tg
	    b(i) = tb
	    s(i) = strtrim(ts,2)
	  endfor
	  widget_control, wid, /dest
	  if m.table eq 0 then begin
	    tb = handle_create()	; Create a handle.
	    m.table = tb		; Store address.
	  endif
	  handle_value, m.table, {r:r, g:g, b:b, s:s}, /set	; Store table.
	  m.indx = 0
	  m.ntab = n
	  widget_control, ev.top, set_uval=m
	  widget_control, m.id_f, set_val=file
	  lo = 0
	  hi = (lo+19)<(n-1)
	  xdc_colors, m.table, lo, hi
	  return
	endif
 
	return
	end
 
;==============================================================
;	xdc.pro = Display Xdefault colors
;	R. Sterner, 1995 Mar 3
;==============================================================
 
	pro xdc, file=file0, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Display Xdefault colors or generate a color.'
	  print,' xdc'
	  print,'   No args.'
	  print,' Keywords:'
	  print,'   FILE=file  Xdefaults color file (def=/usr/lib/X11/rgb.txt)'
	  return
	endif
 
	;----------  setup widget  ------------
	top = widget_base(/column,title='Xdefault colors')
	b = widget_base(top,/row)
	id = widget_button(b,value='Quit',uval='QUIT')
	id = widget_button(b,value='Debug',uval='DEBUG')
	b = widget_base(top,/row)
	id = widget_button(b,value='Make Color',uval='MAKE')
	id_lab = widget_text(b,xsize=55,value=' ')
	b = widget_base(top,/column,/frame)
	bb = widget_base(b,/row)
	id = widget_button(bb,value='Open color file',uval='OPEN')
	id_f = widget_text(bb,xsize=30,value=' ')
	bb = widget_base(b,/row)
	id = widget_button(bb,value='Front',uval='FRONT')
	id = widget_button(bb,value='Last',uval='LAST')
	id = widget_button(bb,value='Next',uval='NEXT')
	id = widget_button(bb,value='End',uval='END')
	ids = widget_slider(b,xsize=600,uval='SLIDE')
 
	;----------  Package needed values  -----------
	r = [0,128,255]
	g = r
	b = r
	if n_elements(file0) eq 0 then file0='/usr/lib/X11/rgb.txt'
	filebreak, file0, dir=dir, file=file
	map = {id_lab:id_lab, ids:ids, mwin:0, dwin:0, fr:0, indx:0, $
	  r:r, g:g, b:b, dir:dir, file:file, table:0L, id_f:id_f, ntab:0}
 
	;----------  Activate widget  -----------------
	widget_control, top, /real
	widget_control, top, set_uval=map
	xmanager, 'xdc', top
 
	return
	end
