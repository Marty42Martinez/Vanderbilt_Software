;Converts MSAM2 97 record numbers to UT (in decimal & sexadecimal form) using archive
;Based on archive signal GUT.
;
;DATA: rectout.sav
;CALLS: dec2sexa
;WRITTEN: 6. Mar 98 by SC
;************************************************************
pro rectout

restore, filename='e:\analysis\data\wholeflight\rectout.sav'
gut(1,*)=(gut(1,*) < 24)
gut(1,*)=(gut(1,*) > 0)

; Get rid of dropouts

glitch=where(gut(1,*) eq 0.,count)
print, 'Total of',count,' glitches.'

;signal is strictly linear, so just replace glitches with average value.
gut(1,glitch)=(gut(1,glitch-33)+gut(1,glitch+33))/2

again='y'

recnum=0
while (again eq 'y') do begin

	invalid=1

	while invalid do begin
		read,recnum,prompt='Enter record number:'
		invalid=((recnum lt 4) OR (recnum ge (n_elements(gut(1,*)))))
		if invalid then print,'Invalid entry, record number must greater than 3, less than',n_elements(gut(1,*))
	endwhile

	index=where(gut(0,*) eq recnum)

	dectime=gut(1,index)

	print,'Record number',recnum,' corresponds to UT decimal time', dectime,' hours.'
	dec2sexa,dectime,hour,minute,second,sexaform,/time
	;print,hour,minute,second,format=sexaform
	read,again,prompt='Convert another record number? <y or n>

	case again of
		'y': again='y'
		'n': again='n'
	else: print, 'Invalid response. Exiting.'
	endcase

endwhile

print, 'Done.'
end