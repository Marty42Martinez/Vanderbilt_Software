function get_bits, x, bits, separate=separate

 ;	array of BYTES, any dimensionality.
 ; bits = scalar or array of bits to process from the bytes.

	barray = 2ULL^bits
	if keyword_set(separate) then begin
		bb = long(barray)
		nb = n_elements(bits)
		out = bytarr(n_elements(x), nb)
		for i = 0, nb-1 do out[*,i] = (x AND bb[i]) / barray[i]
    endif else begin
	    bb = long(total(barray))
	    out = (x AND bb) / min(barray)
    endelse

	return, out

END
