function dstddev, x, dim=dim, mean=mean

	; Works just like Stddev, but has the DIM keyword to specify dimension

	if keyword_set(dim) then begin
		sz = size(x)
		if sz[0] LT dim then begin
			print, 'Not enough dimensions in data array!'
			return, -1
		endif
		N = sz[dim]
		mean = total(x, dim) / N
		x2 = total(x*x, dim)
		return, sqrt( (x2 - N*mean*mean)/(N-1.) )
	endif else begin
		N = n_elements(x)
		mean = total(x) / N
		return, stddev(x)
	endelse

END
