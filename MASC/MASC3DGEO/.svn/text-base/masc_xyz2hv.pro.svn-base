FUNCTION masc_xyz2hv,icamera,x,y,z,_EXTRA=_EXTRA,magnification=magnification,infocus=infocus

   ; xyz vector with coordinates [x,y,z] relative to center of decagon in [cm]
   ; positive z : upwards
   ; postive  x : parallel to rim of middle camera pointing  

;   COMMON c_cameras,camera_geoms
;   IF N_ELEMENTS(camera_geoms) EQ 0 THEN camera_geoms = init_camera_geoms(f=f,hoffsets=hoffsets,voffsets=voffsets)
 
   camera_geoms  = init_camera_geoms(_EXTRA=_EXTRA)
   
   ; vector from point x,y,z to center of lense...
   xyz           = [x,y,z]
   diff          = xyz-camera_geoms[icamera].xyz0
   dobj          = NORM(diff)                                ; object distance from [x,y,z] to focal point 
   ndiff         = diff/dobj                                 ; normalized vector
   
   ;angle between the two vectors   
   czen          = TOTAL(-ndiff*camera_geoms[icamera].xyz0)/NORM(camera_geoms[icamera].xyz0)
   czen          = czen<1.
   dimg          = camera_geoms[icamera].imgdist / czen
   magnification = dobj / dimg * camera_geoms[icamera].pixel_size/SQRT(2)      ; magnification factor of object [cm/pixel]   
   
   ; value between 0 and 1 w/ 0 bein perferctly in focus, 1 at edge of focal area, 
   ; values beyond 1 increasing distance from focus
   ; note: this simply assumes camera to in focus at [0,0,0], i.e.at center of decagon 
   infocus     = NORM(xyz) / (camera_geoms[icamera].dof / 2.0)
   
   ; now calculate the v and h positions of the image....    
   xyzimg = camera_geoms[icamera].xyz0 - dimg * ndiff          ; position of img in 3d Space...
   xyzimg = xyzimg -  camera_geoms[icamera].cpos               ; now relative to center position of image...
   v      = -xyzimg[2] / camera_geoms[icamera].pixel_size      ; that's the position on the image vetical...
   h      = NORM(xyzimg[0:1]) / camera_geoms[icamera].pixel_size 

   IF xyzimg[0] GT camera_geoms[icamera].cpos[0] THEN h = -h    ; it's to the left....
   
   h = h - camera_geoms[icamera].hoffset + camera_geoms[icamera].nx/2
   v = v - camera_geoms[icamera].voffset + camera_geoms[icamera].ny/2   
   
   RETURN,[h,v]

END


