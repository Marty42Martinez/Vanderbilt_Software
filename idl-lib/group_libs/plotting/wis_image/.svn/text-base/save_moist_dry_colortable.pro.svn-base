; batch to make blue-green-red color table for wis_image

; Set up color table file and ITAB to use
ITAB = 7
ctfile = '~/idlprogs/aos/wis_image/wis_color_tables.tbl'
ctname = 'Wis: Red-White-Blue'

; Define Reserved Colors
i_white = 255
i_black = 0
i_grey = 1
res = [i_white, i_black,i_grey]
nres = n_elements(res)
nc = 256 - nres

; Load Desired Color Table
;loadct, 33, bottom = nres

; Find indices of main colors
cdef = 0
for i= 0, 255 do begin
	if (elt(i, res) eq 0) then begin
		if cdef then c = [c,i] else begin
			cdef = 1
			c = i
		endelse
	endif
endfor

tvlct, r, g, b, /get

;Set White, Black, and Grey (reserved colors)
r[i_white] = 255 & g[i_white] = 255 & b[i_white] = 255
r[i_black] = 0 & g[i_black] = 0 & b[i_black] = 0
r[i_grey] = 127 & g[i_grey] = 127 & b[i_grey] = 127

;Set Middle Color

r[c[126]] = 255 & g[c[126]] = 255 & b[c[126]] = 255

top = (nc-1) / 2 - 1

for i = 0, top do begin
  cn = c[i]
  b[cn] = 2*i
  g[cn] = 2*i
  r[cn] = 255

	cp = c[nc - i - 1]
	b[cp] = 255
	g[cp] = 2*i
	r[cp] = 2*i
endfor

;Save this color table to my color table file
modifyct, itab, ctname, file=ctfile, r, g, b

END
