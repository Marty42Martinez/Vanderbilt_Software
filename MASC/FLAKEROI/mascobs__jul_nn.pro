FUNCTION mascobs::jul_nn,jul=jul
  
  out = { ind : -1L, $
          dt  : !VALUES.D_NAN $
        }  
  IF KEYWORD_SET(jul) THEN BEGIN
     jul_flake = self->get('julday') 
     dt        = jul - jul_flake[0]
     i         = WHERE(ABS(dt) EQ MIN(ABS(dt)))
     out.ind   = i[0]
     out.dt    = dt[i[0]]
  ENDIF
  
  RETURN,out
  

END
