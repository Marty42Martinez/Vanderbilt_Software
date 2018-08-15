FUNCTION noises, tod, _extra=_extra

if n_elements(nbins) eq 0 then nbins=3
if n_elements(frange) eq 0 then frange = [2.,3.]

N = n_elements(tod[0,*])
s = fltarr(N)
for i = 0, N-1 do s[i] = noise(tod[*,i], _extra=_extra)

return, s

END