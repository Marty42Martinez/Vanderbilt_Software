function rms, y, dim_, reform=reform

; finds the root-mean-square of an array
; dim : optional, specify the dimensions over which to take the rms
; reform: optional, reform the array before taking the rms (only does something when dim set)

if n_elements(dim_) eq 0 then begin
	rms_ = sqrt(total(y^2)/n_elements(y))
endif else begin
	dim = dim_
	s = sort(dim)
	dim = dim[s] ; sort the dimensions
	nd = n_elements(dim)
	rms_ = y^2
	if keyword_set(reform) then rms_ = reform(rms_)
	for i = nd-1, 0, -1 do rms_ = total(rms_, dim[i]) / (size(rms_))[dim[i]]
	rms_ = sqrt(rms_)
endelse

return, rms_

end