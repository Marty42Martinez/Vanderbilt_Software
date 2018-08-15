FUNCTION mc_flake::density

  m       = self -> get('mass_arr')
  v       = self -> evaluate('volume')
  
  density = m[0]/v  

  return, density

end
