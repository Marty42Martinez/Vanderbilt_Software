function area_overlap, x0, y0, dx0, dy0, x1, y1, dx1, dy1

; returns fraction of area of box 1 overlapping with box 0

; NOTE: Box 0 may be vector and box 1 a scalar, OR vice-verse (not both).
;		Assumes x is a longitude dimension
;		All values are in DEGREES

; x0, y0 : center of box 0
; dx0, dy0 : x (y) width of box 0
; x1, y1 : center of box 1
; dx1, dy1 : x (y) width of box 1

fx = linear_overlap(x0-dx0/2., x0+dx0/2., x1-dx1/2., x1+dx1/2., /lon)
fy = linear_overlap(y0-dy0/2., y0+dy0/2., y1-dy1/2., y1+dy1/2.)
fx = reform(fx, /over)
fy = reform(fy, /over)
if n_elements(fx) eq 1 then fx = fx[0]
if n_elements(fy) eq 1 then fy = fy[0]

return, fx * fy

END
