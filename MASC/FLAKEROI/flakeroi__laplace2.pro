FUNCTION flakeroi::laplace2
  
  KEYWORD_DEFAULT,ndist,1
  
  kernel = FLTARR(3,3)
  kernel[1,1]=4
  kernel[0,1]=-1 
  kernel[1,0]=-1 
  kernel[2,1]=-1 
  kernel[1,2]=-1 

  img   = FLOAT(*self.img) / self->mean() * 120.
  img   = CONVOL(img,kernel)
  mas   = FLOAT(self->mask())

  iok   = WHERE(SMOOTH(mas,5) EQ 255) 

  RETURN,FLOAT(MEAN(img[iok]))
  

END
