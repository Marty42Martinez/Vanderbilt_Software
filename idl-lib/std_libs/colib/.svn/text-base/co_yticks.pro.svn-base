PRO co_yticks, tickv, minor, names = names, ticklen=ticklen, color=color, $
			   charsize=charsize, ytitle=ytitle
; routine to plot major and minor tickmarks & labels on an existing plot

; tickv : Locations of major y ticks.
; minor : Locations of minor y ticks. [optional]
; names : Names of major y ticks.

if n_elements(names) eq 0 then names = num2str(tickv, /trail)
if n_elements(ticklen) eq 0 then ticklen = !p.ticklen
len = (!x.window[1]-!x.window[0])*ticklen
width = 0.0
 ; 1) Put in MAJOR TICK MARKS & NAMES
 if n_elements(charsize) eq 0 then charsize = !p.charsize
 thick = 2.0
 xw = !d.x_ch_size / (!d.x_size+0.) * charsize
 yw = !d.y_ch_size / (!d.y_size+0.) * charsize
 for i = 0, n_elements(tickv)-1 do begin
 	plots, !x.window[0] + [0.0, len], !y.s[0] + !y.s[1]*tickv[i] + [0,0.], $
 		/normal, color=color, thick=thick
 	plots, !x.window[1] - [0.0, len], !y.s[0] + !y.s[1]*tickv[i] + [0,0.], $
 		/normal, color=color, thick=thick
	xyouts, !x.window[0] - 0.5*xw, !y.s[0] + !y.s[1]*tickv[i] - 0.40*yw, names[i], $
		/normal, color=color, align=1.0, charsize=charsize,width=this
	if this GT width then width = this
 endfor

 for i=0, n_elements(minor)-1 do begin
 	plots, !x.window[0] + [0.0, len/2.], !y.s[0] + !y.s[1]*minor[i] + [0,0.], $
 		/normal, color=color, thick=thick
 	plots, !x.window[1] - [0.0, len/2.], !y.s[0] + !y.s[1]*minor[i] + [0,0.], $
 		/normal, color=color, thick=thick
 endfor

 if keyword_set(ytitle) then xyouts, !x.window[0] - 0.75*xw-width, mean(!y.window), $
 							ytitle, align=0.5, /normal, color=color, orient=90.0


END