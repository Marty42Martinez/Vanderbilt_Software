function TV_CT, Xo, Yo, Nx, Ny, _extra=_extra

	if n_elements(Xo) eq 0 then Xo = 0
	if n_elements(Yo) eq 0 then Yo = 0
	if n_elements(Nx) eq 0 then Nx = !d.x_size - Xo
	if n_elements(Ny) eq 0 then Ny = !d.y_size - Yo
	im = tvrd(Xo, Yo, Nx, Ny, _extra = _extra, true=1)
	imc = reform(im[0,*,*] + im[1,*,*]*256L + im[2,*,*]*256L^2)
	tvlct, r, g, b, /get
	ct = r + g*256L + b*256L^2
	out = byte(imc)

	for c = 0, 255 do begin
		w = where(imc eq ct[c])
		if w[0] ne -1 then out[w] = c
	endfor

	return, out
END