function bkfilter, tod, hf = hf

; hf : set this keyword if tod is in hour-file format

restore, 'c:\polar\work\april\bkfilter1.var'

out = tod * 0.

if keyword_set(hf) then begin
	nhf = n_elements(tod[0,*])
	Q = n_elements(tod[*,0])
	for hf = 0, nhf-1 do begin
		print, hf
	 	dat = tod[*,hf]
		for i=0,Q-1 do out[i,hf] = total(shift(bs_ir_n,Q/2+i)*dat)
	;	filt = bs_ir_n[1:8998]
	;	out[*,hf] = convol(dat, filt, /edge_truncate)
	endfor
endif else begin
	out = convol(tod, bs_ir_n, /edge_truncate)
endelse

return, out

end