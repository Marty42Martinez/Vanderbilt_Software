FUNCTION mascobs::mwr_nn,_EXTRA

  ;_EXTRA MUST contain an array of Julian dates from the mwr
  ;Important note!;
  ;mm = mascobs object
  ;desc = mm -> get('descriptors')
  ;desc will then be a hash array with just 'mwr_nn'
  ;ONLY WORKS AFTER mascobs_container__update_mascobs has been run!
  
  
  jday = self -> julday()
  hold = abs(_Extra.(0) - jday)
  ind  = where(hold eq min(hold))
  
  if n_elements(ind) gt 1 then ind = ind[0]

  ;stop
  return, ind

end
