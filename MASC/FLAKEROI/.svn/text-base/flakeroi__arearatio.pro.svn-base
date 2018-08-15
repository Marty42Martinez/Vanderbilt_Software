FUNCTION flakeroi::arearatio
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%Created by:Marty: August 24, 2015%%%%%;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%%%%%%%%%Description%%%%%%%%%%%%%%%%;
;calculates area ratio for each snowflake obj
;defined as number pixels in snowflake divided
;by area of circumscribing circle
  
  a = self->evaluate('area')
  e = self->evaluate('ellipse')
  s = self->evaluate('scale')
  
  ar = a /(!PI/4.0 * e.major^2.0 * s^2.0)

  RETURN,ar
  

END
