function dlogminor, lo, hi
; from lo to hi, find all the logarithmic minor ticks necessary
; lo and hi are  positive
	llo = floor(alog10(lo))
	lhi = ceil(alog10(hi))
	inner = alog10( findgen(8) + 2. )
	n = lhi - llo + 1 ; # of total ticks
	out = inner + llo ; first set
	for i = 1, n-1 do out = [out, inner + llo + i]
	out = 10^out
	w = where(out GE lo and out LE hi)
	return, out[w]

end

function dlog_coords, y, yrange, side=side
	; function to convert y into funky ylog plot coordinates

	y10 = alog10(abs(y)) ; get the absolute value of y

	if keyword_set(side) then begin
	    if side eq -1 then yr = yrange[[1,0]] else yr = yrange[2:3]
		y10 = alog10(side*y)
		aran = alog10(side*yr)
		y1 = side * (y10 - aran[0])/(aran[1]-aran[0])
		y1 = y1 * 2 - side
	endif else begin
		neg = where(y LT yrange[1], nneg)
		pos = where(y GT yrange[2], npos)
		mid = where(y GE yrange[1] AND y LE yrange[2], nmid)
		y1 = y10*0.
		if nneg GT 0 then begin
			yneg = y10[neg]
			aran = alog10(-1*yrange[[1,0]])
			y1[neg] = -1 * (yneg - aran[0])/(aran[1]-aran[0])
		endif
		if nmid GT 0 then y1[mid] = 0.
		if npos GT 0 then begin
			ypos = y10[pos]
			aran = alog10(yrange[2:3])
			y1[pos] = (ypos - aran[0])/(aran[1]-aran[0])
		endif
	endelse
	return, y1

end

pro dlog_yticks, yrange, tickn, names, minor, side=side

; at first, just put in major ticks at multiples of 10.
; no minor ticks.

small = 0.01
; upper side
if side GE 0 then begin
	aran = alog10(yrange[2:3])
	aran = [aran[0]-small, aran[1] + small]
	nu = floor(aran[1]) - ceil(aran[0]) + 1
	if nu GE 1 then begin
		tickv = 10^(ceil(aran[0]) + findgen(nu))
	endif
endif

; lower side
if side LE 0 then begin
	aran = alog10(-yrange[0:1])
	aran = [aran[0]+small, aran[1]-small]
	nd = floor(aran[0]) - ceil(aran[1])	+ 1
	if nd GE 1 then begin
		dtick = -1*10^( floor(aran[0]) - findgen(nd) )
		if n_elements(tickv) GT 0 then tickv = [dtick, tickv] else tickv = dtick
	endif
endif
; get actual tick locations on the plot
tickn = dlog_coords(tickv, yrange,side=side)
names = num2str(tickv, /trail)
w = where(tickn eq 0.0,n0) ; find center mark if it's here
if n0 eq 2 then begin
	names[w] = '!M+!X' + num2str(abs(tickv[w]), /trail)
	u = uniq(names)
	tickn = tickn[u]
	tickv = tickv[u]
	names = names[u]
endif

; put in minor ticks
 if n_elements(tickn) LE 5 then begin
   if side LE 0 then begin
   wneg = where(yrange LT 0, nneg)
   if nneg eq 2 then begin
     minor = dlogminor(min(-1*yrange[wneg]), max(-1*yrange[wneg]))
     minor = -1*reverse(minor)
   endif
   endif
   if side GE 0 then begin
   wpos = where(yrange GT 0, npos)
   if npos eq 2 then begin
     posminor = dlogminor(min(yrange[wpos]), max(yrange[wpos]))
   	 if n_elements(minor) eq 0 then minor = posminor else minor =[minor, posminor]
   endif
   endif
   if n_elements(minor) GT 0 then minor = dlog_coords(minor, yrange,side=side)
 endif

END


PRO plotdlog, x_, y_, err, yrange=yrange_, oplot=oplot,  charsize=charsize, $
		_extra=_extra, side=side, ytitle=ytitle, color=color
; YRANGE:  A 2 or 4 element vector.  Of the form:
;		[min, max] OR [negmax, negmin, posmin, posmax]

if n_params() eq 1 then begin
	y = x_
	ny = n_elements(y)
	x = findgen(ny)
endif else begin
	x = x_
	y = y_
endelse

if ~keyword_set(yrange_) then begin
	if ~keyword_set(err) then min_ = min(abs(y), max=max_) > 1e-6 $
		else min_ = min(abs([y-err, y+err]), max=max_) > 1e-6
	yrange = [-max_, -min_, min_, max_]
endif else begin
	if n_elements(yrange_) eq 2 then $
		yrange = [-yrange_[[1,0]], yrange_[[0,1]]] $
		else yrange = yrange_
endelse

; now, check the actual data set
if n_elements(side) eq 0 then begin
	side = 0
	if (where(y LT 0))[0] eq -1 then side = 1
	if (where(y GT 0))[0] eq -1 then side = -1 + side
endif


y1 = dlog_coords(y, yrange,side=side)
if keyword_set(err) then begin
	; Get lo and hi in plot coordinates
    lo1 = dlog_coords(y - err, yrange,side=side)
    hi1 = dlog_coords(y + err, yrange,side=side)
endif

if ~keyword_set(oplot) then begin
	dlog_yticks, yrange, tickn, ticknames, minor, side=side
	plot, x, x*0., yr=[-1,1], /nodata, $
		_extra=_extra, charsize=charsize, color=color, $
		yticks=1, yticknam=[' ',' ']
endif

oplot, x, y1, _extra=_extra, color=color
if keyword_set(err) then eplot2, x, lo1, hi1, color=color, _extra = _extra

; Add the yticks
if ~keyword_set(oplot) then begin
	co_yticks, tickn, minor, name=ticknames, charsize=charsize, ytitle=ytitle, $
		color=color
	if side eq 0 then oplot, !x.crange, [0.,0.], lines=2, color=color
endif




END