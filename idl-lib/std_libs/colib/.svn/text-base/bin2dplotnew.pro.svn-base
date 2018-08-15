PRO bin2dplotnew, x, y, z, xrange=xr, yrange=yr, $
		dx = dx, dy=dz, _extra = _extra, log=log, nn=nn ; plot keywords!


	if n_elements(dx) eq 0 then dx = (xr[1]-xr[0])/10.
	if n_elements(dy) eq 0 then dy = (yr[1]-yr[0])/10.

	bin2d, x, y, z, xr=xr, yr=yr, dx = dx, dy = dy, xb, yb, zb, n=n

	if n_elements(nn) eq 0 then nn = 10 ; # of levels/colors
	col = round(findgen(nn)/(nn-1.) * 254.)
	wg = where(n GT 0)
	if keyword_set(log) then zb_ = alog10(zb) else zb_ = zb
	levels = (max(zb_[wg]) - min(zb_[wg]))*findgen(nn+1)/(nn) + min(zb_[wg])
	layers = 0.5 * (levels[0:nn-1] + levels[1:*])
	if keyword_set(log) then c_label = num2str(10^levels, /trail) $
		else c_label = num2str(levels, /trail)


	plot, xr, yr, /nodata, ymarg=ymargin, _extra = _extra

	if ~keyword_set(no_colorbar) then ymargin = [6,2] else ymargin = !y.margin





END