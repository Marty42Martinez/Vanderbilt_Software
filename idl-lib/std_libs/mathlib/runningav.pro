function runningav, x, wsize

; takes a vector x and a window size wsize, and forms the running average of them.

N = n_elements(x)
if wsize GT N then w=N else w=wsize
N2 = N-w+1
x2 = replicate(x[0], N2)

if w eq 1 then x2=x else for i=0,N2-1 do x2[i] = mean(x[i:i+w-1])

return, x2

end
