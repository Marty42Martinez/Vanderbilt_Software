function readfirst, file, numline=numline, skiplines=skiplines, double=double

; Returns the first column of data file, up to max of 2,147,483,647 lines
; Numlines - The # of lines to be read (defaults to end of file)
; Skiplines - The # of lines to skip (defaults to 0)

get_lun, lun
line = ''
openr, lun, file
if n_elements(skiplines) eq 0 then skiplines = 0
nlines= numlines(file)
if n_elements(numline) eq 0 then numline = numlines(file)-skiplines

for i=0, skiplines-1 do readf, lun, line  ; skip unwanted beginning lines
if keyword_set(double) then out = dblarr(numline) else out=fltarr(numline)

i = 0
c = out[0]
WHILE Not (i ge numline) do begin
    READF, lun, c
    out[i] = c
 	i = i+1
ENDWHILE
CLOSE, lun	;Close the file.
free_lun, lun
return, out
END