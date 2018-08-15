FUNCTION flakeroi::D_LE
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%Created by:Marty: August 24, 2015%%%%%;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%%%%%%%%%Description%%%%%%%%%%%%%%%%;
;calculates the liquid equivalent diameter
;for each snowflake. Calculated using accepted
;mass diameter relationships
  
  e = self->evaluate('ellipse')
  s = self->evaluate('scale')
  
  
  ;convert e.major to mm for DLE calculations
  rmax = e.major*s*(10)
  
  D_LE = (6*.022*(rmax^2.1)/!pi)^(1./3.)*(1./10) ;returns calculation in cm

  RETURN,D_LE
  

END






