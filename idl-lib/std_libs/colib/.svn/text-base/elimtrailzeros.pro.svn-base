function elimtrailzeros, str

; Eiminates the trailing zeros from a string representation of an number.

; str is some str rep of a #
; i eliminate the trailing zeros down to
; an integer, if necessary.

ptpos = strpos(str, '.')
if ptpos eq -1 then return, str ; already an integer!
out = str
done = 0
sl = strlen(out)
repeat begin
  lastc = strmid(out,sl-1,1) ; last character
  if lastc eq '0' then out = strmid(out,0,sl-1) else done=1
  sl = strlen(out)
endrep until done
;remove trailing decimal point if necessary
if strmid(out,sl-1,1) eq '.' then out = strmid(out,0,sl-1)

return, out

end