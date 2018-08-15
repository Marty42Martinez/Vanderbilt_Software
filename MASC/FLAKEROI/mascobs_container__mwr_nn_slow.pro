FUNCTION mascobs_container::mwr_nn_slow,mwr_jday

  ;_EXTRA MUST contain an array of Julian dates from the mwr
  jday = self -> julday()
  n    = self.count()
  
  ind = dblarr(n)
  for i = 0,n-1 do begin
    hold = abs(mwr_jday - jday[i])
    ind[i]  = where(hold eq min(hold))
  
  endfor
  
  ;if n_elements(ind) gt 1 then ind = ind[0]

  ;stop
  return, ind

end
