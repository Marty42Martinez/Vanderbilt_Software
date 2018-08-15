FUNCTION flakeroi::ellipse

    xpoly = *self.data 
    ind   = WHERE(xpoly[0,*] NE 0 AND xpoly[1,*] NE 0)
    x     = REFORM(xpoly[0,ind])
    y     = REFORM(xpoly[1,ind]) 
    xpoly = xpoly[0:1,ind]
    
    e     = x * 0.0 +1
    d     = (x # e - e # x)^2.0 + (y # e - e # y)^2.0

    ind   = (WHERE(d EQ MAX(d)))[0]
    i1    = ind MOD N_ELEMENTS(x)
    i2    = ind  /  N_ELEMENTS(x)
    
    major = SQRT(d[ind])
    dy   = y[i1]-y[i2]
    dx   = x[i1]-x[i2]
    angle = SIGN(dy)*ACOSD((dx)/major)
    
    rotm = FLTARR(2,2)
    rotm[0,0] =   COSD(angle)
    rotm[1,1] =   COSD(angle)
    rotm[0,1] =   SIND(angle)
    rotm[1,0] =  -SIND(angle)

    asd      = rotm # xpoly
    asd[0,*] = asd[0,*] - MEAN(asd[0,*])
    asd[1,*] = asd[1,*] - MEAN(asd[1,*])
     
    minor  = MAX(asd[1,*])-MIN(asd[1,*])
    
    c = self->centroid()
    
    s = size(*self.mask)
    
    out = { $
;            x0    : c[0] , $
;            y0    : c[1] , $
            x0    : s[1]/2 , $
            y0    : s[2]/2 , $
            angle : angle, $
            major : major, $
            minor : minor  $
          }
           
    RETURN,out

END
