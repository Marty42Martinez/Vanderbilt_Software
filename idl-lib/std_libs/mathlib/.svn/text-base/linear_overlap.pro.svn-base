function linear_overlap, x0_left, x0_right, x1_left, x1_right, longitude=longitude

; computes the fractional linear area of line segment 1 overlapping with line segment 0.
; line segments are index numbers 0 and 1.
; each has a left (beginning) point and right (ending) point

f = x0_left * 0. + x0_right * 0. + x1_left * 0. + x1_right * 0.

lon = keyword_set(longitude)
; we need 5 differences in general
if lon then begin
	d0r_1l = longitude_difference(x0_right, x1_left)
	d1r_0l = longitude_difference(x1_right, x0_left)
endif else begin
	d0r_1l  = x0_right - x1_left
	d1r_0l  = x1_right - x0_left
endelse
; find places where there is some potential overlap
w = where(d0r_1l GT 0. AND d1r_0l GT 0., nw)

if nw GT 0 then begin
	if lon then begin
		d1r_1l = longitude_difference(x1_right, x1_left)
		d1r_0r = longitude_difference(x1_right, x0_right)
	endif else begin
		d1r_1l = x1_right - x1_left
		d1r_0r = x1_right - x0_right
	endelse
	wrin = where(d1r_0r[w] LT 0., nrin, comp=wrout, ncomp=nrout)
	if nrin GT 0 then begin
		wrin = w[wrin]
	    f[wrin] = ( d1r_0l / d1r_1l )[wrin] < 1.
	endif
	if nrout GT 0 then begin
		; ALL these have right side 1 OUTSIDE of line 0 boundaries
		; question - where is left side 1, in or out?
		wrout = w[wrout]
		if lon then d1l_0l = longitude_difference(x1_left, x0_left) else d1l_0l = x1_left - x0_left
		wlin = where( d1l_0l[wrout] GT 0., nlin, comp=wlout, ncomp=nlout )
		if nlin GT 0 then begin
			wlin = wrout[wlin]
			f[wlin] = (d0r_1l/d1r_1l)[wlin] < 1.
		endif
		if nlout GT 0 then begin
			; here, line 1 completely contains line 0
			if lon then d0r_0l = longitude_difference(x0_right, x0_left) else d0r_0l = x0_right - x0_left
			wlout = wrout[wlout]
			f[wlout] = (d0r_0l/d1r_1l)[wlout] < 1.
		endif
	endif
endif

return, f

end

