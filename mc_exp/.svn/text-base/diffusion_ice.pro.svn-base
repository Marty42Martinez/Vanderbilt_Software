FUNCTION diffusion_ice,dt,T=T,mass=mass,dmax=dmax,$
aspectratio=aspectratio,air_press=air_press

  ;Calculations taken from EQ 9.4 R&Y pg 160
  
  KEYWORD_DEFAULT,       T            ,253.16    ;Kelvin
  KEYWORD_DEFAULT,       air_press    ,100.      ;kPa
  KEYWORD_DEFAULT,       mass         ,6.55e-9   ;kg
  KEYWORD_DEFAULT,       Dmax         ,1e-4      ;m [0.1 mm]
  KEYWORD_DEFAULT,       aspectratio  ,0.48

  coeffs =  conductivity_diffusion(T)
  
  m      =  mass
  as     =  aspectratio

  r      =  dmax/2.
  dmin   =  dmax*as
  A      =  sqrt(dmax^2. - dmin^2.)
  ei     =  saturation_pressure(T,ice=1)
  es     =  saturation_pressure(T)
  D      =  coeffs.D*(100./air_press)
  K      =  coeffs.K
  Rv     =  461.5 ;J/kgK
  Ls     =  2.83e6 ;J/kg or m^2/s^2
                   ;Latent Heat of Sublimation
				   ;Changes with temp, but only slightly [R&Y: pg 16]
  
  ;stop
  C      =  A/ALOG((dmax+A)/dmin)
  Si     =  es/ei
  
  ;stop
  dm     =  dt*(4*!pi*C*(Si-1))/((Ls/(Rv*T)-1)*(Ls/K/T) + (Rv*T/ei/D))
  
  return, dm



end
