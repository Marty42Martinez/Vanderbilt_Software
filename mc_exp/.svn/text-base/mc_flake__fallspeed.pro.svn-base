FUNCTION mc_flake::fallspeed, _EXTRA=_EXTRA

  mass   = self -> get('mass_arr')
  dmax   = self -> get('dmax')
  as     = self -> get('aspectratio')
  ;Mathematically a spheroid will have equal aspect and area ratios;
  m      = mass[0]
  ;stop
  return,fallspeed_ice(m,dmax,area_ratio=as,_EXTRA=_EXTRA)
   
end
