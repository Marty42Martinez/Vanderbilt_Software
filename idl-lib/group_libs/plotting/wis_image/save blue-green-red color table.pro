; batch to make blue-green-red color table for wis_image

; Set up color table file and ITAB to use
ITAB = 2
ctfile = co_path('/people/idl/GENERAL/wis_image/wis_color_tables.tbl')
ctname = 'Wis: Blue-Green-Red'

; Define Reserved Colors
i_white = 255
i_black = 0
i_grey = 1
res = [i_white, i_black,i_grey]
nres = n_elements(res)

; Load Desired Color Table
loadct, 33, bottom = nres

; Find indices of main colors
cdef = 0
for i= 0, nres - 1 do begin
	if (elt(i, res) eq 0) then begin
		if cdef then c = [c,i] else begin
			cdef = 1
			c = i
		endelse
	endif
endfor

;Set White, Black, and Grey (reserved colors)
r[i_white] = 255 & g[i_white] = 255 & b[i_white] = 255
r[i_black] = 0 & g[i_black] = 0 & b[i_black] = 0
r[i_grey] = 127 & g[i_grey] = 127 & b[i_grey] = 127

;Set Main Colors
for i = 0,n_elements(c)-1 do begin
  ci = c[i]
  r[ci] = rc[i+nres]
  b[ci] = bc[i+nres]
  g[ci] = gc[i+nres]
endfor

;Save this color table to my color table file
modifyct, itab, ctname, file=ctfile, r, g, b

END
