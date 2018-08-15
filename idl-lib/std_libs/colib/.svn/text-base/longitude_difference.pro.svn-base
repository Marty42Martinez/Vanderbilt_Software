function longitude_difference, lon1, lon2, radians = radians


	if keyword_set(radians) then C = !dpi else C = 180.d

	; Returns the longitude difference

	if n_elements(lon2) eq 0 then diff = lon1 else diff = lon1 - lon2
	w = where( abs(diff) GT C )
	if w[0] ne -1 then begin
		dw = diff[w]
		sign = fix(dw gt 0.) - fix(dw lt 0.)
		diff[w] = dw - sign * 2 * C
	endif

	return, diff

end