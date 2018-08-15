FUNCTION HigherThan, data, lowest, range_=range_

; Takes a data array, and a lowest value, and returns an array of indices correspdoning
; to entries in the array with a value strictly higher than the requested lowest allowed value.
if n_elements(range_) eq 0 then begin
	N = n_elements(data)
	higher = lonarr(N)  ; created N-element array of 0's
	for i=0,N-1 do if (data(i) gt lowest) then higher[i] = 1  ;if this element is good, mark it!
	higher = where(higher)  ; select out elements that got marked
endif else begin ; called with a special range, so must work relative to that
	N = n_elements(range_)
	higher = lonarr(N)-1
	for i=0, N-1 do if (data(range_[i]) gt lowest) then higher[i] = range_[i]
	higher = higher(where(higher+1))
endelse
	return, higher
END
