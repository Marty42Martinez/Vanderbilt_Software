function catrangeav, data, ccsky, sdom

; Takes as input the output from segment, and returns
; an array giving the mean value in each segment
; (optionally returns standard dev in each segment)

n = n_elements(ccsky[*,0])
av = fltarr(n)
sdom = fltarr(n)
for seg = 0, n-1 do begin
	segdata = data(range(ccsky[seg,*]))
	av[seg] = mean(segdata)
	ns = n_elements(segdata)
	sdom[seg] = stddev(segdata);/sqrt(ns)
endfor

return, av

END