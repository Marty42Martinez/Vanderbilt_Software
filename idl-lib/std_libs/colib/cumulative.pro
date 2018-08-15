function cumulative, x

; returns the cumulative array corresponding to x

N = n_elements(x)

c = x
c[0] = 0
for i=1,N-1 do c[i] = total(x[0:i-1])

return, c

end

