pro eoplot, x_, data_, errors_, oplot=oplot, color=color, $
					_extra = _extra, pad=pad, shade=shade, thick=thick

	oldyrange = !y.range

	if n_params() eq 2 then begin ; no x specified
		nx = n_elements(x_)
		x = findgen(nx)
		data = x_
		errors = data_
	endif else begin
		nx = n_elements(data_)
		x = x_
		data = data_
	endelse
    if n_elements(errors_) eq nx then errors = [ [errors_], [errors_] ] else errors=errors_

	mini = (where(data eq min(data)))[0]
	maxi = (where(data eq max(data)))[0]
	!y.range = [data[mini] - errors[mini,0], data[maxi]+errors[maxi,1]]
	if keyword_set(pad) then begin
		yspan = !y.range[1] - !y.range[0]
		!y.range[0] = !y.range[0] - (pad-1)*yspan
		!y.range[1] = !y.range[1] + (pad-1)*yspan
	endif
	if keyword_set(oplot) then oplot, x, data, thick=thick, color=color, _extra = _extra $
		else plot, x, data, _extra = _extra, thick=thick, color=color

	if ~keyword_set(shade) then begin
		; plot error bars
		plot_errors, x, data, errors, color=color, thick=thick, width=width

	endif else begin
		; plot shaded region
		for i = 0, nx-2 do begin
			x0 = x[i] - (3e-3)*(x[i+1]-x[i])
			x1 = x[i+1] + (3e-3) * (x[i+1] - x[i])
			polyfill, [x0,x1,x1,x0], [(data-errors[*,0])[[i,i+1]],(data+errors[*,1])[[i+1,i]]], col=color, _extra=_extra
		endfor
	endelse


	!y.range = oldyrange

end