PRO co_xyouts, x, y, s, relative=relative, _extra = _extra

; just like xyouts, but adds a new keyword relative, so
; you can use normalized coordinates that work with for
; multiple plots per plot window (ie, !p.multi NE [0,1,1]).

if keyword_set(relative) then begin
	xa = !x.crange[0]
	dx = !x.crange[1] - xa
	ya = !y.crange[0]
	dy = !y.crange[1] - ya
	xpos = x * dx + xa
	ypos = y * dy + ya
	if !x.type then xpos = 10^xpos
	if !y.type then ypos = 10^ypos
	xyouts, xpos, ypos, s, _extra = _extra
endif else begin
	xyouts, x, y, s, _extra = _extra
endelse

END
