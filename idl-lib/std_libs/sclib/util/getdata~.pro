PRO getdata2,var,file=file,pick=pick
if keyword_set(pick) then begin
	cd, 'e:\analysis\data'
	file=dialog_pickfile(filter='*.dat',/read)
endif
openr,lun,file,/get_lun
count=1L
line='' & readf,lun,line
while not eof(lun) do begin
	readf,lun,line
	count=count+1
endwhile

point_lun,lun,0
var=fltarr(3,count)
readf,lun,var
free_lun,lun
end