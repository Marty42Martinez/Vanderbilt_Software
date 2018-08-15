function running_corvariance, x1, x2, windowsize=windowsize, normalize = normalize

if n_elements(windowsize) eq 0 then windowsize = 200.
w = windowsize
if n_params() le 1 then x2=x1
if n_elements(x1) ge w then begin
	nr = n_elements(x1)-w+1
	running = replicate(x1[0]*0, nr)
	for i=0,nr-1 do running[i] = cor_variance(x1[i:i+w-1],x2[i:i+w-1]) * w
	if keyword_set(normalize) then begin ; now must find minimum (s1*s2) using same window size
		s1s2 = fltarr(nr)
		for i=0,nr-1 do s1s2[i] = sigma(x1[i:i+w-1])*sigma(x2[i:i+w-1])
		running = running/min(s1s2^2)
	endif
endif else running = -1.

return, running

end