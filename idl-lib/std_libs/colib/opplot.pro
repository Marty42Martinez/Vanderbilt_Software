pro opplot, x, y, psym, _extra = _extra

if n_params() eq 1 then begin
; only y is set here.
	psym = 4 ; default psym
	oplot, x, psym = psym, _extra = _extra
	oplot, x, _extra = _extra
	GOTO, DONE
endif
if n_params() eq 2 then begin
 ; Either
 ; (i)   x and y are set OR
 ; (ii)  y and psym are set (must determine

	if n_elements(y) eq 1 then begin ; case (ii)
		oplot, x, psym=y, _extra=_extra
		oplot, x, _extra = _extra
	endif else begin 				; case (i)
		oplot, x, y, psym = 2, _extra = _extra
		oplot, x, y, _extra = _extra
	endelse
endif else begin ; x, y, and psym are set
	oplot, x, y, psym=psym, _extra = _extra
	oplot, x, y, _extra = _extra
endelse

DONE:

end