
	PRO doy2date, DOY, year, month, day, yyyymmdd
;	----------------------------------------------------------------
;+							19-Sep-91
;	NAME:
;		doy2date
;	PURPOSE:
;		convert DOY and year to month and day.
;	CALLING SEQUENCE:
;		DOY2date, DOY, year, month, day [, yymmdd]
;	INPUT:
;		doy	day of year
;		year	year (e.g. 90, 91, 92...)
;	OUTPUT:
;		month	month number (01,02,03,..)
;		day	day of the month
;	Optional/Output:
;		yymmdd	string with 'yymmdd'
;	HISTORY:
;		Extended from Mons Morrison's DOY2Date,
;		done 19-Sept-91 by GAL.
;		Re-written by CWO 2004 to actually be correct, and work with vector inputs.

;
;	           J   F   M   A   M   J   J   A   S   O   N   D
	mon_arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	feb = year * 0 + 28
	w = where((year mod 4) eq 0) & if w[0] ne -1 then feb[w] = 29
	w = where((year mod 100) eq 0) & if w[0] ne -1 then feb[w] = 28
	w = where((year mod 400) eq 0) & if w[0] ne -1 then feb[w] = 29

	if n_elements(year) eq 1 then begin
		mon_arr[1] = feb[0]
		mon_int = fix(total(mon_arr, /cum))
		mon_int2 = mon_int * 0
		mon_int2[1:11] = mon_int[0:10] ; this is the cumulative of the months before it
		; get month number (1-12)
		month = value_locate(mon_int, doy-1) + 2 ; requires "doy" to be 1..366!
		; get day in month
		day = doy - mon_int2[month-1]   ; day of month
	endif else begin ; we have multiple years here!
		nd = n_elements(doy)
		day = intarr(nd)
		month = intarr(nd)
		for i = 0, nd-1 do begin
			mon_arr[1] = feb[i]
			mon_int = fix(total(mon_arr, /cum))
			mon_int2 = mon_int * 0
			mon_int2[1:11] = mon_int[0:10] ; this is the cumulative of the months before it
			; get month number (1-12)
			month[i] = value_locate(mon_int, doy[i]-1) + 2 ; requires "doy" to be 1..366!
			; get day in month
			day[i] = doy[i] - mon_int2[month[i]-1]   ; day of month
		endfor
	endelse

	IF (N_PARAMS() EQ 5) THEN BEGIN		;pass back 'yymmnn'
      yyyy = strtrim(string(year), 2)
	  mm = STRTRIM( STRING(format='(i2.2)',month), 2)
	  dd = STRTRIM( STRING(format='(i2.2)',day), 2)
	  yyyymmdd = yyyy + mm + dd
	ENDIF

	END

