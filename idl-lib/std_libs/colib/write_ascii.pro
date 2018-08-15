pro write_ascii, outname, x1, x2, x3,x4,x5,x6,x7,x8,x9,x10,x11,x12, $
	header=header, dec=dec, width=width, format=format

; Writes n vectors as columns to an n-column ASCII file. (up to 12 columns)
; dec is the decimal precision for each column
; width is the width of each column in the ascii file

get_lun, lun
openw, lun, outname
n = n_elements(x1)
np = n_params()-1

if keyword_set(header) then printf, lun, header
if n_elements(dec) eq 0 then dec = 2
if n_elements(width) eq 0 then width = 9
if n_elements(format) eq 0 then $
	format = '(' + sc(np) + '(f'+sc(width)+'.' + sc(dec) + '," "))'
print, format

x = transpose(x1)

if np GE 2 then x = [x,transpose(x2)]
if np GE 3 then x = [x,transpose(x3)]
if np GE 4 then x = [x,transpose(x4)]
if np GE 5 then x = [x,transpose(x5)]
if np GE 6 then x = [x,transpose(x6)]
if np GE 7 then x = [x,transpose(x7)]
if np GE 8 then x = [x,transpose(x8)]
if np GE 9 then x = [x,transpose(x9)]
if np GE 10 then x = [x,transpose(x10)]
if np GE 11 then x = [x,transpose(x11)]
if np GE 12 then x = [x,transpose(x12)]


printf, lun, x, format=format


close, lun
free_lun, lun

end