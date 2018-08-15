FUNCTION masc_hv2xyz,hv_a,hv_b,icam_a,icam_b,f=f,hoffsets=hoffsets,voffsets=voffsets

   ; hv1,hv2 two vectors of roizontal and vertical positions, one for camera B and one for cam B
   xy = find_intersect(hv_a[0],hv_b[0],icam_a,icam_b,f=f,hoffsets=hoffsets,camera_geoms=camera_geoms)
   
   da = NORM(xy-camera_geoms[icam_a].xyz0[0:1])
   db = NORM(xy-camera_geoms[icam_a].xyz0[0:1])
   
   zfoca = hv_a[1] + camera_geoms[icam_a].voffset -  camera_geoms[icam_a].ny/2
   zfocb = hv_b[1] + camera_geoms[icam_b].voffset -  camera_geoms[icam_b].ny/2
          
   za = zfoca * da / camera_geoms[icam_a].imgdist * camera_geoms[icam_b].pixel_size 
   zb = zfocb * db / camera_geoms[icam_b].imgdist * camera_geoms[icam_b].pixel_size
   
   RETURN,[xy,(za+zb)/2.]

END


