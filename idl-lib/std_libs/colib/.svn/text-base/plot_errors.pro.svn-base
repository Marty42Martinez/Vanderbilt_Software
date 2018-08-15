PRO plot_errors, x, y, errors_, width=width, _extra=_extra

;	_extra : any keywords accepted by OPLOT.

; PLOTS INDIVIDUAL ERROR BARS

    n = n_elements(x)
    if n_elements(errors_) eq n then errors = [ [errors_], [errors_] ] else errors=errors_
	xr = !x.crange
	span = xr[1] - xr[0]
	if n_elements(width) eq 0 then width = 0.01

	if !x.type then logx = alog10(x)

	z0 = [0., 0.]
	z1 = [-1., 1.]
    for i = 0, n-1 do begin
    	; plot the vertical line
    	oplot, x[i]+z0, y[i] + z1*reform(errors[i,*]), _extra = _extra

		; plot the horizontal bars (must be careful if logarithmic!)
		if !x.type eq 0 then begin
			; x is NOT logarithmic
			xi =  x[i] + z1*span*width
			oplot,xi, y[i] - errors[i,0] + z0, _extra = _extra
			oplot, xi, y[i] + errors[i,1] + z0, _extra = _extra
		endif else begin
			; x is logarithmic
			xi = 10.^(logx[i] + z1*width*span)
			oplot, xi , y[i] - errors[i,0]+z0, _extra = _extra
			oplot, xi , y[i] + errors[i,1]+z0, _extra = _extra
		endelse
	endfor

END