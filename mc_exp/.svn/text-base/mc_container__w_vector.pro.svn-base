FUNCTION mc_container::w_vector, flake

  d_arr = self -> get('Dmax')
  u_arr = self -> evaluate('fallspeed')
  
  d1    = flake -> get('Dmax')
  u1    = flake -> evaluate('fallspeed')
  
  ;Previous method
  ;Changed because we grow snowflake BEFORE tesing for aggregation
  ;changed: 12/17/2015
  ;d1    = d_arr[index]
  ;u1    = u_arr[index]
  
  ;coll_A        = (!pi/4)*(d1+d_arr)^2
  ;Feb 10 FOR Agg vs Rime tests;
  coll_A        = (!pi/4)*(d1)^2
  U_eff         = (u1-u_arr)/u1
  u_ind         = where(U_eff lt 0.)
  ;stop
  U_eff[u_ind]  = 0.
  E             = 1 ;Aggregation Efficiency
  ;was 0.25 pulled from some paper....
  ;stop
  
  W             = coll_A*U_eff*E

  return, W

end
