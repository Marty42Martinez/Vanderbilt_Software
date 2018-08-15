FUNCTION flakeroi::texture,ndist=ndist
  
  KEYWORD_DEFAULT,ndist,1

  img   = FLOAT(*self.img)
  mas   = FLOAT(self->mask())
  iok   = WHERE(SMOOTH(mas,5) EQ 255) 
  img   = img / MEAN(img[iok]) * 122
  mat   = ABS(img-shift(img,0,ndist))+ ABS(img-shift(img,ndist,0))

  RETURN,FLOAT(MEAN(mat[iok]))
  

END
