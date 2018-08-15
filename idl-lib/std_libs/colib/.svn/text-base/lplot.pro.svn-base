PRO lplot, x, y, _extra = _extra, oplot = oplot

	oplot = keyword_set(oplot)

	if n_elements(y) eq 0 then begin
		if oplot then oplot, x, _extra=_extra else plot, x, _extra = _extra, /ylog
		oplot, -x, lines = 2, _extra = _extra
	endif else begin
		if oplot then oplot, x, y, _extra=_extra else plot, x, y, /ylog, _extra = _extra
		oplot, x, -y, lines = 2, _extra = _extra
	endelse

END