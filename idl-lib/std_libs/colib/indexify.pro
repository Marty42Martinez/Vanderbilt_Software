function indexify, a, sort=sort

; a is a sorted array
; will return the same thing as VALUE_LOCATE acting on a, with the
;	index array being the unique elements of a

	if keyword_set(sort) then a = a[sort(a)]

	diff = a[1:*] - a
	w = where(diff GT 0)
	if w[0] ne -1 then w = [w, n_elements(a)-1] else w = n_elements(a)-1

	return, w

END


