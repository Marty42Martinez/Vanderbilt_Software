pro textplot, x_, y_, A, delta=delta, _extra = _extra, top=top, bottom=bottom, normal=normal, device=device

; plots #s or text over previously plotted points.

n = n_elements(x_)
if n_elements(delta) eq 0 then delta = 0.04

if n_params() eq 2 then begin ; called with two params
	y = x_
	A = y_
	x = findgen(n)
endif else begin	; called with 3 params
	x = x_
	y = y_
endelse

if n_elements(x) eq 1 then x = x + y*0
if n_elements(y) eq 1 then y = y + x*0

if NOT (keyword_set(normal) OR keyword_set(device)) then begin
	yr = !y.crange
	y = y + delta*(yr[1]-yr[0])
	if keyword_set(top) then y = 0*y + 0.95* (yr[1]-yr[0]) + yr[0]
	if keyword_set(bottom) then y = 0*y + 0.05 * (yr[1]-yr[0]) + yr[0]
endif
sA = size(A)
if sA[sA[0]+1] ne 7 then A_ = sc(A[i]) else A_ = A

for i=0,n-1 do xyouts,x[i],y[i],A_[i], normal=normal, device=device, _extra=_extra

end

