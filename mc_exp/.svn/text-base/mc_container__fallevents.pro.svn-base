FUNCTION mc_container::fallevents, falldist = falldist

  KEYWORD_DEFAULT, falldist,       50. ; meters
  
  
  ;Things that we need to consider next!;
  
  ;Air pressure 
  ;--needs to change with altitude
  ;--EQ Ph=p0*exp(-mgh/kT)
  ;--find amu of wet air
  ;--dry m=29 amu ==0.029kg/mol
  
  ;Temperature
  ;--needs to change with altitude
  ;??maybe create a lookup table instead of calculating
  ;on average ~ 9.8 degC/km
  
  ;Feb 10
  ;Specifying WHEN to save information from successive fall through exps;
  ;Should include a few keywords like record_stepsize and fallthrough_height
  ;Can also create a switch to save full mc_container objects or just specific parameters
  

  
  
  
  c_beg    = self -> clone()
  d_arr    = self -> get('dmax')
  m_arr  = self -> get('mass_arr')
  fs_arr   = self -> evaluate('fallspeed')
  dens_arr = self -> evaluate('density')
  ;d_arr  = []
  ;m_arr  = []
  ;W_vec  = []
  tau_arr  = []
  n_agg   = [0]
  fs     = []
  dens_arr  = dens_arr[-1]
  agg_mass  = m_arr[3]
  
  fl     = c_beg -> toarray()
  big      = where(d_arr eq max(d_arr))
  flake =  fl[big] -> clone(/keep_seed)
  W     =  self -> w_vector(flake)
  print,'Container Total Fall Distance'
  print,'    ','1','meters'
  cont  = self -> fallthrough(W)
  ;container = cont.container
  container = cont.container
  agg_count = container -> get('num_aggregate')
  ;%%% The section below will save the info from the 1st meter of descent%%%;
  ;Most useful when gathering data after every iteration of fallthrough;
  ;d     = cont -> get('dmax')
  ;m     = cont -> get('mass_arr')
  ;dens   = cont -> evaluate('density')
  ;fs     = cont -> evaluate('fallspeed')
  ;d_arr     = [d_arr,d]
  ;fs_arr    = [fs_arr,fs]
  ;m_arr     = [m_arr,m]
  ;agg_mass  = [agg_mass,m[3,-1]]
  ;dens_arr  = [dens_arr,dens[-1]]
  
  
  ;Falldist/10 used when H=10 in fallthrough
  for i = 2,falldist/1. do begin
    if i mod 100 eq 0 then begin
      print,'Container Total Fall Distance'
	  print,'    ',i,'meters'
	endif
	cnext = container -> fallthrough(W)
	;fpath = cnext -> get('free_path')
	;fp    = [fp,fpath[-1]]
	
	
	if i mod 10 eq 0 then begin
	  ;d = cnext.container -> get('dmax')
	  agg    = cnext.container -> get('num_aggregate')
	  n_agg  = [n_agg,agg[-1]-agg_count[-1]]
	  tau_arr = [tau_arr,cnext.tau_arr]
	  ;d     = cnext -> get('dmax')
	  ;m     = cnext -> get('mass_arr')
	  ;dens   = cnext -> evaluate('density')
	  ;fs     = cnext -> evaluate('fallspeed')
	  ;W_vec = [W_vec,cnext.w_vec]
	  ;d_arr     = [d_arr,d]
	  ;fs_arr    = [fs_arr,fs]
	  ;m_arr     = [m_arr,m]
	  ;agg_mass  = [agg_mass,m[3,-1]]
	  ;dens_arr  = [dens_arr,dens[-1]]
	endif

	;container = cnext.container -> clone()
	container = cnext.container -> clone()
	agg_count = cnext.container -> get('num_aggregate')
  endfor
  ;fl     = c_beg -> toarray()
  flake  = fl[-1] -> clone(/keep_seed)
  rime_mass  = [0]

;  for j = 1,100 do begin
;    flake -> rime, 10
;    m       = flake -> get('mass_arr')
;    rime_mass   = [rime_mass,m[2]]
;  endfor
  ;dens_arr = m_arr[0,*]/v_arr
  
  ;out = {d_arr:d_arr,W_vector:W_vec,start_c:c_beg,end_c:container}
  ;out  = {fp:fp,start_c:c_beg,end_c:container}
  ;out = {density:dens_arr,d_arr:d_arr,start_c:c_beg,end_c:container}
  ;out  = {density:dens_arr,rime_mass:rime_mass,agg_mass:agg_mass,dmax:d_arr,fspeed:fs_arr,start_c:c_beg,end_c:container}
  out   = {n_agg:n_agg,tau_arr:tau_arr,start_c:c_beg,end_c:container}
  return, out



end
