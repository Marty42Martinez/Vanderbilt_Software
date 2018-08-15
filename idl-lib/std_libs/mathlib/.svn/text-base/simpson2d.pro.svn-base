function simpson2D, Z,x,y,p

; Z:	the 2D tabulated values to be integrated; Z=Z(x,y)
; p: 	the 2xN list of ordered pairs (must be contiguous)
;		to be integrated over.  Output from the where2D function works.
; x:	the function which tells you what p0 indices correspond to what x's.
; y:	same as above, but for y.

; the x's and y's MUST be equally spaced.  I 2D Composite Simpson's Rule.

wx = different(p[*,0]) ; indices of all the different x's i have
nx = n_elements(wx)

wx = wx[sort(wx)]
if nx eq 1 then return, 0.
h = x[wx[1]]-x[wx[0]]

j1 = 0
j2 = 0
j3 = 0

for i = 0, nx-1 do begin ; cycle through all x-values
	wy = p[where(p[*,0] eq wx[i]),1]
	ny = n_elements(wy)

	if (ny eq 1) then begin
		L = 0
		goto, skip
	endif
	n_o = (ny+1)/2-1
	n_e = (ny)/2-1
	if n_o gt 0 then yo = indgen(n_o)*2 + 1
	if n_e gt 0 then ye = indgen(n_e)*2 + 2

	HX = y[wy[1]] - y[wy[0]]
	k1 = Z[wx[i],wy[0]]
	if n_e gt 0 then k2 = total(Z[wx[i],wy[ye]]) else k2 = 0
	if n_o gt 0 then k3 = total(Z[wx[i],wy[yo]]) else k3 = 0
	L = HX/3.*(k1+2*k2+4*k3)
skip:
	if ((i eq 0) OR (i eq nx-1)) then J1 = J1 + L else $
		if even(i) then J2 = J2 + L else J3 = J3 + L
endfor

return, h * (J1 + 2*J2 + 4*J3)/3.

END