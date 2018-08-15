FUNCTION meanvar, data, drifttime, calcoeff

N = n_elements(data)
M = long(N)/long(drifttime)

outarr = fltarr(M-1)

newmean = mean(data[0:drifttime-1])
for i = 1,M-1 do begin
	oldmean=newmean
	newmean = mean(data[long(i)*drifttime:long(i+1)*drifttime-1])
	outarr(i-1) = (newmean-oldmean) * calcoeff
endfor

return, outarr

END




