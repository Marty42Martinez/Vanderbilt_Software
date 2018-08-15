function elimleadzeros, s

; s is a string rep of a number.  if s is of the form
; "0.xyza...", then i return ".xyza..." else i return s.
num = float(s)
if abs(num) LT 1 then begin
; number is lt 1, so could need a trailing zero eliminated
	if num gt 0 then begin
		w = strpos(s,'.')
		if w ne -1 then out = strmid(s,w,strlen(s)-w) else out=s
	endif else begin ; num is lt or eq to 0
		if num eq 0 then out = '0' $
		else begin ; num is negative
			w = strpos(s,'.')
			if w ne -1 then out = strmid(s,w,strlen(s)-w) else out=s
			out = '-'+out
		endelse
	endelse
endif else out = s

return, out

end