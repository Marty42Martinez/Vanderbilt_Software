function randomseed

; just like the old PASCAL function.  returns the hundredths of a second
; of the current system time.

time = long( (systime(1) - 975277570.)*10 )

return, time

end