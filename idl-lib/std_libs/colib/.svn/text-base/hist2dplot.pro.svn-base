pro hist2dplot,x,y, dx=dx, dy=dy, Nx = Nx, Ny = Ny, _extra = _extra, $
					xrange = xrange, yrange = yrange, mini=mini


	; x			:	The x data.
	; y 		:	The y data.  If y does not contain the same number of points as x,
	;					then the array with the larger number of points is truncated.
	; dx, dy 	: 	the PROPOSED bin size in x (y).  If the proposed bin size
	;					does not make a whole number of bins, it is modified to do so.
	;					If Nx (Ny) is also set, then dx (dy) is ignored.
	; Nx, Ny	:	The number of bins to make in x (y).  If this is set, then dx (dy)
	;					is ignored.

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
	xspan = float(xmax - xmin)
	yspan = float(ymax - ymin)
	if n_elements(dx) eq 0 then dx = xspan / Nbins_default
	if n_elements(dy) eq 0 then dy = yspan / Nbins_default
	if n_elements(Nx) eq 0 then Nx = round(xspan / dx)
	if n_elements(Ny) eq 0 then Ny = round(yspan / dy)
	dx = xspan / Nx
	dy = yspan / Ny

	c = 1.000001
	; CREATE 2D histogram
	d=hist_2d(x+0.,y+0.,bin1=dx*c, bin2=dy*c, min1=xmin, min2=ymin, max1=xmax, max2=ymax)

    ; CREATE 2D x and y arrays
	xx = (fltarr(Ny)+1.0) ## ((findgen(Nx)+0.5)*dx + xmin )
	yy = (fltarr(Nx)+1.0) #  ((findgen(Ny)+0.5)*dy + ymin )

	; create plotting limits
	limit=  fltarr(4)
	if keyword_set(xrange) then limit[2:3] = xrange $
			else limit[2:3] = [xmin,xmax]
	if keyword_set(yrange) then limit[0:1] = yrange $
			else limit[0:1] = [ymin, ymax]

	if n_elements(mini) eq 0 then mini = 1


	wis_image, d, yy, xx, bartitle = 'No. Pts in Bin', $
			/no_cont, void_index = where(d LT mini), missing = 255, $
			_extra = _extra, mini = mini, limit=limit

end