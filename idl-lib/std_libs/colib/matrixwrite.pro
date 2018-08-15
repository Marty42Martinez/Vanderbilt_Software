pro matrixwrite, M, outname, header=header, dec=dec, wid = wid

; Writes matrix M to an ASCII file.

get_lun, lun
openw, lun, outname

n = n_elements(binra)
if keyword_set(header) then printf, lun, header
if n_elements(dec) eq 0 then dec = 2
if n_elements(wid) eq 0 then wid = 10
format = '(' + sc(n_elements(M[*,0])) + '(f' + sc(wid)+'.' + sc(dec) + '," "))'
print, format
printf, lun, M, format=format
close, lun
free_lun, lun

end