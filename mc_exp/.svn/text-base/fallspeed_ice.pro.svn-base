FUNCTION fallspeed_ice,m,dmax, $
            density_air=density_air,dynamic_viscosity=dynamic_viscosity,area_ratio=area_ratio

  
  KEYWORD_DEFAULT,density_air,1.2           ; 1.2 at sea level kg/m3
  KEYWORD_DEFAULT,dynamic_viscosity,1.7E-5  ; kg/m3
  KEYWORD_DEFAULT,area_ratio ,0.48          ; explanation in fall speed writeup
 
  del0       = 8.0
  c0         = 0.35

  Xstar      = (8*density_air*m*9.8)/((dynamic_viscosity^2.)*!pi*area_ratio^0.5)
  Re         = (del0^2./4.)*((1+(4*sqrt(Xstar))/(sqrt(c0)*del0^2.))^0.5 -1)^2.
  u          = dynamic_viscosity*Re/(density_air*dmax)
  
  return, u
  
end
