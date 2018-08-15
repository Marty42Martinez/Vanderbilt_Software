FUNCTION jd2ct, jd, tzone=tzone, hms=hms

if n_elements(tzone) eq 0 then tzone = 0

t = ((jd-floor(jd)+0.5) mod 1)*24. - tzone
t = t mod 24
w = where(t LT 0)
if n_elements(w) GT 1 then begin
	t[w] = t[w] + 24.
endif else begin
	w = w[0]
	if w NE -1 then t[w] = t[w] + 24.
endelse
if keyword_set(hms) then begin
	h = floor(t)
	m = floor((t-h)*60.)
	s = round( ((t-h)*60. - m)*60.)
	if h le 9 then h = '0'+string(h) else h = string(h)
	if m le 9 then m = '0'+ string(m) else m=string(m)
	if s le 9 then s = '0' + string(s) else s=string(s)
	t = strcompress(h+':'+m+':'+s,/rem)
endif
return, t

END