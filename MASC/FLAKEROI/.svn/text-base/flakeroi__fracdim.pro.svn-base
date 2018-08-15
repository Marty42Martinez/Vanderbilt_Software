FUNCTION flakeroi::fracdim,out=out

  image = FLOAT(*self.mask)
  
  s = SIZE(image)
  
  sx = s[1]
  sy = s[2]
  
  a  = 0.9
  n  = ALOG(10.0/MIN([sx,sy]))/ALOG(a)
  
  out = { $
          e : FLTARR(n), $
          n : FLTARR(n)  $
        }
        
  FOR i=0,n-1 DO BEGIN
  
      out.e[i] = 1.0/a^i
      img      = CONGRID(image,sx/out.e[i],sy/out.e[i])
      o        = OBJ_NEW('flakeroi',img,/noparams)            
      out.n[i] = o->perimeter()      
      OBJ_DESTROY,o
  
  ENDFOR
  
  IF N_ELEMENTS(out.e) LT 5 THEN RETURN,-1
  
  dim = - REGRESS(ALOG(out.e),ALOG(out.n>0.1))  


  RETURN,FLOAT(dim)


END
