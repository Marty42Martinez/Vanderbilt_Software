pro rotplot, data, _extra = _extra, yr=yr

wset, 0
nrots = n_elements(data[0,*]) ; number of rotations
nbins = n_elements(data[*,0])
if n_elements(yr) eq 0 then yr = getrange(data)
plot, data[*,0], _extra=_extra, yrange = yr
av = fltarr(nbins)
av = data[*,0]/nrots
for i=1, nrots-1 do begin
	oplot, data[*,i], _extra=_extra, col=i
	av = av + data[*,i]/ nrots
	wait, 0.010
endfor
window, 1
wset,1
plot, av, psym=5
end
