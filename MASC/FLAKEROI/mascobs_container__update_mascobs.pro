PRO mascobs_container::update_mascobs

  
  ;new_mcont  = obj_new('mascobs_container')
  
  arr   = self -> toarray()
  n     = self.count()
  
  for i = 0,n-1 do begin
    m  = arr[i] -> update()
	self.remove, 0
	self.add, m
    ;stop
  endfor
  




end
