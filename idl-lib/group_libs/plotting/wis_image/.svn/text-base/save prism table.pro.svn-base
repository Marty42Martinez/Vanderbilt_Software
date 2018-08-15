; batch to make Black-Green-Yellow-Red-Back Color Table'

; Set up color table file and ITAB to use
ITAB = 4
ctfile = co_path('/people/idl/GENERAL/wis_image/wis_color_tables.tbl')
ctname = 'Wis: Blk-Grn-Yel-Red-Blk'

; Define Reserved Colors
i_white = 255
i_black = 0
i_grey = 1
res = [i_white, i_black,i_grey]
nres = n_elements(res)
nc = 256 - nres

; Load Desired Color Table
;loadct, 6

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

;r[c[126]] = 255 & g[c[126]] = 255 & b[c[126]] = 255

top = (nc-1) / 2 - 1

i = findgen(nc)
;r[c] = round(255 * (1 - (  (abs(168-i)/84) < 1.0 ) ))
;b[c] = 0
;g[c] = round(255 * (1 - (  (abs(84-i)/84) < 1.0 )))

r[c] = round(256*1.5* (1 - (  (abs(158.125-i)/94.875) < 1.0 ) )  < 255.49)
g[c] = round(256*1.5* (1 - (  (abs(94.875-i)/94.875) < 1.0 ) )  < 255.49)
b[c] = 0
;Save this color table to my color table file
modifyct, itab, ctname, file=ctfile, r, g, b

END
