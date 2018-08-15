PRO mc_flake::diff_growth, dt, temperature=temperature,air_press=air_press

  KEYWORD_DEFAULT, temperature, 253.16    ;Kelvin
  KEYWORD_DEFAULT,air_press,100.         ;kPa
  
  ;Calculations taken from EQ 9.4 R&Y pg 160
  ;NEED TO UPDATE THIS SO that if dmin is within 1% of dmax
  ;C = r
  

  dmax   =  self -> get('Dmax')
  u      =  self -> evaluate('fallspeed')
  as     =  self -> get('aspectratio')
  dens   =  self -> evaluate('density')
  mass   =  self -> get('mass_arr')
  
  dm     =  diffusion_ice(dt,T=temperature,mass=mass[0],dmax=dmax,$
            aspectratio=as,air_press=air_press)


  new_m               = mass[0]+dm
  new_vol             = new_m/dens
  new_dmax            = (new_vol*3/(4*!pi*as^2.))^(1./3)
  self.Dmax           = 2*new_dmax
  
  ;stop
  self.mass_arr[0]    = new_m
  self.mass_arr[1]    = mass[1] + dm

end
