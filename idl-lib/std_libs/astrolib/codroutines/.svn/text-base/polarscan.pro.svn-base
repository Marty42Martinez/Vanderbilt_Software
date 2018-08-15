pro polarscan, declination, thick=thick, color = color

; overplot the polar scan strategy on a map

if keyword_set(thick) then begin
	oldpthick = !p.thick
	!p.thick = thick
endif

if n_elements(color) eq 0 then color = 255

N = 1000

dec = fltarr(1000) + declination
ra = findgen(1000)/1000.*360.

euler, ra,dec,l,b,1

l = -1*l
plots, l[0], b[0]
for i=1,n-1 do begin
	plots, l[i],b[i], /continue, color = color
;	delay, .01
endfor
if keyword_set(thick) then !p.thick = oldpthick

END
