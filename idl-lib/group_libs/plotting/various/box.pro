; NAME:
;
;       BOX
;    modified from recangle.pro by RB to accept [lat0,lat1,lon0,lon1]
;
; PURPOSE:
;
;	Draw a rectangle on a plot.
;
; CALLING SEQUENCE:
;
;	BOX,[lat0,lat1,lon0,lon1
;
; INPUTS:
;
;       X0, Y0 - Points specifying a corner of the rectangle.
;
;       XLENGTH, YLENGTH - the lengths of the sides of the rectangle,
;                          in data coords.
;
; KEYWORD PARAMETERS:
;
;       FILL = set to fill rectangle.
;
;       FCOLOR = fill color.
;
;       Graphics keywords: CHARSIZE,COLOR,LINESTYLE,NOCLIP,
;       T3D,THICK,Z,LINE_FILL,ORIENTATION,DEVICE
;
; MODIFICATION HISTORY:
;
;	D. L. Windt, Bell Laboratories, September 1990.
;
;       Added device keyword, January 1992.
;
;       windt@bell-labs.com
;
;       revisee by rb
;
;-

pro box,latlon,xlength,ylength, $
              color=col,linestyle=lin, $
              noclip=noc,t3d=t3d,thick=thi,zvalue=zva, $
              fill=fill,fcolor=fcolor,line_fill=line_fill, $
              orientation=orientation, $
              device=device
on_error,2

y0      = latlon[0]
ylength = latlon[1]-latlon[0]
x0      = latlon[2]
xlength = latlon[3]-latlon[2]


if N_ELEMENTS(col) NE 0 then color=col else color=!p.color
if N_ELEMENTS(lin) NE 0 then linestyle=lin else linestyle=!p.linestyle
if N_ELEMENTS(noc) NE 0 then noclip=1 else noclip=!p.noclip
if N_ELEMENTS(thi) NE 0 then thick=thi else thick=!p.thick
if N_ELEMENTS(t3d) NE 0 then t3d=t3d else t3d=!p.t3d
if N_ELEMENTS(zva) NE 0 then zvalue=zva else zvalue=0
if N_ELEMENTS(fcolor) eq 0 then fcolor=color
if N_ELEMENTS(orientation) eq 0 then orientation=0
if N_ELEMENTS(device) eq 0 then device=0

if keyword_set(fill) then $
  polyfill,[x0,x0+xlength,x0+xlength,x0,x0], $
  [y0,y0,y0+ylength,y0+ylength,y0],color=fcolor, $
  line_fill=keyword_set(line_fill),orientation=orientation,device=device

plots,[x0,x0+xlength,x0+xlength,x0,x0],[y0,y0,y0+ylength,y0+ylength,y0], $
  color=color,linestyle=linestyle,noclip=noclip,thick=thick,t3d=t3d, $
  z=zvalue,device=device

return
end

