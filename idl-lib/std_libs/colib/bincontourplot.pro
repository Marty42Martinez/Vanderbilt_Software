PRO bincontourplot, z, x, y, xrange=xr, yrange=yr, count = N, ct=ct, $
		dx = dx, dy=dz, _extra = _extra, log=log, nn=nn, zb, xb, yb, sd, $
		std=std, levels=levels, c_label=c_label, c_colors = c_colors; plot keywords!

	tvlct, rold, gold, bold, /get ; get current color table
	if n_elements(ct) eq 0 then ct = 25

	if n_elements(xr) eq 0 then xr = minmax(x)
	if n_elements(yr) eq 0 then yr = minmax(y)
	if n_elements(dx) eq 0 then dx = (xr[1]-xr[0])/10.
	if n_elements(dy) eq 0 then dy = (yr[1]-yr[0])/10.

	bin2d, x, y, z, xr=xr, yr=yr, dx = dx, dy = dy, xb, yb, zb, std=sd, n=n
	if keyword_set(std) then zb = sd

	if n_elements(nn) eq 0 then nn = 10 ; # of levels/colors
	if n_elements(c_colors) eq 0 then col = round(findgen(nn)/(nn-1.) * 254.) else col = c_colors
	wg = where(n GT 0, comp=wb, ncomp=nb)
	zb_ = zb
	if keyword_set(log) then zb_[wg] = alog10(zb[wg])
	s1 = (size(zb))[1] ; size of 1st dim
	s2 = (size(zb))[2]
	if nb GT 0 then begin
		; Must fill in missing values
		ia = lindgen(s1) # (lonarr(s2) + 1)
		ja = (lonarr(s1) + 1) # lindgen(s2)
		ia = ia[wg]
		ja = ja[wg]
		dist = lonarr(s1, s2) + 100000L
		for b_ = 0, nb-1 do begin
			b = wb[b_]
			i = b mod s1
			j = b / s1
			dist[wg] = (ia-i)^2 + (ja-j)^2
			wcl = where(dist eq min(dist), ncl) ; closest points
			zb_[b] = total(zb_(wcl))/ncl
		endfor
	endif


	; now let's rebin the z array to be the POINTS, not the BINS.
	if n_elements(levels) eq 0 then begin
		levels = (findgen(nn-1) + 0.5)/(nn-1.) * (max(zb_) - min(zb_)) + min(zb_)
		levels = [min(zb_), levels]
	endif
	if n_elements(c_label) eq 0 then begin
		if keyword_set(log) then c_label = num2str(10^levels, /trail) $
		else c_label = num2str(levels, /trail)
	endif

	zb_ = congrid(zb_, s1+1, s2+1, /interp)
	xb_ = (xr[1]-xr[0]) * findgen(s1+1)/s1 + xr[0]
	yb_ = (yr[1]-yr[0]) * findgen(s2+1)/s2 + yr[0]




	plot, xr, yr, /nodata, _extra = _extra
	loadct, ct

	contour, zb_, xb_, yb_, xr = xr, yr = yr, levels = levels, $
		c_label = -1, /follow, /fill, c_col =col, /overplot, _extra = _extra

	tvlct, rold, gold, bold

	contour, zb_, xb_, yb_, xr = xr, yr = yr, levels = levels, $
		c_label = indgen(nn), c_ann = c_label, /overplot, _extra=_extra



END