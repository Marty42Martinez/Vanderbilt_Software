pro vmap, x,y, oplot=oplot, range=range,_extra=_extra, pause=pause

if n_elements(range) eq 0 then range = [-1000,1000]
xrange=range
yrange=range
a = ''

n = n_elements(x)

zeros = fltarr(n)

if n_elements(oplot) eq 0 then plot, [0],[0], psym = 3, xr=xrange,yr=yrange,_extra = _extra
if keyword_set(pause) then begin
	for i=0, n-1 do begin
		arrow, zeros[i],zeros[i],x[i],y[i], /data, _extra=_extra
		read, a
	endfor
endif else arrow, zeros,zeros,x,y,/data,_extra=_extra
end