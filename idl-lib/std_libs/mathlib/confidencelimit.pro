function confidencelimit, L, confidence

; returns the index of where the liklihood falls below the confidence limit desired.
; return -1 if there is no such place

; L : liklihood
; confidence : desired confidence limit

	c = 1 - confidence
	m = (where(L eq max(L)))[0]
	Lposs = L[m:*]
	w = where(Lposs lt c)
	if w[0] ne -1 then place = min(w)+m else place = -1
	return, place
end
