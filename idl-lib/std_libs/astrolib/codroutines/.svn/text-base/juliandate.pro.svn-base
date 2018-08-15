; JULIANDATE

; AUTHOR:
;   Chris O'Dell
; 	Univ. of Wisconsin-Madison
;   Observational Cosmology Laboratory
;   Email: odell@cmb.physics.wisc.edu
;
; PURPOSE
;		Given input date and time in simple string format, calculates the julian date.
;
; CALLING SEQUENCE
;	juliandate, 'mm/dd/yy','hh:mm:ss.sss', jd [, tzone=tzone]
;		 	OR
;	juliandate, 'mm/dd/yyyy','hh:mm:ss.sss', jd [, tzone=tzone]
;			OR
;	juliandate, dates, times, jd [, tzone=tzone]
;		(where dates, times are arrays of date and time strings, respectively).
;
; DESCRIPTION
;   	This is a basic front-end for JDCNV, to calculate Julian Dates from a simple
;		string input of the date and time.  Can also handle array input.
; INPUT VARIABLES
;	date	:	Date string of the form "mm/dd/yy" OR "mm/dd/yyyy".
;				"-" and "\" are also valid separators (in addition to "/").
;				This may also be a vector of such strings.
;				NOTE: For year form "yy", if year = 00-20,
;					assumes 2000s, otherwise assumes 1900s. Best just to use "yyyy" form, though.
;
;	time	:	Time string of the form "hh:mm:ss.sss".  You MUST use the colon ":" as the separator.
;				May also be a vector of such strings.  If time is a vector but date is a scalar, assumes all
;				the times occurred on the same date.  You may have fractional seconds for higher accuracy.
;
; OPTIONAL INPUT KEYWORDS
;	tzone	:	the time zone correction (EST = 5, CST = 6, CDT = 5, etc.) from Greenwich Mean Time
; 				 [default is 0 (Greenwich Mean Time)].  This MUST be a SCALAR.
;
; OUTPUT VARIABLES
; 	jd		: 	Julian Date (scalar or vector), double precision.
;
; DEPENDENCIES:
;	jdcnv (astrolib)
;
;
; LAST MODIFIED:
;	June 4th, 2002


function splitdate, date
; date is a date string
; 2 or 4-dig year
; separator can be '\' or '/' or '-' (but not a combination!)
; figure out the substring used
; if date error then return -1
; returns the split up substrings

	date_err = 0
	sepfound = 0

	if strpos(date,'/') ne -1 then begin
		sep = '/'
		sepfound = 1
	endif
	if strpos(date,'\') ne -1 then begin
		sep = '\'
		if sepfound eq 1 then date_err= 1 else sepfound = 1
	endif
	if strpos(date,'-') ne -1 then begin
		sep = '-'
		if sepfound eq 1 then date_err= 1 else sepfound = 1
	endif
	if strpos(date,sep) eq -1 then date_err = 1
	if sepfound eq 0 then date_err = 1
	if date_err then return, -1

 	dateparts = strsplit(date,sep, /extract)
	return, dateparts
end



FUNCTION JulianDate, date, time, tzone = tzone

n = n_elements(time)
jds = dblarr(n) ; array of julian dates
if (n_elements(date) eq 1) AND (n GT 1) then date_ = replicate(date,n) else date_=date

for i=0,n-1 do begin

if n_elements(tzone) eq 0 then tzone = 5.

	dateparts = splitdate(date_[i])
	if dateparts[0] eq -1 then begin
		print, 'Date Format Error!'
		return, -1
	endif
	month = double(dateparts[0])
	day = double(dateparts[1])
	year = double(dateparts[2])
	; if year is greater than 99, assume four-digit year format
	; in this case, if year is greater than 20, assume 1900s else 2000s.
	if year LE 99 then $
		if (year gt 20) then year = year+1900. else year = year+2000.

	timeparts = strsplit(time[i],':', /extract)
	if timeparts[0] eq -1 then begin
		print, 'Time Format Error!'
		return, -1
	endif
	hour = double(timeparts[0])
	minute = double(timeparts[1])
	second = double(timeparts[2])

	UT = hour + minute/60. + second/3600. + tzone

	jdcnv, year, month, day, UT, julian
	jds[i] = julian
endfor

if n eq 1 then jds = jds[0]

return, jds

END