@init_camera_geoms

FUNCTION get_single_matches,_EXTRA=_EXTRA

   q = read_masc_dir(_EXTRA=_EXTRA)  

   l = LIST()

   FOR i=0,N_ELEMENTS(q) -1 DO BEGIN
      print,i
      r = find_match(q[i],match)
      IF r NE 0 THEN CONTINUE  ; 

      l.add,match

   ENDFOR

   RETURN,l

END

new=1


; dir='/Users/ralf/Desktop/MASC/GL_2015/MASC_2015.05.05_16Z/'

;dir='/Users/ralf/Desktop/MASC/LabTest/2015_LabTest18/MASC_2015.04.07_16Z/'

dir='/Users/ralf/Desktop/MASC/Labtests_2015/2015_Labtest3/MASC_2015.03.24_17Z/'
f = 1.6

;dir='/Users/ralf/Desktop/MASC/Labtests_2015/2015_Labtest17/MASC_2015.04.06_16Z/'
;f = 1.283

dir='/Users/ralf/Desktop/MASC/GL_2015/MASC_2015.07.01_06Z/'
f = 1.283

IF new EQ 1 THEN BEGIN
  l = get_single_matches(dir=dir) 
  save,l,file='snglematches.sav'
ENDIF ELSE BEGIN
  RESTORE,'snglematches.sav'
ENDELSE
a = l.toarray()

xd0 = FLTARR(201)
xd1 = FLTARR(201)

FOR ix0=-100,100 DO BEGIN
hoff = [ix0,0,ix0]
voff = [0, 0,0]

;FOR ix0=0,0 DO BEGIN

;++++++++++++++++++++++++
;boulder + Marquette
;++++++++++++++++++++++++
;hoff = [17, 0,17]
;voff = [31, 0,17]

;++++++++++++++++++++++++
; greenland 2015 - 1
;++++++++++++++++++++++++
;voff = [147, 0, 268]
;hoff = [57, 0,57]

;++++++++++++++++++++++++
; lab exp 13 2015
;++++++++++++++++++++++++
;voff = [78, 60, -18]
;hoff = [57, 0,57]

;++++++++++++++++++++++++
; lab exp 17 2015
;++++++++++++++++++++++++
;voff = [78, 60, -18]
;hoff = [57, 0,57]

;++++++++++++++++++++++++
; greenland 2015 - 2
;++++++++++++++++++++++++
;voff = [72, 0, 188]
;hoff = [36, 0,39]



ymin = 0
ind  = WHERE(a.reg0.ym GT  ymin aND a.reg1.ym GT  ymin aND a.reg2.ym GT  ymin )
z0   = (a.reg0.ym)[ind]
z1   = (a.reg1.ym)[ind]
z2   = (a.reg2.ym)[ind]

x0   = (a.reg0.xm)[ind] 
x1   = (a.reg1.xm)[ind] 
x2   = (a.reg2.xm)[ind] 

xy = FLTARR(2,3,N_ELEMENTS(x0))
pp = FLTARR(2,3,N_ELEMENTS(x0))


FOR i=0,N_ELEMENTS(x0)-1 DO BEGIN
  FOR j=0,2 DO BEGIN 
      CASE j OF 
         0 : asd = find_intersect(x1[i],x0[i],1,0,hoffsets=hoff,voffsets=voff,f=f,dofin=dofin)
         1 : asd = find_intersect(x1[i],x2[i],1,2,hoffsets=hoff,voffsets=voff,f=f,dofin=dofin) 
         2 : asd = find_intersect(x0[i],x2[i],0,2,hoffsets=hoff,voffsets=voff,f=f,dofin=dofin) 
      ENDCASE
      xy[*,j,i] = asd
      pp[*,j,i] = masc_xyz2hv(j,asd[0],asd[1],(z1-1025.)*3.45E-4,hoffsets=hoff,voffsets=voff,f=f,dofin=dofin)
  ENDFOR
ENDFOR 
d0 = REFORM(SQRT((xy[0,0,*]-xy[0,1,*])^2.+(xy[1,0,*]-xy[1,1,*])^2.))
d1 = REFORM(SQRT((xy[0,0,*]-xy[0,2,*])^2.+(xy[1,0,*]-xy[1,2,*])^2.))
;d2 = REFORM(SQRT((xy[0,1,*]-xy[0,2,*])^2.+(xy[1,1,*]-xy[1,2,*])^2.))

; offset is vbest where the mean difference btw tw navigations is smallest
; that was the case for an offset of dx=+16 for camera 0 and dx=+16 (same) for camera 2.
xd0[ix0+100]=MEAN(d0)
xd1[ix0+100]=MEAN(d1)
;xd2[ix0+50]=MEAN(d1)

; this important for image distance factor in init_camer_geoms...
; currently set tio 0.6
; this slope needs to come out to be one...
print,REGRESS(a.reg1.xm,REFORM(pp[0,1,*]))

ENDFOR

PRINT,WHERE(xd0 EQ MIN(xd0))-100.
PRINT,WHERE(xd1 EQ MIN(xd1))-100.

ind= WHERE(d0 LT 3 and d1 LT 3)

print,MEAN(d0[ind]),STDDEV(d0[ind])
print,MEAN(d1[ind]),STDDEV(d1[ind])

!P.MULTI=0

PLOT ,xy[0,0,*],xy[1,0,*],psym=1,XRANGE=[-7,7],YRANGE=[-7,7],/XSTYLE,/YSTYLE
OPLOT,xy[0,1,*],xy[1,1,*],psym=1,COL=240


!P.MULTI=[0,2,3];

PLOT,xy[0,0,*],xy[0,1,*],psym=1,XRANGE=[-7,7],YRANGE=[-7,7],/XSTYLE,/YSTYLE 
dline
PLOT,xy[1,0,*],xy[1,1,*],psym=1,XRANGE=[-7,7],YRANGE=[-7,7],/XSTYLE,/YSTYLE 
dline
PLOT,xy[0,0,*],xy[0,2,*],psym=1,XRANGE=[-7,7],YRANGE=[-7,7],/XSTYLE,/YSTYLE  
dline
PLOT,xy[1,0,*],xy[1,2,*],psym=1,XRANGE=[-7,7],YRANGE=[-7,7],/XSTYLE,/YSTYLE  
dline
PLOT,xy[0,1,*],xy[0,2,*],psym=1,XRANGE=[-7,7],YRANGE=[-7,7],/XSTYLE,/YSTYLE  
dline
PLOT,xy[1,1,*],xy[1,2,*],psym=1,XRANGE=[-7,7],YRANGE=[-7,7],/XSTYLE,/YSTYLE  
dline
;



END
