FUNCTION meanarr, data, drifttime

N = n_elements(data)
M = long(N)/long(drifttime)

outarr = fltarr(M)

for i = 0L,M-1 do outarr(i) = mean(data[long(i)*drifttime:long(i+1)*drifttime-1])

return, outarr

END




