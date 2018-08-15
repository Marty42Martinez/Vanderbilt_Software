pro delayplot, x1_, y1, x2=x2,y2=y2,x3=x3,y3=y3, time_=time_, $
			xrange1=xrange1, yrange1=yrange1, $
			xrange2=xrange2, yrange2=yrange2, $
			xrange3=xrange3, yrange3=yrange3, psym=psym, verbose=verbose,$
			_extra=_extra


timer = keyword_set(verbose)
if timer then starttime = systime(1)

if n_elements(time_) eq 0 then time_ = 10.0
delaytime = time_/n_elements(x1_) ; set delay time in seconds

if timer then print, delaytime

; figure out how many plots and such
nplots = 1
if n_elements(y2) ne 0 then begin
	nplots=nplots+1
	if n_elements(x2) eq 0 then x2 = lindgen(n_elements(y2))
endif
if n_elements(y3) ne 0 then begin
	nplots=nplots+1
	if n_elements(x3) eq 0 then x3 = lindgen(n_elements(y3))
endif
if n_params() eq 1 then begin
	y1 = x1_
	x1 = lindgen(n_elements(x1_))
endif else x1 = x1_

if n_elements(psym) eq 0 then psym = intarr(nplots)
if n_elements(psym) LT nplots then psym = [psym, intarr(nplots-n_elements(psym))+psym[0]]

; create x and y arrays (might take fair amount of memory!)
	x = x1
	y = y1
	for i=1,nplots-1 do begin
		ps = strcompress(i+1,/remove)
		err = execute('x_ = x' + ps)
		err = execute('y_ = y' + ps)
		x = [[x],[x_]]
		y = [[y],[y_]]
	endfor
; get windows straight
device, window_state = w
gw = where(w)
bw = where(w eq 0)
if n_elements(gw) LT nplots then begin
	; i need more windows
	need = nplots - n_elements(gw) ; # of windows I need
	ew = bw[0:need-1]
	; open the new windows
	for i = 0,n_elements(ew)-1 do window, ew[i]
	w = [gw,ew]
	w = w[sort(w)] ; the windows I shall use (sorted)
endif else begin ; need no extra windows
	w = gw
endelse

; initialize plots
xcrap = replicate(!x,nplots)
ycrap = replicate(!y,nplots)
for i = 0,nplots-1 do begin
	wset, w[i]
	ps = strcompress(i+1,/remove)
	err = execute('plot, x[*,i], y[*,i], /nodata, xrange=xrange'+ps+',yrange=yrange'+ps)
	xcrap[i] = !x
	ycrap[i] = !y
endfor

; cycle through the points (assume all plots have same # of points!)
for p = 0L,n_elements(x1) - 2 do begin
	for i = 0,nplots-1 do begin
		wset,w[i] ; set the current plot window
		!x = xcrap[i]
		!y = ycrap[i]
		plots, [x[p,i],x[p+1,i]], [y[p,i],y[p+1,i]], psym=psym[i],_extra=_extra
	endfor
	delay, delaytime
endfor

if timer then begin
	stoptime = systime(1)
	print, 'Elapsed Time = ', stoptime-starttime, ' seconds.'
endif

end




