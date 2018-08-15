PRO eplot, x, y, sd, color=color, ecolor=ecolor, ethick=thick,  width=width

on_error,2                      ;Return to caller if an error occurs
	if n_params(0) eq 3 then begin	;X specified?
		up = y+sd
		down = y-sd
		xx = x
   endif else begin	;Only 2 params
		up = x+y
		down = x-y
		xx=findgen(n_elements(up)) ;make our own x
	endelse

oldc = !p.color
if keyword_set(color) then !p.color = color
if keyword_set(ecolor) then !p.color = ecolor

errplot, xx, down, up, width=width, th = thick

!p.color = oldc

END