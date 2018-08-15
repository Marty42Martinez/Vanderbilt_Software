pro hist2d,x,y, d, xcen, ycen, dx=dx, dy=dy, Nx = Nx, Ny = Ny, _extra=_extra, $
					xrange = xrange, yrange = yrange, xlog=xlog, ylog=ylog


	; x			:	The x data.
	; y 		:	The y data.  If y does not contain the same number of points as x,
	;					then the array with the larger number of points is truncated.
	; dx, dy 	: 	the PROPOSED bin size in x (y).  If the proposed bin size
	;					does not make a whole number of bins, it is modified to do so.
	;					If Nx (Ny) is also set, then dx (dy) is ignored.
	; Nx, Ny	:	The number of bins to make in x (y).  If this is set, then dx (dy)
	;					is ignored.
	; xcen, ycen:   These our OUTPUTS, and are calculated values giving the locations of the bins.

	; SET UP BIN SIZE STUFF
	Nbins_default = 20
	if keyword_set(xrange) then begin
		xmin = xrange[0]
		xmax = xrange[1]
	endif else xmin = min(x, max=xmax)
	if keyword_set(yrange) then begin
		ymin = yrange[0]
		ymax = yrange[1]
	endif else ymin = min(y, max=ymax)

	xlog = keyword_set(xlog)
	ylog = keyword_set(ylog)

	x_ = x & y_ = y

	if xlog then begin
		xmin = alog10(xmin)
		xmax = alog10(xmax)
		x_ = alog10(x)
	endif

	if ylog then begin
		ymin = alog10(ymin)
		ymax = alog10(ymax)
		y_ = alog10(y_)
	endif

	xspan = float(xmax - xmin)
	yspan = float(ymax - ymin)
	if n_elements(dx) eq 0 then dx = xspan / Nbins_default
	if n_elements(dy) eq 0 then dy = yspan / Nbins_default
	if n_elements(Nx) eq 0 then Nx = round(xspan / dx)
	if n_elements(Ny) eq 0 then Ny = round(yspan / dy)
	dx = xspan / Nx
	dy = yspan / Ny
	xcen = (findgen(nx) + 0.5) * dx + xmin
	ycen = (findgen(ny) + 0.5) * dy + ymin

	c = 1.000001
	; CREATE 2D histogram
	d=hist_2d(x_+0.,y_+0.,bin1=dx*c, bin2=dy*c, min1=xmin, min2=ymin, max1=xmax, max2=ymax)

	; I think d is a 2D array of size Nx, Ny.

	; now I need to call a routine that makes a 2D color plot with
	;	square pixels and an optional color bar.

	if xlog then xcen = 10.^xcen
	if ylog then ycen = 10.^ycen

	plot2d, d, xcen, ycen, xlog=xlog, ylog=ylog, _extra = _extra,  $
		xrange=xrange, yrange=yrange, mask = (d GT 0)
	print, 'Range of Histogram  = ', minmax(d)

end