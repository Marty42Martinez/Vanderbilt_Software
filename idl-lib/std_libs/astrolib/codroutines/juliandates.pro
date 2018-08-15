function juliandates, dates, times, tzone=tzone

; dates and times are arrays or scalars.  If time is a scalar,
; will only return jd of the first date/time.  If time is an array but
; date is a single date, will return the jd's of all those times for that
; particular date.  Otherwise, date and time must be arrays of equal length,
; and i will return the jd for each pair of date/time.

; returns array of corresponding julian dates


n = n_elements(times)
jds = dblarr(n)

if n_elements(dates) eq n then begin
  for i=0, n-1 do jds[i] = juliandate(dates[i],times[i], tzone=tzone)
endif else begin
  for i=0, n-1 do jds[i] = juliandate(dates,times[i], tzone=tzone)
endelse

return, reform(jds)

end