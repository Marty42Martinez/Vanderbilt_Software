function splitdate, date
; date is a date string
; 2 or 4-dig year
; separator can be '\' or '/' or '-' (but not a combination!)
; figure out the substring used
; if date error then return -1
; returns the split up substrings

	date_err = 0

	if strpos(date,'/') ne -1 then begin
		sep = '/'
		sepfound = 1
	endif
	if strpos(date,'\') ne -1 then begin
		sep = '\'
		if sepfound eq 1 then date_err= 1 else sep_found = 1
	endif
	if strpos(date,'-') ne -1 then begin
		sep = '-'
		if sepfound eq 1 then date_err= 1 else sep_found = 1
	endif
	if strpos(date,sep) eq -1 then date_err = 1
	if sepfound eq 0 then date_err = 1
	if date_err then return, -1

	dateparts = STR_SEP(date,sep)

	return, dateparts
end