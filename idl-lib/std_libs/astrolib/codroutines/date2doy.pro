
function date2doy, year, month, day

	; DATE2DOY
	;	 converts a calendar date to day number of that year (1-366)
	; 	 ; 	YEAR	: Either year number (integer) OR string: 'YYYYMMDD'
		 ; MONTH	: If year is a number, month must be the month number {1-12}
		 ; DAY		: if Year is a number, day must be the day-in-month number {1-31}


	if size(year, /type) eq 7 then begin
		; user passed strings of type YYYYMMDD
		year_ = fix(strmid(year, 0, 4))
		month = fix(strmid(year, 4, 2))
		day = fix(strmid(year, 6, 2))
	endif else year_ = year


;	           J   F   M   A   M   J   J   A   S   O   N   D
	mon_arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

	doy = year_ * 0
	nd = n_elements(doy)

	yrs = different(year)
	feb = 28 + leap_year(yrs)
	ny = n_elements(yrs)
	for i = 0, ny-1 do begin
		yr = yrs[i]
		wi = where(year eq yr)
		mon_arr[1] = feb[i]
		mon_int = [0, (fix(total(mon_arr, /cum)))[0:10] ] ; cumulative # of days from the months before
    	doy[wi] = mon_int[month[wi]-1] + day[wi]
    endfor

	if nd eq 1 then doy = doy[0]

	return, doy

END

