PRO WriteRB, fname, last=last

; Writes the recall buffer to the file fname, in forward chronological order.
;
; INPUTS
;	fname 	: 	The output text file name (including complete path).
;
; KEYWORDS
;	last	: 	Number of most recent commands to write to the recall buffer
;

rb = recall_commands()
n = n_elements(rb)
if n_elements(last) eq 0 then last = n

rb = reverse(rb[0:last-1]) ; commands I want

get_lun, lun
openw, lun, fname
for i = 0, n_elements(rb)-1 do printf, lun, rb[i]

close, lun
free_lun, lun

END