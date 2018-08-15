FUNCTION mascobs::canvas,histeq=histeq

   xborder=5
  
   f0 = (*self.camera[0].img)
   f1 = (*self.camera[1].img)
   f2 = (*self.camera[2].img)
   
   ell = self -> evaluate('ellipse')
   ell0 = ell[0]
   
   IF KEYWORD_SET(histeq) THEN BEGIN
     f0=HIST_EQUAL(f0)
     f1=HIST_EQUAL(f1)
     f2=HIST_EQUAL(f2)
   ENDIF
   ;stop
  
   s0 = SIZE(f0)
   s1 = SIZE(f1)
   s2 = SIZE(f2)
     
   ymax   = MAX([s0[2],s1[2],s2[2]])
   
   canvas = FLTARR(s0[1]+s1[1]+s2[1]+4*xborder,ymax+2*xborder) + 255.
   
   ;Marty added;
   ;m0      = FINDGEN(s0[1]) # (FLTARR(s0[2])+1) - max(s0[1:2])/2
   ;w0      = TRANSPOSE(m0)
   ;a       = ell0.major
   ;b       = ell0.minor
   ;ang     = ell0.angle
   ;d0      = ROT((m0/a)^2 + (w0/b)^2,ang)
   ;ind0    = where(d0 lt 0.1 and d0 gt 0.05)
   ;f0[ind0] = 255
   
   x0     = xborder
   y0     = xborder+ymax/2 - s0[2]/2
   canvas [x0:x0+s0[1]-1,y0:y0+s0[2]-1]=f0

   x0     = x0 + xborder + s0[1]
   y0     = xborder+ymax/2 - s1[2]/2
   canvas [x0:x0+s1[1]-1,y0:y0+s1[2]-1]=f1
   
   x0     = x0 + xborder + s1[1]
   y0     = xborder+ymax/2 - s2[2]/2
   canvas [x0:x0+s2[1]-1,y0:y0+s2[2]-1]=f2
   
   RETURN,canvas

END


