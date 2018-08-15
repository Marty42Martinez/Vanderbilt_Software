FUNCTION elt, set1, set2, index = index

; Returns an array of the same length as set1
; for each elt of set1, returns a 1 if that element appears at least once in set2,
; 	and a 0 otherwise


	n1 = n_elements(set1)
	n2 = n_elements(set2)

	if n2 GT 32727 then valid = lonarr(n1) else begin
		if n2 GT 255 OR keyword_set(index) then valid = intarr(n1) else valid=bytarr(n1)
	endelse

	if n1 LT n2 then begin
		for i=0L,n1-1 do valid[i] = where(set1[i] eq set2)
		if keyword_set(index) eq 0 then valid = byte(valid +1) < 1b
	endif else begin
		if keyword_set(index) then begin
			valid[*] = -1
			for i =0L, n2-1 do begin
				w = where(set1 eq set2[i], count)
				if count GT 0 then valid[w] = i
			endfor
		endif else begin
			for i=0L, n2-1 do valid = valid + (set1 eq set2[i])
			if n2 GT 1 then valid = byte( valid < 1 )
		endelse
	endelse



	if n_elements(valid) eq 1 then valid = valid[0]

	return, valid

END