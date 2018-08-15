pro co_contour, z, x, y, _extra = _extra, oplot=oplot, integrate=integrate, $
				peak=peak, linestyle=linestyle, range=range, zero=zero, $
				nolabels=nolabels, simpson = simpson

s1 = textoidl('1\sigma')
s2 = textoidl('2\sigma')
s3 = textoidl('3\sigma')

if n_elements(x) eq 0 then x = findgen(n_elements(z[*,0]))
if n_elements(y) eq 0 then y = findgen(n_elements(z[0,*]))

if keyword_set(simpson) then nosimp = 0 else nosimp = 1
levels = [0.00274,0.04573,0.31663]
;levels = reverse([0.4348, 0.16208,1/11.8])

if keyword_set(integrate) then begin
	nl = n_elements(levels)
	if not(nosimp) then tot = simpson2D(z,x,y,where2D(z GT (min(z)-1)))
	tot = total(z)
	nheights = 1000
	heights = findgen(nheights)/nheights * max(z)
	totals = fltarr(nheights)
	if nosimp then $
		for i=0,nheights-1 do totals[i] = total(z[where(z GE heights[i])])/tot $
	else $
		for i=0,nheights-1 do totals[i] = simpson2D(z,x,y,where2D(z GE heights[i]))/tot
	for i=0,nl-1 do begin
		w = (where(totals LE (1-levels[i])))[0]
		nw = n_elements(w)
		w = w[nw-1]
		if w[0] eq -1 then levels[i] = 0 else $
		levels[i] = heights[w]
	endfor
endif
if n_elements(linestyle) eq 0 then linestyle = 0
if keyword_set(oplot) then overplot = 1 else overplot = 0
if keyword_set(range) then begin
	xr = range
	yr = range
endif
if not keyword_set(nolabels) then begin
contour, levels=levels, z,x,y, $
	xtit = textoidl('E [\muK]'), ytit = textoidl('B [\muK]'), xr=xr,yr=yr,$
	/follow, c_labels = [1,1,1], c_annot = [s3,s2,s1],$
	_extra = _extra, overplot=overplot, c_linestyle = linestyle
endif else begin
	contour, levels=levels, z,x,y, $
	xtit = textoidl('E [\muK]'), ytit = textoidl('B [\muK]'), xr=xr,yr=yr,$
	/follow, c_labels = [0,0,0], $
	_extra = _extra, overplot=overplot, c_linestyle = linestyle
endelse
if keyword_set(peak) then begin
	peak = reform(where2D(z eq max(z)))
	xyouts, x(peak[0]),y(peak[1]), '*', _extra=_extra
endif
if keyword_set(zero) then begin
	if overplot then ym = 0.7 else ym = 0.8
	xyouts, 0.7*!x.crange[1],ym*!y.crange[1], num2str(z[0,0], 3), _Extra=_extra
endif

end