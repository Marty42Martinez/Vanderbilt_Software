FUNCTION flakeroi::stdv,ndist=ndist
  
  KEYWORD_DEFAULT,ndist,1

  img   = FLOAT(*self.img)
  mas   = FLOAT(self->mask())
  iok   = WHERE(SMOOTH(mas,5) EQ 255) 

  RETURN,FLOAT(STDDEV(img[iok]))
  

END
