FUNCTION fspeed_calc, m,p_dia,max_d=max_d

  
  a_dens     = 1.2 ;kg/m3
  d_visc     = 1.7E-5 ;kg/ms
  
  
  aspect_r   = 0.48 ; need to change this later (heymsfield paper)
  ;Aspect ratio < 1.0 (prolate)
  ;Aspect ratio > 1.0 (oblate)
  ;ax1        = (p_dia/2.)*aspect_r^(1./3)
  ax1        = p_dia/2.
  ax2        = ax1*aspect_r
  
;  if aspect_r lt 1.0 then begin
;    proj_ar  = !pi*ax1*ax2
;  endif else begin
;    proj_ar  = !pi*(ax1^2.0)
;  endelse
  max_D      = 2*max([ax1,ax2])
  ;stop
  del0       = 8.0
  c0         = 0.35
  ;area_r     = proj_ar/(!pi/4*max_d^2.)
  area_r     = 0.48
  ;!!!
  ;want to look at area ratio values for all particles 
  ;!!!
  Xstar      = (8*a_dens*m*9.8)/((d_visc^2.)*!pi*area_r^0.5)
  Re         = (del0^2./4.)*((1+(4*sqrt(Xstar))/(sqrt(c0)*del0^2.))^0.5 -1)^2.
  u          = d_visc*Re/(a_dens*max_d)
  ;u          = d_visc*Re/(a_dens*p_dia)
  ;u = fspeed_calc(p_dens,p_dia,a_dens)
 
  
  return, u
end

FUNCTION old_fspeed_calc,p_dens,p_dia
 
  g = 9.8 ;m/s2
  a_dens = 1.2
  d_visc = 1.7E-5 ; dynamic viscosity NEEDS TO BE UPDATED
  u_vals = (findgen(300)+1)*0.05
  
  if p_dens eq 1000. then begin
    dc  = 0.93997*p_dia + 39.4022*p_dia^2
	Re = a_dens*u_vals*(dc/(d_visc))
  endif else begin
    Re = a_dens*u_vals*(p_dia/(d_visc))
  endelse
  
  
  ;Re = a_dens*u_vals*(p_dia/(d_visc))

  
  ;Equation 7 from Mikhailov and Freire (2013)
  ;Consider using equation 8 (maybe it works better?)
  ;EQ 7;
  Cdrag = 777*((669806./875)+(114976./1155)*Re+(707./1380)*Re^2)/$
          (646*Re*((32869./952)+(924./643)*Re+(1./385718)*Re^2))
		  
  ;plot, Re, Cdrag,/xlog,/ylog
  ;stop
  ;EQ 8;
  ;Cdrag = 3808*((1617933./2030)+(178861./1063)*Re+(1219./1084)*Re^2)/$
  ;        (681*Re*((77531./422)+(13529./976)*Re+(1./71154)*Re^2))	  
  
  
  
  calc_u2 = (8/3.)*((p_dia/2.)*g*p_dens)/(a_dens*Cdrag)
  calc_u  = SQRT(calc_u2)
    
  cost =(calc_u-u_vals)
  
  corr_ind = where(cost^2.0 EQ MIN(cost^2.0))
  
  x0 = (corr_ind-1) > 0
  x1 = (corr_ind+1) < (N_ELEMENTS(u_vals)-1)
   
  
  u = INTERPOL(calc_u[x0:x1],cost[x0:x1],0.0)
  
  
  return, u
end
  
