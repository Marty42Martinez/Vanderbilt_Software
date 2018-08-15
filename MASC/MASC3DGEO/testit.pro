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

new=0

IF new EQ 1 THEN BEGIN
  l = get_single_matches() 
  save,l,file='snglematches.sav'
ENDIF ELSE BEGIN
  RESTORE,'snglematches.sav'
ENDELSE
a = l.toarray()

xy=FLTARR(3,3,N_ELEMENTS(x0))
nn=FLTARR(  3,N_ELEMENTS(x0))

FOR i=0,N_ELEMENTS(x0)-1 DO BEGIN
  FOR j=0,2 DO BEGIN 
      CASE j OF 
         0 : asd = masc_hv2xyz([a[i].reg1.xm,a[i].reg1.ym],[a[i].reg0.xm,a[i].reg0.ym],1,0)
         1 : asd = masc_hv2xyz([a[i].reg1.xm,a[i].reg1.ym],[a[i].reg2.xm,a[i].reg2.ym],1,2) 
         2 : asd = masc_hv2xyz([a[i].reg0.xm,a[i].reg0.ym],[a[i].reg2.xm,a[i].reg2.ym],0,2) 
      ENDCASE
      xy[*,j,i] = asd
      pp[*,j,i] = masc_xyz2hv(j,asd[0],asd[1],asd[2])
  ENDFOR
  nn[0,i]= NORM(xy[*,0,i]-xy[*,1,i])
  nn[1,i]= NORM(xy[*,2,i]-xy[*,1,i])
  nn[2,i]= NORM(xy[*,2,i]-xy[*,1,i])
ENDFOR 



END
