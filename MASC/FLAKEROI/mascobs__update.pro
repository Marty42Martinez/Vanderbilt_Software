FUNCTION mascobs::update
  
  ;stop
  jul       = self->julday()
  fs        = self.fallspeed
  dir       = self.directory
  flaken    = self.flakenumber
  
  ;cams      = self.camera
  ;st0       = cams[0] -> tostruct()
  hold0     = self.camera[0] -> tostruct()
  hold1     = self.camera[1] -> tostruct()
  hold2     = self.camera[2] -> tostruct()
  
  desc0     = hold0.descriptors
  desc1     = hold1.descriptors
  desc2     = hold2.descriptors
  
  xyz       = [desc0.x,desc0.y,desc0.z]
  
  img0      = *hold0.img
  img1      = *hold1.img
  img2      = *hold2.img
  
  m0        = desc0.scale
  m1        = desc1.scale
  m2        = desc2.scale
  
  if0       = desc0.infocus
  if1       = desc1.infocus
  if2       = desc2.infocus
  
  nmulti    = desc0.multiflake
  ;need to put a few more things in
  
  ;stop
  o = OBJ_NEW('mascobs',jul,fs,xyz,img0,img1,img2,m0,m1,m2, $
              if0,if1,if2,nmulti,dir,flaken)
  return,o

end
