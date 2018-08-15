FUNCTION mc_container::fallthrough, W,$ ;ADDED W variable for big flake tests
temperature=temperature,air_press=air_press,lwc=lwc;,variables


  KEYWORD_DEFAULT, temperature,    253.16 ; Kelvin
  KEYWORD_DEFAULT,air_press,       100. ;kPa 100 at surface
  ;KEYWORD_DEFAULT,lwc,             2.5e-4 ;kg/m3
  KEYWORD_DEFAULT,lwc,             5.24e-5 ;kg/m3 
  ;Use lwc_agg=1e8*rhol*(4/3)*pi*r^3
  ;1e8 is cloud drop conc r is the mean radius of small drops (5e-6 m)
;Necessary variables: dz, atmo conditions, initial elevation


  H = 1.0 ;meters
  ;H = 10. ;meters
 

  ;chist    = self -> cumhist_st()
  

  
  
  n = self.count()
  
  c2 = obj_new('mc_container',/nofill)
  flakes = self -> toarray()
  
  
  
  totper50= 0
  
  ;mass = flakes[0] -> get('mass_arr')
 
;  
;;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;;%%%%%%%%FOR LOOP: isolates each particle%%%%%%%%%%;
;;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%:  
;  
;  for i =0, n-1 do begin
;    flake = flakes[i] -> clone()
;	tao   = flake -> get('free_path')
;	;W     = self -> w_vector(i)
;;%%%Residence Time%%%;
;    fs         =  flake -> evaluate('fallspeed')
;	dt         =  H/fs
;	
;;%%%%%%%%%%%%%%%%%%%%%%%%%;
;;%%%Diffusional Growth%%%;
;        ;%%%AND%%%;
;      ;%%%Riming%%%;
;;%%%%%%%%%%%%%%%%%%%%%%%%%;
;	flake   -> diff_growth, dt, temperature=temperature, air_press=air_press
;    flake   -> rime, H, lwc=lwc
;
;;%%% 1/15/2016 %%%;
;;Turnig off Aggregation
;  
;    c2.add, flake
;	if i mod 100 eq 0 then begin
;	  print, i
;
;	endif
;  endfor
;
;;%%% Feb 1, 2016 %%%;
;;Skipping the section where we look at w_vec for a few experiment trials;  
;  return, c2
;end

;%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%Aggregation Testing%%%;  
;%%%%%%%%%%%%%%%%%%%%%%%%%;
  ;flakes = c2 -> toarray()
  d_arr    = self -> get('Dmax')
  big      = where(d_arr eq max(d_arr))
  flake =  flakes[big] -> clone(/keep_seed)
  tau_arr   = []
  ;W     =  self -> w_vector(flake)
;%%Added 1/28/16%%;
;%%Want to look at how free path changes%%;
;  beta_ag  = total(W)*(40./n)
;  c2.remove,-1
;  tau       = flake.free_path
;  flake.free_path = tau - H*beta_ag
;  if flake.free_path lt .001 then begin
;    flake.free_path = -alog(randomu(seed,1))
;  endif
;  ;dfdd     = OBJ_NEW('dfdd',W)
;  ;cont   =  {w_vec:W,container:c2}
;  ;return, cont
;  c2.add, flake
;  ;return, c2
;end
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%%%%%%%Aggregation%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;

	;W        = self -> w_vector(flake)
	dfdd     = OBJ_NEW('dfdd',W)
	beta_ag  = dfdd -> get_tag('cmax')
	beta_ag  = beta_ag*(1e8/n)
	tau      = flake -> get('free_path')
	;stop
	;print, tao/beta_ag
	
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
	  ;print, tau
	endif
    pre_agg = flake -> get('num_aggregate')
    ;if z ne 0 then stop
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%WHILE LOOP: particle falls distance dz%%%%%%%%%%;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%: 
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
	   ;2/17 array will be used to look at free path values
	   ;Going to be passed from here in a structure
	   tau_arr = [tau_arr,tau]
	   
	   ;W          = self -> w_vector(flake)
	   
	   dfdd       = OBJ_NEW('dfdd',W)
	   beta_ag    = dfdd -> get_tag('cmax')
	   beta_ag    = beta_ag*(1e8/n)
	   ;tau        = flake -> get('free_path')
	   ;print, tau
	   if beta_ag lt 0.0001 then begin
	     dz = Z
	   endif else begin
	     dz = tau/beta_ag
	   endelse
	   ;dz         = tao/beta_ag
	   
	   if dz ge Z then begin
	     tau              = tau - Z*beta_ag
	     flake.free_path  = tau
		 Z=0
	   endif
	   
	
	endwhile
	;if beta_ag ne 0.0 then stop
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
	;c2.add, flake
	;print, 'Number of aggregations for the large particle: ',totper50
	;if i mod 100 eq 0 then begin
	;  print, i
	;  print, 'Number of aggregations per 100 particles: ', totper50
	;  totper50=0
	;endif
  ;endfor
	
  
  ;cont   =  {w_vec:W,container:c2}
  cont   =  {tau_arr:tau_arr,container:c2}
  return, cont
  ;return, c2

  ;


end
