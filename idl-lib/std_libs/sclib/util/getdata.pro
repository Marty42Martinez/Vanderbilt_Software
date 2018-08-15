;Reads 3xn (TMS format) ASCII data file into var
;Calling with file='drive:\path\filename.dat' reads filename.dat directly
;Calling with /path opens dialog box for data file selection.
;SC 4. Mar 99

PRO getdata,var,file=file,pick=pick,help=help, one_col=one_col
if (k_s(help) or n_params() EQ 0) then BEGIN
    print,'Calling sequence: GETDATA, variable,(file=path/filename), (/one_col)'
    return
endif

if (keyword_set(pick) OR (keyword_set(file) eq 0)) then begin
	cd, '/home/cordone/analysis'
	file=dialog_pickfile(filter='*',/read)
endif
openr,lun,file,/get_lun
count=1L

print,'accessing file '+file

line='' & readf,lun,line
while not eof(lun) do begin
	readf,lun,line
	count=count+1
endwhile

point_lun,lun,0
var=dblarr(3,count)
readf,lun,var

if (keyword_set(one_col)) then var=var(1,*)
free_lun,lun

;print,'Data read into '+strtrim(string(var))
print,"Finished."
end
