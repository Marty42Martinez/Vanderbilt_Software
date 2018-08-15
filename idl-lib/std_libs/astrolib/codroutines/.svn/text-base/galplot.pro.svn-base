pro galplot, l,b, thick=thick, color = color

; overplot the polar scan strategy on a map

if keyword_set(thick) then begin
	oldpthick = !p.thick
	!p.thick = thick
endif

if n_elements(color) eq 0 then color = 255

n = n_elements(l)
l_new = -1*l
plots, l_new[0], b[0]
for i=1,n-1 do begin
	plots, l_new[i],b[i], /continue, color = color
;	delay, .01
endfor
if keyword_set(thick) then !p.thick = oldpthick

END
