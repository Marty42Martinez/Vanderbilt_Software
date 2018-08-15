function strswitch, S, s1, s2

; S : input string (a scalar)
; s1: substring to be replaced
;	s2: substring to replace 'in' substring with.

p = strpos(S,s1)
l1 = strlen(s1)
l2 = strlen(s2)
out = S

while p ne -1 do begin
	out = strmid(out,0, p) + s2 + strmid(out,p+l1,strlen(out)-p-l1)
	p = strpos(out, s1)
endwhile

return, out
end

