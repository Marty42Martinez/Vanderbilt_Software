pro bin2dplot, z, x, y, zb, xb, yb, xrange = xr, yrange = yr, dx = dx, dy = dy, Nx=Nx, Ny=Ny, $
				_extra = _extra, c_colors = c_colors, Nlevels = Nlevels, levels=levels, $
				charsize = charsize, charthick = charthick, std=std, countmin=countmin, $
				contour = contour, xlog=xlog, ylog=ylog, boxplot=boxplot, histogram=histogram

; z must be 2-dimensional
; x, y must be 1-dimensional

	n1 = n_elements(z[*,0])
	n2 = n_elements(z[0,*])
	if n_elements(x) eq 0 then x_ = findgen(n1) else x_ = x
	if n_elements(y) eq 0 then y_ = findgen(n2) else y_ = y

	if n_elements(xr) eq 0 then xr_ = minmax(x) else xr_ = xr
	if n_elements(yr) eq 0 then yr_ = minmax(y) else yr_ = yr
	if keyword_set(xlog) then begin
		x_ = alog10(x_)
	 	xr_ = alog10(xr)
	endif
	if keyword_set(ylog) then begin
		y_ = alog10(y_)
		yr_ = alog10(yr)
	endif
	if n_elements(dx) eq 0 then begin
		if n_elements(nx) eq 0 then Nx = 10
		dx = float(xr_[1]-xr_[0]) / Nx
	endif
	if n_elements(dy) eq 0 then begin
		if n_elements(Ny) eq 0 then Ny = 10
		dy = float(yr_[1]-yr_[0]) / Ny
	endif

	bin2d, x_, y_, z, xr=xr_, yr=yr_, dx=dx, dy=dy, xb, yb, zb, n=n, std=sd

	if keyword_set(xlog) then begin
		xb = 10^xb
		xr_ = 10^xr_
	endif
	if keyword_set(ylog) then begin
		yb = 10^yb
		yr_ = 10^yr_
	endif

	if n_elements(countmin) eq 0 then countmin = 1
	w = where(n LT countmin)
	if w[0] ne -1 then zb[w] = 0.0

;	zb = zb > 0
	if keyword_set(std) then zplot = sd else zplot = zb
	if keyword_set(histogram) then zplot = n


if keyword_set(contours) then begin
	if keyword_set(levels) then Nlevels = n_elements(levels)
	if n_elements(Nlevels) eq 0 then Nlevels = 10
	if n_elements(c_colors) eq 0 then c_colors = fix(indgen(Nlevels) * (254. / (Nlevels-1)))
	;levels = (max(zplot)-min(zplot)+0.5)*findgen(nlevels) + min(z)
	contour, zplot, xb, yb, xr = xr, yr = yr, /follow, /fill, xlog=xlog, ylog=ylog, $
			_extra = _extra, c_colors = c_colors, Nlevels=Nlevels, levels=levels
;	print, c_colors
	contour, zplot, xb, yb, xr = xr, yr = yr,  /overplot, _extra = _extra, $
		c_labels = indgen(Nlevels), Nlevels=Nlevels, levels=levels, $
		c_charsize = charsize, c_charthick = charthick, xlog=xlog, ylog=ylog
endif else begin
	if keyword_set(boxplot) then begin
		plot2dbox, zplot, xb, yb, xr=xr_, yr=yr_, xlog=xlog, ylog=ylog, $
			mask = n GE countmin, _extra=_extra
	endif else begin
		plot2d, zplot, xb, yb, xr=xr,  yr=yr, _extra=_extra, xlog=xlog, ylog=ylog
	endelse
endelse

end