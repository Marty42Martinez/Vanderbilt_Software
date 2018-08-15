pro histplot, channel, binsz, oplot = oplot, $
	text=text, _extra=_extra, res=res, cs = cs, fit=fit

on_error,2

hist = histogram(channel, binsize = binsz)
;print, hist
histox = findgen(N_ELEMENTS(hist))*binsz + min(channel) + 0.5*binsz

yr1 = getrange(hist)
yr = yr1


if keyword_set(fit) then begin
	gfit = gaussfit(histox,hist,gparam,n=3)
	residuals = hist-gfit
if keyword_set(res) then begin
	yr2 = getrange(residuals)
	yr = [min([yr1(0),yr2(0)]),max([yr1(1),yr2(1)])]
endif
endif
if keyword_set(oplot) then begin
	oplot, histox, hist, psym=10, _extra= _extra
	hymax = max(hist)
	hxmax = max(histox)
		if N_elements(hist) gt 9 and keyword_set(fit) $
			then oplot, histox,gfit, _extra=_extra
	if keyword_set(text) then begin
	   xyouts, 0.75,0.55,textoidl("\sigma=")+num2str(gparam[2],3), /normal, _extra =_extra
	   xyouts, 0.75,0.6, textoidl('\mu=')+num2str(gparam[1],3), /normal, _extra = _extra
	endif
endif else begin
	plot, histox, hist,psym=10, yrange=yr, _extra=_extra
	hymax = max(hist)
	hxmax = max(histox)
	if (N_elements(hist) gt 9) and keyword_set(fit) then $
		oplot, histox, gfit, _extra = _extra
	if keyword_set(text) then begin
	   xyouts, 0.75,0.65,textoidl("\sigma=")+num2str(gparam[2],3), /normal
	   xyouts, 0.75,0.7, textoidl('\mu=')+num2str(gparam[1],3), /normal
	endif
endelse
if (keyword_set(res) AND keyword_set(fit)) then oplot, histox, residuals, col=55

if keyword_set(cs) then begin
	rcseasy = total(((channel-mean(channel))/gparam[2])^2)/(n_elements(channel)-2.)
	cs = total((residuals/sqrt(gfit))^2);/(n_elements(gfit)-2.)
	rcs = cs/(n_elements(hist)-2.)
	xyouts, 0.2,0.85,'RCS='+strcompress(rcs), /normal
	xyouts, 0.2,0.9,'Easy rcs='+strcompress(rcseasy), /normal
	xyouts, 0.2,0.8, strcompress(n_elements(hist))+' bins', /normal
	if N_elements(hist) gt 9 then begin
	for i=0,n_elements(hist)-1 do begin
	  pcs = round(residuals(i)^2/gfit(i)/cs*100.)
	  xyouts,histox(i),hist[i] + 0.02*(yr(1)-yr(0)),strcompress(pcs), align=0.5
	endfor
	endif else print, 'not enough elements in histogram to do gaussfit'
endif
;print, hxmax/2.,hymax/2.
;print, gparam

end
