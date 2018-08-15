pro plottwo, x1, y1, x2, y2, xwidth, _extra = _extra


	x0 = min(x1)
	xtotal = max(x1)-x0

	Ntot = xtotal/xwidth
	for i = 0, Ntot-1 do begin

		a = i*xwidth + x0
		b = a + xwidth
		w1 = where(x1 GE a and x1 LE b)
		w2 = where(x2 GE a and x2 LE b, n2)

	;	xx = findgen(b-a+1) + a
	;	date87, xx

		if n2 eq 0 then yr = minmax(y1[w1]) else yr = minmax([y1[w1],y2[w2]])
		plot, x1[w1], y1[w1], xr = [a,b], yr=yr, _extra = _extra
		if n2 GT 1 then oplot, x2[w2], y2[w2], col = 50, _extra=_extra

		pause
	endfor


END