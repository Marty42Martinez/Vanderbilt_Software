function catrange, rangearr, x

; rangearr is output from segment.pro, (N,2) array of integers
; x is an array containing the 'N''s you want to extract, must contain at least two nunbers.

; output is of the form of the range function

outarr = range(rangearr[x(0),*])
for i = 1L, n_elements(x)-1 do outarr = [outarr,range(rangearr[x(i),*])]

return, outarr

end