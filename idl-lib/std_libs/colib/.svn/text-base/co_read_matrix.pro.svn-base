PRO co_read_matrix, file, matrix, n_lines_head = n_lines_head

info = file_info(file)
if ~ info.exists then begin
	print, 'File does not exist!'
	STOP
endif
if n_elements(n_lines_head) eq 0 then n_lines_head = 0L

openr, lun, file, /get_lun


if n_lines_head GT 0 then begin
	header = strarr(n_lines_head)
	readf, lun, header
endif


; read the first line
str = ''
readf, lun, str
matrix = float(strsplit(str, /extract, count = n))

vec = matrix * 0.

i = 0L
repeat begin
	readf, lun, vec
	matrix = [ [matrix], [vec] ]
endrep until eof(lun)

close, lun
free_lun, lun

END


