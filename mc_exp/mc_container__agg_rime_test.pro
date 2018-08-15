FUNCTION mc_container::agg_rime_test,W,$
temperature=temperature,air_press=air_press,lwc=lwc

  KEYWORD_DEFAULT, temperature,    253.16 ; Kelvin
  KEYWORD_DEFAULT,air_press,       100. ;kPa 100 at surface
  KEYWORD_DEFAULT,lwc,             5.24e-5 ;kg/m3
  ;Use lwc_agg=1e8*rhol*(4/3)*pi*r^3
  ;1e8 is cloud drop conc r is the mean radius of small drops (5e-6 m)
  
  H = 1.0 ;meters
  
  n = self.count()
  
  c2 = obj_new('mc_container',/nofill)
  flakes = self -> toarray()
  
  d_arr    = self -> get('Dmax')
  big      = where(d_arr eq max(d_arr))
  flake =  flakes[big] -> clone(/keep_seed)
  
  dfdd     = OBJ_NEW('dfdd',W)
  beta_ag  = dfdd -> get_tag('cmax')
  beta_ag  = beta_ag*(1e8/n)
  tau      = flake -> get('free_path')
  
  Z = H ;Z keeps track of particle location in fallthrough column
	
;%%% Calculate Fall Distance %%%;
  if beta_ag lt 0.0001 then begin
    dz = H
  endif else begin
	dz = tau/beta_ag
  endelse
  if dz ge H then begin
	Z                = 0
	tau              = tau - H*beta_ag
	flake.free_path  = tau
  endif
  pre_agg = flake -> get('num_aggregate')
  
  
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;

  while Z gt 0 do begin
	Z = Z-dz
	ind = dfdd -> draw(1)
	if ind eq (n-1) then ind = (n-2)
	f2 = flakes[ind] -> clone(/keep_seed)
	flake -> aggregate, f2
	;2/10/16;
	;Added to preserve randomness;
	;flake -> change_seed
	sd               = flake -> get('seed')
	   
	T                = randomu(*sd,1)
	tau              = -alog(T)
	   
	   
	dfdd       = OBJ_NEW('dfdd',W)
	beta_ag    = dfdd -> get_tag('cmax')
	beta_ag    = beta_ag*(1e8/n)
	if beta_ag lt 0.0001 then begin
	  dz = Z
	endif else begin
	  dz = tau/beta_ag
	endelse

	   
	if dz ge Z then begin
	  tau              = tau - Z*beta_ag
	  flake.free_path  = tau
      Z=0
	endif
	   
	
  endwhile
  agg = flake -> get('num_aggregate')
  agg = agg - pre_agg
  totper50 = totper50 + agg
	
;%%%This for loop has been altered for the agg vs rime tests%%%:
  for i = 0,n-1 do begin
	if i eq big then begin
	  c2.add, flake
	endif else begin
	  f = flakes[i] -> clone(/keep_seed)
	  c2.add, f
	endelse
  endfor
	
  return, c2


end
