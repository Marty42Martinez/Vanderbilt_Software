;-------------------------------------------------------------
;+
; NAME:
;       FOOTPRINT
; PURPOSE:
;       Interactively give info on a camera footprint.
; CATEGORY:
; CALLING SEQUENCE:
;       footprint
; INPUTS:
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
;       footprint_com
; NOTES:
;       Notes: Intended for CCD cameras.  Gives information on
;         the camera's field of view on a flat level surface.
;         May specify the following:
;           Detector size in pixels or cm,
;           Lens focal length in mm,
;           Camera height above surface in m,
;           Camera look angle below horizontal in degrees.
;         Displays the following derived values:
;           Range to near, mid, and far side of footprint.
;           Field width at near, mid, and far range.
;           Pixel size both across and along line of sight for
;             near, mid, and far side of footprint.
;           Camera field of view in degrees.
; MODIFICATION HISTORY:
;       R. Sterner 22,26 May, 1992
;
; Copyright (C) 1992, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro footprint, help=hlp
 
	common footprint_com, tnuv, tduv, tf, th, tangh
 
	if keyword_set(hlp) then begin
 	  print,' Interactively give info on a camera footprint.'
	  print,' footprint'
	  print,'   No args.'
	  print,' Notes: Intended for CCD cameras.  Gives information on'
 	  print,"   the camera's field of view on a flat level surface."
	  print,'   May specify the following:'
	  print,'     Detector size in pixels or cm,' 
	  print,'     Lens focal length in mm,'
	  print,'     Camera height above surface in m,'
	  print,'     Camera look angle below horizontal in degrees.'
	  print,'   Displays the following derived values:'
	  print,'     Range to near, mid, and far side of footprint.'
	  print,'     Field width at near, mid, and far range.'
	  print,'     Pixel size both across and along line of sight for'
 	  print,'       near, mid, and far side of footprint.'
	  print,'     Camera field of view in degrees.'
	  return
	endif
 
	;------  Set defaults  ----------
	if n_elements(tnuv) eq 0 then tnuv = '390, 240'
	if n_elements(tduv) eq 0 then tduv = '1, 1'
	if n_elements(tf) eq 0 then tf = '50'
	if n_elements(th) eq 0 then th = '10'
	if n_elements(tangh) eq 0 then tangh = '35'
 
	;-----  Set up menu  -------
	menu = [$
	  '|5|2|Camera footprint on a level surface||',$
	  '|5|4|Detector size in pixels (h,v)|'+tnuv+'|PIX|',$
	  '|5|5|Detector size in cm (h,v)|'+tduv+'|SIZ|',$
	  '|5|6|Lens focal length in mm|'+tf+'|FOC|',$
	  '|5|7|Camera height above surface in m|'+th+'|HT|',$
	  '|5|8|Camera look angle below horizontal in degrees|'+tangh+'|ANG|',$
	  '|60|5|QUIT| |QUIT|',$
	  '|70|5|DEBUG| |BUG|']
 
	;-------  Display menu  --------
	txtmenu, init=menu
	in = 'PIX'
 
	;-------  Display results framework  ----------
	printat,18,10,         'Camera Footprint'  ,/under
	printat,9,12, '<----------          m -------->'
	printat, 9,13,'*---------------*--------------*'
	printat,10,14, '\              |             /'
	printat,11,15,  '\<-------         m ------>/'
	printat,12,16,   '*............*...........*'
	printat,13,17,    '\           |          /'
	printat,14,18,     '\          |         /'
	printat,15,19,      '*---------*--------*'
	printat,15,20,      '<----         m --->
	printat,44,12,'Range',/under
	printat,51,13,'m'
	printat,51,16,'m'
	printat,51,19,'m'
	printat,56,11,'Pixal Spacing in cm',/under
	printat,57,12,'Range',/under
	printat,67,12,'Azimuth',/under
	
	;-----  Convert values to numbers ---------
loop:	txt = tnuv			; Size in pixels.
        txt = repchr(txt,',')
        txt = repchr(txt,'      ')
        nu = getwrd(txt,0)+0.
        nv = getwrd(txt,1)+0.
	txt = tduv			; Size in cm.
        txt = repchr(txt,',')
        txt = repchr(txt,'      ')
        du = getwrd(txt,0)/100.         ; convert to m.
        dv = getwrd(txt,1)/100.
        duccd = du/(nu-1.)              ; Pixel spacing.
        dvccd = dv/(nv-1.)
	txt = tf			; Lens focal length.
        f = txt/1000.                   ; convert to m.
	txt = th			; Height above surface.
        h = txt + 0.
	;-------  Compute desired values  --------
	ang = 90. - tangh		; convert to incidence angle.
	a = ang/!radeg
	;------  chip corners & center  -------
	u = [1,-1,-1,1, 0]*du/2.
	v = [1,1,-1,-1, 0]*dv/2.
	;------  Add resolution points  -------
	u = [u, duccd, 0, 0, 0, 0, duccd]
	v = [v, dv/2.,dv/2.,dv/2.-dvccd, -dv/2.+dvccd, -dv/2., -dv/2.]
	u = [u, du/2.,-du/2., duccd, 0]
	v = [v, 0, 0, 0, -dvccd] 
	;------  Compute footprint corners  ---------
	sx = h*u/(v*sin(a) + f*cos(a))
	sy = h*(f*sin(a) - v*cos(a))/(f*cos(a) + v*sin(a))
	sz = -h
	dxn = sx(0) - sx(1)	; Near width.
	dxc = sx(11) - sx(12)	; Center width.
	dxf = sx(3) - sx(2)	; Far width.
	dy = sy(3) - sy(0)	; Length.
	rrn = sy(7)-sy(6)	; Range res near.
	rrc = sy(14)-sy(4)	; Range res center.
	rrf = sy(9)-sy(8)	; Range res far.
	arn = sx(5)-sx(6)	; Azi res near.
	arc = sx(13)-sx(4)	; Azi res center.
	arf = sx(10)-sx(9)	; Azi res far.
	;-------  Field of view  ------
	ufov = 2*atan(.5*du/f)*!radeg
	vfov = 2*atan(.5*dv/f)*!radeg
	;-------  Check for above the horizon parts of field  ---------
	if (tangh-vfov/2.) le 0 then begin	; Far too high.
	  dxf = 9999.
	  sy(9) = 9999.
	  rrf = 9999.
	  arf = 9999.  
	endif
	if (tangh+0.) le 0 then begin		; Center too high.
	  dxc = 9999.
	  sy(4) = 9999.
	  rrc = 9999.
	  arc = 9999.
	endif
	if (tangh+vfov/2.) le 0 then begin	; Near too high.
	  dxn = 9999.
	  sy(6) = 9999.
	  rrn = 9999.
	  arn = 9999.
	endif
	;-------  Display computed values  -------
	printat,21,12,string(dxf,form='(F7.3)')		; Footprint widths.
	printat,21,15,string(dxc,form='(F7.3)')
	printat,21,20,string(dxn,form='(F7.3)')
	printat,43,13,string(sy(9),form='(F7.3)')	; Footprint ranges.
	printat,43,16,string(sy(4),form='(F7.3)')
	printat,43,19,string(sy(6),form='(F7.3)')
	printat,55,13,string(rrf*100,form='(F7.3)')	; Footprint resolutions.
	printat,55,16,string(rrc*100,form='(F7.3)')
	printat,55,19,string(rrn*100,form='(F7.3)')
	printat,65,13,string(arf*100,form='(F7.3)')
	printat,65,16,string(arc*100,form='(F7.3)')
	printat,65,19,string(arn*100,form='(F7.3)')
	printat,37,21,'Camera field of view: '+string(ufov,form='(F4.1)')+$
	  ' by '+string(vfov,form='(F4.1)')+' degrees.'
 
	txtmenu, select=in, uval=uval
 
	case uval of
'BUG':	stop,'Use .con to continue.'
'QUIT':	return
'PIX':	begin
	  txt = 'New detector size in pixels'
	  txtin,txt+spc(79,txt),tnuv,def=tnuv
	  txtmenu,update='|5|4|Detector size in pixels (h,v)|'+tnuv+'|PIX|'
	end
'SIZ':	begin
	  txt = 'New detector size in cm'
	  txtin,txt+spc(79,txt),tduv,def=tduv
	  txtmenu,update='|5|5|Detector size in cm (h,v)|'+tduv+'|SIZ|'
	end
'FOC':	begin
	  txt = 'New lens focal length in mm'
	  txtin,txt+spc(79,txt),tf,def=tf
	  txtmenu,update='|5|6|Lens focal length in mm|'+tf+'|FOC|'
	end
'HT':	begin
	  txt = 'New camera height above surface in m'
	  txtin,txt+spc(79,txt),th,def=th
	  txtmenu,update='|5|7|Camera height above surface in m|'+th+'|HT|'
	end
'ANG':	begin
	  txt = 'New camera look angle below horizontal in degrees'
	  txtin,txt+spc(79,txt),tangh,def=tangh
	  txtmenu,up='|5|8|Camera look angle below horizontal in degrees|'+$
	    tangh+'|ANG|'
	end
	endcase
 
	goto, loop
	return
	end
