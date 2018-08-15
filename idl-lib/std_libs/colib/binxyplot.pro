PRO binxyplot, x, y, xb, yb, err, bins=bins, dx=dx, $
eplot = eplot, oplot=oplot, _extra = _extra, n=n, dlog=dlog, $
confidence=confidence


binxy, x, y, xb, yb, sdom = sdom, _extra=_extra, bins=bins, dx=dx, n=n, std = std, $
	confidence=confidence, climits=climits

if keyword_set(eplot) then begin
	if keyword_set(confidence) then err = [ [yb-climits[*,0]], [climits[*,1]-yb] ] else begin
		if (eplot eq 1) then err = std else err = sdom
	endelse
	if keyword_set(dlog) then plotdlog, xb, yb, err, _extra=_extra, oplot=oplot else $
		eoplot, xb, yb, err, _extra = _extra, oplot=oplot
endif else begin
	if keyword_set(oplot) then begin
		if keyword_set(dlog) then plotdlog, xb, yb, _extra=_extra, /oplot else oplot, xb, yb, _extra = _extra
	endif else begin
		if keyword_set(dlog) then plotdlog, xb, yb, _extra=_extra else plot, xb, yb, _extra = _extra
	endelse
endelse


END