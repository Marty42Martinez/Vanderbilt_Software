PRO mc_flake::aggregate, f2

  ;Updated 12/07/2015;

  m1_arr   = self->get('mass_arr')
  m1       = m1_arr[0]
  rho1     = self -> evaluate('density')
  num      = self -> get('num_aggregate')
  as1      = self -> get('aspectratio')
  
  m2_arr   = f2 -> get('mass_arr')
  m2       = m2_arr[0]
  rho2     = f2 -> evaluate('density')
  

  
  new_m               = m1+m2
  mass_change         = new_m - m1_arr[0]
  self.mass_arr[3]    = m1_arr[3] + mass_change
  self.mass_arr[0]    = total(self.mass_arr[1:4])
  
  new_rho             = (m1*rho1 + m2*rho2)/(m1+m2)
  new_vol             = new_m/new_rho
  new_rmax            = (new_vol*3/(4*!pi*as1^2.))^(1./3)
  ;Changed on 2/8/16;
  ;Now the partical CANNOT shrink when aggregating;
  self.Dmax           = (2*new_rmax) > self.dmax

  self.num_aggregate  = num +1
  
  ;return, 1


end
