PRO mc_flake::rime, dz, lwc=lwc
  
  
  ;KEYWORD_DEFAULT,lwc,     2.5e-4 ;kg/m3
  KEYWORD_DEFAULT,lwc,             5.24e-5 ;kg/m3
  
  
  m_arr     =  self -> get('mass_arr')
  mass      =  m_arr[0]
  ;Changed 2/8/16;
  ;We now use physical diameter to calculate riming
  ;Instead of D_le from R&Y
  dmax      =  self -> get('dmax')
  rmax      =  dmax/2.
  ;d_le      =  self -> evaluate('d_le')
  ;dmax      =  d_le/2
  rho_W     =  1000; kg/m3
  E         =  self -> evaluate('rim_eff')
  updraft   =  0; the velocity of the atmosphere in the Z direction
  u         =  self -> evaluate('fallspeed')
  
  ;Taken from Rogers and Yao Equation 9.8 (page 165)
  ;ice-growth.pdf is also a useful tool i found [Kenneth Libbrecht, Caltech]
  dm        =  -!pi*E*lwc*(rmax^2)*(u/(updraft-u))*dz
  
  
  self.mass_arr[2]    = dm + m_arr[2]
  ;self.mass_arr[0]    = total(self.mass_arr[1:4])
  self.mass_arr[0]    = dm +m_arr[0]
  

 

end 
