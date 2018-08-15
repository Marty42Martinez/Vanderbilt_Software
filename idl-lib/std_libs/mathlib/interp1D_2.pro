
function interp1D_2, x, y, xgrid, x2grid = x2grid

; x : 2D array, [npix, nz]
; y : 2D array, [npix, nz]
; xgrid : 1D array
; x2grid : 2D array of grid values

	nz = n_elements(x[0,*])
	npix = n_elements(x[*,0])
	ng = n_elements(xgrid)
	x2grid = fltarr(npix, ng)
	ygrid = fltarr(npix, ng)

	for i =0, npix-1 do begin
		ygrid[i,*] = interp1D(reform(x[i,*]),reform(y[i,*]), xgrid)
		x2grid[i,*] = xgrid
	endfor

	return, ygrid
end

