pro filetrim, file

Nl = numlines(file)

get_lun, lun
openr, lun, file

line = strarr(NL)
s = ''
for i = 0,Nl- 1 do begin
readf, lun, s
line[i] = s
line[i] = strcompress(line[i])

endfor


close, lun
openw, lun, file
for i = 0, Nl-1 do printf, lun, line[i]

close, lun
free_lun, lun

end


