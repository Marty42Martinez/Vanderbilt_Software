function logrange, start, stop, n

; start : the lowest value
; stop  : the highest value
;  n : the number of elements

	log0 = alog(start)
	log1 = alog(stop )
	log_range = findgen(n)/(n-1.)*(log1-log0) + log0

	out = exp( log_range )

	return, out

end

