function randomn_cut, n, limits

; returns a gaussian with zero mean and unit stddev, but always
; tosses values not in range


out = randomn(seed, n)

if n_elements(limits) eq 2 then begin
	wbad = where(out LT limits[0] or out GT limits[1], nbad)
	while (nbad GT 0) do begin
		out[wbad] = randomn(seed, nbad)
		wbad2 = where(out[wbad] LT limits[0] or out[wbad] GT limits[1], nbad)
		if nbad GT 0 then wbad = wbad[wbad2]
	endwhile
endif

return, out

END