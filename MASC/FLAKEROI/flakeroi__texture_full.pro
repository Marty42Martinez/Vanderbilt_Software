FUNCTION flakeroi::texture,ndist=ndist,cooc=cooc
  
  KEYWORD_DEFAULT,ndist,1

  img   = FLOAT(*self.img)
  mas   = FLOAT(self->mask())
  iok   = WHERE(SMOOTH(mas,5) EQ 255) 
  img   = img / MEAN(img[iok]) * 122
  mat   = ABS(img-shift(img,0,ndist))+ ABS(img-shift(img,ndist,0))
  diff  = FINDGEN(255)
  cooc  = {  $
            matrix           : mat,            $
            entropy          : img * 0.0,      $
		    homogeneity      : img * 0.0,      $
		    energy           : img * 0.0,      $
		    asm              : img * 0.0,      $
		    sigma            : img * 0.0       $
           }

   s = SIZE(img)
   f = 2
   FOR i=f,s[1]-f-1 DO BEGIN
	  FOR j=f,s[2]-f-1 DO BEGIN
		 
         p = HISTOGRAM( mat[(i-f):(i+f),(j-f):(j+f)]<255,min=0,bin=1,max=255)
         p = FLOAT(p)/TOTAL(p)
         
		 cooc.entropy     [i,j] = total(p * ALOG(diff+1))
		 cooc.energy      [i,j] = total(p * diff)
		 cooc.homogeneity [i,j] = total(p / (1+diff^2))
		 cooc.asm         [i,j] = total(p^2)
		 cooc.sigma       [i,j] = sqrt(total((diff-cooc.energy[i,j])^2*p))

	  ENDFOR
   ENDFOR    


   out = { $
           entropy     : MEAN(cooc.entropy     [iok]), $ 
		   energy      : MEAN(cooc.energy      [iok]), $ 
		   homogeneity : MEAN(cooc.homogeneity [iok]), $
		   asm         : MEAN(cooc.asm         [iok]), $
		   sigma       : MEAN(cooc.sigma       [iok])  $
          }  
   RETURN,out
  

END
