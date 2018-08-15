function smoothgauss, y, fwhm

; Performs 1D gaussian smoothing
; currently is VERY slow.
; y must be evenly spaced in time
; fwhm is in units of samples.

	ny = n_elements(y)
	x = findgen(ny)
	y_ = y
	sig = fwhm * 0.424661
	for i = 0L,ny -1 do begin
		expon = (i - x)^2 /(2*sig^2)
		filt = y * 0.
		wf = where(expon LT 20.)
		filt[wf] = exp(-expon[wf])
		y_[i] = total(y * filt) / total(filt)
	endfor

	return, y_

END