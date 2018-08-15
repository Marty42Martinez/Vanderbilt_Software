FUNCTION mc_container::fallspeed_lookup
  
  ;IDEA;
  ;create array[size:n_particles, 3] with all possible combinations of 
  ;p_dens[col0], p_dia[col1], and a_dens[col2] (air density)
  ;Look for unique pairs of p_dens and p_dia, then combine those with all a_dens values
  
  ;Main goal;
  ;Find a value u that satisfies the equation 8.4 in Rogers and Yao
  
  ;Call a function within this to execute the following steps;
  ;%%%%% fspeed_calc
  ;create an array of Re (Reynold's number) values using the following:
  ;Re = a_dens*u*(p_dia/mu) ;mu is dynamic viscosity
  ;Will be an array because we are using an array of u values [range=0.05:6 m/s]
   
  ;Re is used to calculate C_d (coefficient of drag) [array of same size as Re]
  ;Use equation 7 from Mikhail paper to do this
  
  ;The rest of the parameters in eq 8.4 are easily defined
  ;rho_L is the density of the particle
  ;rho is the density of air
  
  ;we need to compare two arrays to find the exact value of u that satisfies 8.4
  ;Array 1: filled with u^2
  ;Array 2: filled with values calculated from equation 8.4
  ;Should only be 1 (or a small range?) of u values that meet this requirement
  
  ;fspeed_calc will return one (or small range?) fall speed value
  ;%%%%%
  
  
  
  ;fall speed value is put into an array [size:n_particles]
  ;that correspond to a row from the first array mentioned [n_part,3]
  ;maybe put both arrays into a structure and return that as the lookup table?
  
  p_dens  = self -> evaluate('density')
  p_dia   = self -> evaluate('phys_d')
  n_part  = self -> count()
  
  a_dens  = 9.0 ;Because 3km above surface is a good altitude for cloud loc
  ;a_dens  = findgen(18)*0.5
  ;n       = n_part*nelements(a_dens)
  
  ;Not sur if I want there to be 3 columns or 3 rows
  ;Currently: 3 columns
  params  = fltarr(3,n_part)
  params[0,*] = p_dens
  params[1,*] = p_dia
  params[2,*] = a_dens
  
  u_lookup    = fltarr(n_part)
  for i = 0,n_part-1 do begin
    trip = params[*,i]
	u_lookup[i] = fspeed_calc(trip)
  
  endfor
  ;Got work to do SON!
  fallspeed_table = {$
    parameter_tags:['Particle Density','Particle Diameter', 'Air Density'],$
	parameters:params,$
	fallspeeds:u_lookup}
	
  return, fallspeed_table
  ;Density of Atmosphere ranges between 1-10 (lets do steps of 0.5 for now)
  ;http://www.engineeringtoolbox.com/standard-atmosphere-d_604.html
  



end
