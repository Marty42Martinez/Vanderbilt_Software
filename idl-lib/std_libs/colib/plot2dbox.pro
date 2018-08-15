pro plot2dbox, zb, xb, yb, xrange=xr, yrange=yr, _extra = _extra, nlevels=nn,$
	xlog=xlog, ylog=ylog, log=log, min=min, max=max, mask=mask

	; xb and yb are 1d arrays with constant spacing, with Nx and Ny elements.
	; zb is a 2d (Nx,Ny) array.

	if n_elements(xr) eq 0 then xr = minmax(xb)
	if n_elements(yr) eq 0 then yr = minmax(yb)
	xr_ = xr
	yr_ = yr
	xlog = keyword_set(xlog)
	ylog = keyword_set(ylog)
	if xlog then xr_ = alog10(xr_)
	if ylog then yr_ = alog10(yr_)
	if xlog then xb_ = alog10(xb) else xb_ = xb
	if ylog then yb_ = alog10(yb) else yb_ = yb
	; Now I must create the boundary arrays
	xd = (xb_[1:*] + xb_) * 0.5
	yd = (yb_[1:*] + yb_) * 0.5
	xd = [xr_[0], xd, xr_[1]]
	yd = [yr_[0], yd, yr_[1]]
	if xlog then xd = 10^xd
	if ylog then yd = 10^yd

	if n_elements(nn) eq 0 then nn = 10 ; # of levels/colors
	col = round(findgen(nn)/(nn-1.) * 254.)
	if n_elements(mask) GT 0 then wg = where(mask) else wg = lindgen(n_elements(zb))
	if n_elements(min) eq 0 then min = min(zb[wg])
	if n_elements(max) eq 0 then max = max(zb[wg])
	print, 'Min, Max = ', min, max
	zb_ = zb
	if keyword_set(log) then begin
		zb_[wg] = alog10(zb[wg])
 		min = alog10(min > 1e-20)
		max = alog10(max > 1e-20)
	endif else zb_ = zb
	levels = (max-min)*findgen(nn+1)/(nn) + min
	layers = 0.5 * (levels[0:nn-1] + levels[1:*])

	sz = size(zb)
	s1 = sz[1]
	s2 = sz[2]
	plot, xr, yr, /nodata, xlog=xlog, ylog=ylog, _extra = _extra



	for p=0,n_elements(wg)-1 do begin
		i = wg[p] mod s1
		j = wg[p] / s1
		x1 = xd[i]
		x2 = xd[i+1]
		y1 = yd[j]
		y2 = yd[j+1]
		dummy = min(abs(layers - zb_[wg[p]]), l)
		if (x1 LE xr[1] AND x2 GE xr[0] AND y1 LE yr[1] AND y2 GE yr[0]) then $
			polyfill, [x1,x2,x2,x1],[y1,y1,y2,y2], color = col[l]
	;	delay, 0.05
	endfor

END