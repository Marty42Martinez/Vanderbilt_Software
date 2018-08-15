function comparemaps, y1, y2, cov1, cov2, delta=delta, noplot=noplot, verbose=verbose

; function does a simple chi-squared analysis on 2 maps
; to see if their difference is consistent with 0

y = y1 - y2
cov = cov1 + cov2

if n_elements(delta) eq 0 then begin
; i have to come up with a delta.  just do something shoddy
	rms_ = rms(y)
	delta = findgen(50)/50. * 3 * rms_
endif

like = flatL(y, cov, delta, verbose = verbose)
if not keyword_set(noplot) then $
plot, delta, like, yr = [0,1], tit='Likelihood Plot of Difference Map RMS',$
	xtit = 'RMS Value', ytit = 'Relative Likelihood'

return, like

end
