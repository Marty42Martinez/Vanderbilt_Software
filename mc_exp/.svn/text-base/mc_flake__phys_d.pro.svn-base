FUNCTION mc_flake::phys_d
  ;No longer valid;
  ;12/07/2015;
  ;v   = self.volume ;in m3 
  v        = self -> evaluate('volume')
  mass     = self -> get('mass_arr')
  m        = mass[0]
  diameter = ((mass*1e3)/3.8e-4)^0.5
  diameter = diameter/100. ;convert cm to m
  ;diameter = 2*((3*v/(4*!pi))^(1./3))
  ;mass   = (3.8e-4*d^2.)/1e3
  
  return, diameter
  
  
end
