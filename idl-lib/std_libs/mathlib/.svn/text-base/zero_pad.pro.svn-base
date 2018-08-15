function zero_pad, x

N = long(n_elements(x))
i = ceil(alog(N)/alog(2))

if (2L^i eq N) then out=x else out = [x,0*x[0:2L^i-N-1]]
return, out
end