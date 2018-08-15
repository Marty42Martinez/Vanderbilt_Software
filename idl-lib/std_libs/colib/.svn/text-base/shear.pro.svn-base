function shear, data, x, pad=pad, sheardata=sheardata
; data is the data array
; x is a 2-element array containing starting and ending index of chunk to be sheared

; gets rid of crappy stuff at beginning and end

midrange = range(x[0]+1/3.*(x[1]-x[0]),x[0]+2/3.*(x[1]-x[0]))
low = min(data(midrange))
high = max(data(midrange))

if n_elements(pad) eq 0 then pad=0.1
pad = pad * (high-low)
low = low - pad
high = high + pad

; find beginning element
a = x(0)-1
repeat begin
a = a + 1
endrep until inrange(data(a),[low,high])

; find ending element
b = x(1)+1
repeat begin
b = b-1
endrep until inrange(data(b),[low,high])

sheardata = data(range(a,b))

return, [a,b]

END