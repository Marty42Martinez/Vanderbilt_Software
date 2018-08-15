FUNCTION texture_new2,image_in,mn,std


   image = FLOAT(image_in)
   mat   = image-shift(image,0,1)+ image-shift(image,1,0)
   mat   = ABS(mat/2)
   diff  = FINDGEN(255)
   cooc  = {  $
            matrix           : mat,              $
            entropy          : image * 0.0,      $
		    homogeneity      : image * 0.0,      $
		    energy           : image * 0.0,      $
		    asm              : image * 0.0,      $
		    sigma            : image * 0.0       $
           }

   s = SIZE(image)
   f = 2
   FOR i=f,s[1]-f-1 DO BEGIN
	  FOR j=f,s[2]-f-1 DO BEGIN
		 
         p = HISTOGRAM( mat[(i-f):(i+f),(j-f):(j+f)],min=0,bin=1,max=255)
         p = FLOAT(p)/TOTAL(p)
         
		 cooc.entropy     [i,j] = total(p * ALOG(diff+1))
		 cooc.energy      [i,j] = total(p * diff)
		 cooc.homogeneity [i,j] = total(p / (1+diff^2))
		 cooc.asm         [i,j] = total(p^2)
		 cooc.sigma       [i,j] = sqrt(total((diff-cooc.energy[i,j])^2*p))

	  ENDFOR
   ENDFOR    

   RETURN,cooc
   
END

;PRO test

IF N_ELEMENTS(img) EQ 0 THEN BEGIN
   restore,'new/asd.sav' 
   q   = aggregates[3].cameras[0].flake_img
   img = q[400-156/2:400+156/2,400-146/2:400+146/2]
ENDIF

out = texture_new(img)
i   = IMAGE(out.entropy)

END
