FUNCTION LowerThan, data, highest, range_=range_

; Takes a data array, and a highest value, and returns an array of indices corresponing
; to entries in the array with a value strictly lower than the requested highest allowed value.
; returns -1 if no such elements exist

if n_elements(range_) eq 0 then begin
	N = n_elements(data)
	lower = lonarr(N)  ; created N-element array of 0's
	for i=0,N-1 do if (data(i) lt highest) then lower[i] = 1  ;if this element is good, mark it!
	lower = where(lower)  ; select out elements that got marked
endif else begin ; called with a special range, so must work relative to that
	N = n_elements(range_)
	lower = lonarr(N)-1
	for i=0, N-1 do if (data(range_[i]) lt highest) then lower[i] = range_[i]
	w = where(lower+1)
	if w[0] ne -1 then lower = lower(where(lower+1)) else lower=-1
endelse

return, lower

END
