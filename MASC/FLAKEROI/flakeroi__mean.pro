FUNCTION flakeroi::mean,ndist=ndist
  
  KEYWORD_DEFAULT,ndist,1

  img   = FLOAT(*self.img)
  mas   = FLOAT(self->mask())
  iok   = WHERE(SMOOTH(mas,5) EQ 255) 

  RETURN,FLOAT(MEAN(img[iok]))
  

END
