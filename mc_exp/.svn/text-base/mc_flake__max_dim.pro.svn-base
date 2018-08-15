FUNCTION mc_flake::max_dim
  ;NO LONGER VALID;
  ;12/7/2015;
  phys_d     = self -> evaluate('phys_d')
  aspect_r   = 0.65
  ax1        = (phys_d/2.)*aspect_r^(1./3)
  ax2        = ax1/aspect_r

  max_d      = 2*max([ax1,ax2])
  return, max_d


end
