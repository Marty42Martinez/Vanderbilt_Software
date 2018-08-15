function cor0, x1, x2, nbins=nbins

; x1 the first function
; x2 the second function (must be same length as the first)
; nbins will average the data in nbins bins.

N = n_elements(x1)
if n_params() lt 2 then x2 = x1

if keyword_set(nbins) then c = correlate( bindata(x1,nbins),bindata(x2,nbins)) $
							else c = correlate(x1, x2)
return, c
end