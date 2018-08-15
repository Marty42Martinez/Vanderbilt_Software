FUNCTION find_intersect,xa_pixel,xb_pixel,ic0,ic1,f=f,voffsets=voffsets,hoffsets=hoffsets,camera_geoms=camera_geoms,dofin=dofin
  
  ; Input : 
  ;    xa  : pixel offset from center camera A (A can be 0,1,2)
  ;    xb  : pixel offset from center camera B (B can be 0,1,2 but must be different from camera A)
  ;    ic0 : Number, Camera identifier (Which camera is camera A? 0,1, or 2?)
  ;    ic0 : Number, Camera identifier (Which camera is camera B? 0,1, or 2?)
  ;    fa : Focal length camera a [cm]. Default, 1.25 cm
  ;    fb : Focal length camera b [cm]. Default, 1.25 cm
  ;   hoffsets: optinoal keyword for offsets. default [18,0,18]
  ;            see  find_horizontal_offsets.pro for that
  ;
  ; Output: 
  ;      [x,y] : position in [cm] of particlein ***horizontal*** plane of MASC
  ;                 x-axis is parallel to rim segment on which camera 1 (middle) is mounted)
  ;                 y-axis is perpendicular to rim segment on which camera 1 (middle) is mounted)
  ;                 [0,0] is the center of the 
  
  camera_geoms = init_camera_geoms(f=f,hoffsets=hoffsets,voffsets=voffsets,dofin=dofin)

  ca =camera_geoms[ic0]
  cb =camera_geoms[ic1]
  
  fa = ca.imgdist
  fb = cb.imgdist
  
  xa  = FLOAT(xa_pixel + ca.hoffset - ca.nx/2) * ca.pixel_size ; pixel -> cm
  xb  = FLOAT(xb_pixel + cb.hoffset - ca.nx/2) * cb.pixel_size ; pixel -> cm
  
  ; slope of line from focal point to point x0 on focal plane
  ; the funny sign and abs stuff is just to. In principle its just
  ; like the two lines commented out:
  ;   sa     = TAN(ATAN(fa/xa)+ca.ang*!DTOR)
  ;   sb     = TAN(ATAN(fb/xb)+cb.ang*!DTOR)
  angloc = ATAN(fa/(ABS(xa)>1E-4)*SIGN(xa))/!DTOR
  sa     = TAN(!DTOR*(angloc+ca.ang)) 
  angloc = ATAN(fb/(ABS(xb)>1E-4)*SIGN(xb))/!DTOR
  sb     = TAN(!DTOR*(angloc+cb.ang)) 
   
  ; coefficients describing the two rays connecting particle and focal point for both cameras 
  a  = ca.xyz0[1]-ca.xyz0[0]*sa
  b  = sa
  c  = cb.xyz0[1]-cb.xyz0[0]*sb
  d  = sb
  
  ; find intersect       
  x  = (a-c)/(d-b)
  IF ABS(b) GT ABS(d) THEN BEGIN
     y =  a+b*x
  ENDIF ELSE BEGIN
     y =  c+d*x
  ENDELSE
                   
  RETURN,[x,y]    
  
END
