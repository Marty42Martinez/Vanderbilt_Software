@masc_find_all_matches

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

new=0

IF new EQ 1 THEN BEGIN
  l = get_single_matches() 
  save,l,file='snglematches.sav'
ENDIF ELSE BEGIN
  RESTORE,'snglematches.sav'
ENDELSE
a = l.toarray()

ymin = 0
ind = WHERE(a.reg0.ym GT  ymin aND a.reg1.ym GT  ymin aND a.reg2.ym GT  ymin )
z0  = (a.reg0.ym)[ind]
z1  = (a.reg1.ym)[ind]
z2  = (a.reg2.ym)[ind]

s10 = REGRESS(z1,z0,const=c10,yfit=yfit10)
s12 = REGRESS(z1,z2,const=c12,yfit=yfit12)
s02 = REGRESS(z0,z2,const=c02,yfit=yfit02)

b10 = MEAN(z0-z1)
b12 = MEAN(z2-z1)
b02 = MEAN(z2-z0)

!P.MULTI=[0,2,3]

PLOT ,z1,z0         ,psym=1   ,/YSTYLE
OPLOT,z1,yfit10     ,color=240
OPLOT,z1,z1 + b10   ,color=120
plot ,z1,z0-yfit10  ,PSYM=1          ,YRANGE=[-100,100],/YSTYLE
oplot,z1,z0-yfit10  ,PSYM=1,color=240
oplot,z1,z0-(z1+b10),PSYM=1,color=120
hline,0                 
hline,+30                 
hline,-30                 

PLOT ,z1,z2         ,psym=1   ,/YSTYLE
OPLOT,z1,yfit12     ,color=240
OPLOT,z1,z1 + b12   ,color=120
plot ,z1,z2-yfit12  ,PSYM=1          ,YRANGE=[-100,100],/YSTYLE
oplot,z1,z2-yfit12  ,PSYM=1,color=240
oplot,z1,z2-(z1+b12),PSYM=1,color=120
hline,0                 
hline,+30                 
hline,-30                 

PLOT ,z0,z2         ,psym=1   ,/YSTYLE
OPLOT,z0,yfit02     ,color=240
OPLOT,z0,z0 + b02   ,color=120
plot ,z0,z2-yfit02  ,PSYM=1          ,YRANGE=[-100,100],/YSTYLE
oplot,z0,z2-yfit12  ,PSYM=1,color=240
oplot,z0,z2-(z0+b02),PSYM=1,color=120
hline,0                 
hline,+30                 
hline,-30                 

PRINT,s10[0],c10,b10,STDDEV(z0-z1)
PRINT,s12[0],c12,b12,STDDEV(z1-z2)
PRINT,s02[0],c02,b02,STDDEV(z0-z2)

; so  b10 is the bias of camera 0 with respect to camera 1.
; I need to substract b10 from camera 0 to get to the camera 1 vetical 
; position....
; the range should be around +/- 30 it seems


;voffset = { $
;            offset      = [+29.,0,+20.], $
;            uncertainty = [30,30,30]



END
