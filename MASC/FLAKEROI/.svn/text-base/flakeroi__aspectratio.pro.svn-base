FUNCTION flakeroi::aspectratio
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%Created by:Marty: August 24, 2015%%%%%;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%%%%%%%%%Description%%%%%%%%%%%%%%%%;
;calculates aspect ratio for each snowflake obj
;defined as ratio between semi-minor and
;semi-major axes
;NOTE: semi-minor is the maximum linear distance
;measured perpendicular to the semi-major axis
  e = self->evaluate('ellipse')
  s = self->evaluate('scale')
  

  as = (e.minor*s)/(e.major*s)
  
  RETURN,as
  

END
