FUNCTION goesJD, date, time, tzone = tzone

; takes array of "dates" and "times" from the GOES satellites, and converts
; to array of julian dates.

; date, time will be longints or floats or something.

Ndates = n_elements(date)
julian = dblarr(Ndates)
for i = 0,Ndates-1 do begin
	d1 = sc(long(date[i]))
	d2 = sc(long(time[i]))
	sl = strlen(d2)
	if sl ne 6 then begin
		if sl eq 4 then d2 = '00' + d2
		if sl eq 5 then d2 = '0' + d2
	endif

	year = fix(strmid(d1,0,4))
	doy = fix(strmid(d1,4,3))
	doy2date, doy,year, month, day

	hour = fix(strmid(d2,0,2))
	minute = fix(strmid(d2,2,2))
	second = fix(strmid(d2,4,2))

	UT = hour + minute/60. + second/3600.

	jdcnv, year, month, day, UT, jtime

	julian[i] = jtime
endfor
if n_elements(julian) eq 1 then julian = julian[0]
return, julian

END