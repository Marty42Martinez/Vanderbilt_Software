FUNCTION conductivity_diffusion, temp
; give Temp in [K]
;Tabulated values taken from Rogers and Yao page 103
;created 12/17/2015


  T_arr    = [-40,-30,-20,-10,0] + 273.16
  D_arr    = [1.62,1.76,1.91,2.06,2.21]*1e-5 ;Coeff of Diffusion [m^2/s]
  K_arr    = [2.07,2.16,2.24,2.32,2.40]*1e-2 ;Coeff of Thermal Conductivity [J/msK]
  
;  rndT     = 10*round(0.5*(round(temp)/5))
;  ind      = where(T_arr eq rndT)
  
  d = INTERPOL(d_arr,t_arr,temp>MIN(t_arr)<MAX(t_arr))
  k = INTERPOL(k_arr,t_arr,temp>MIN(t_arr)<MAX(t_arr))
  
  out = {D:d,k:k}
  

  return, out

end
