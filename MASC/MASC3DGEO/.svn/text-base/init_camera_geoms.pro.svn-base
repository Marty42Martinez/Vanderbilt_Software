
FUNCTION camera_geom,icamera,f=f,hoffsets=hoffsets,voffsets=voffsets,dofin=dofin

   ; offset of camera (derived from find_horizonal_offset.pro)
   ; offset of camera (derived from find_vertical_offset.pro)   
   ; focal length....
   KEYWORD_DEFAULT,hoffsets , [+17.,0.,+17.]
   KEYWORD_DEFAULT,voffsets , [+31.,0.,+17.]
;   KEYWORD_DEFAULT,f        , 1.25
   KEYWORD_DEFAULT,f        , 1.283
   KEYWORD_DEFAULT,dofin    , 1.653 ; this for f/5.6 and 12.5 mm lense
   
   fval = f    [icamera<(N_ELEMENTS(f)-1)]
   dof  = dofin[icamera<(N_ELEMENTS(f)-1)]
   
   ; lens specific image distance....
   ; from John...
   objdist =13.826
   deltah= 3.87
   imgdist = -1.
   IF fval EQ 1.283 THEN imgdist = 1.414
   IF fval EQ 1.25  THEN imgdist = 1.339
   IF fval EQ 1.60  THEN imgdist = 1.748
   
   
   IF imgdist EQ -1 THEN STOP ;did not find lens specific image distance...
   
   
   ; MASC  camera number and focal length in cm
   ; positions of focal plane of in MASC grid [cm] offset from
   ; center of decagon
   CASE icamera OF
     0 : cpos =[-11.23, -15.46,0.]
     1 : cpos =[  0.00, -19.11,0.] ; this middle camera... reference]
     2 : cpos =[+11.23, -15.46,0.]
   ENDCASE
   cpos = cpos/NORM(cpos)*19.11
   
   ;find position of center of lense ...
   ang = 36.0*(icamera -1) 
   x0  = cpos[0] + COSD(90.0+ang)*imgdist
   y0  = cpos[1] + SIND(90.0+ang)*imgdist

   ang = [-36., 0.,+36]
   out = { $
           cpos       : cpos,                 $ ; camera reference position [cm] from center of decagon
           ang        : ang[icamera],         $ ; position of camera orientation relative to
                                                ; positive x-direction (Parallel to decagon rim of middle camera (#1).
           xyz0       : [x0,y0,0.],           $ ; position of center of lens from center of decagon
           f          : fval,                 $ ; focal length [cm]
           imgdist    : imgdist,              $ ; image distance corrsponding to focal length [cm]
           objdist    : objdist,              $ ; object distance
           deltah     : deltah,               $ ; gap between onj and image distance for thick lens..
           dof        : dof    ,              $ ; object distance
           pixel_Size : 3.45/1E4,             $ ; size of CCD pixels in [cm] (=3.45 micron)
           nx         : 2448L,                $ ; image size x direction in [pixel]
           ny         : 2048L,                $ ; image size y direction in [pixel]
           hoffset    : hoffsets[icamera],    $ ; offset of camera (derived from find_horizonal_offset.pro) in [pixel]
           voffset    : voffsets[icamera]     $ ; offset of camera (derived from find_vertical_offset.pro)  in [pixel]
          } 

   RETURN,out

END

FUNCTION init_camera_geoms,f=f,hoffsets=hoffsets,voffsets=voffsets,dofin=dofin
          
      cg0         = camera_geom(0,f=f,hoffsets=hoffsets,voffsets=voffsets)
      cam_geoms    = REPLICATE(cg0,3)
      cam_geoms[1] = camera_geom(1,f=f,hoffsets=hoffsets,voffsets=voffsets)
      cam_geoms[2] = camera_geom(2,f=f,hoffsets=hoffsets,voffsets=voffsets)

      RETURN,cam_geoms

END
