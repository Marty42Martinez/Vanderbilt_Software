function num2str, xxxx, dig, sig=sig, keep=keep, lead=lead, trail=trail
; This function converts numbers to strings.

; x : a scalar or vector list of numbers
; return string representation of x to SIG significant figures.
; SIG : The number of significant figures [default=3]
; KEEP : Set this to keep all digits to the left of decimal point
; LEAD : Set this to remove leading zeroes
; TRAIL : Set this to remove trailing zeroes

x = abs(xxxx)


if n_elements(dig) GT 0 then begin ; for compatibility with previous function
	if dig GT 0 then begin
		format = '(f15.' + strcompress(string(dig), /rem) + ')'
		out = strcompress(string(x, format=format), /rem)
	endif else begin
		out = strcompress(string(round(x), format='(i)'), /rem)
	endelse
endif else begin

if n_elements(sig) eq 0 then sig = 3

nx = n_elements(x)
out = strarr(nx)

ax = abs(x) ; work with the absolute value
l = floor(alog10(ax))
s = l-sig+1
wb = where(s GE 1, nb)
if nb GT 0 and keyword_set(keep) then s[wb] = 0
fact = 10.0^s
ax = ax / fact
ax = round(ax)
ax = ax * fact
d = -1*s > 0 ; # of digits past decimal point

w = d * 0 ; will hold the width
w0 = where(d eq 0, n0, comp = wn0, ncomp=nn0)
if n0 GT 0 then w[w0] = l[w0] + 1
w1 = where(d GT 0 and L GE 0, n1)
if n1 GT 0 then w[w1] = sig+1
wd = where(l LT 0, nd)
if nd GT 0 then w[wd] = d[wd] + 2 - keyword_set(lead) ; width for #s less than one
sw = strcompress(string(w),/rem)
sd = strcompress(string(d),/rem)
format = strarr(nx) + '('
if n0 GT 0 then format[w0] = format[w0] + 'i' + sw[w0] + ')'
if nn0 GT 0 then format[wn0] = format[wn0] + 'f' + sw[wn0] + '.' + sd[wn0] + ')'

for i = 0, nx-1 do begin
	out[i] = string(ax[i], form = format[i])
endfor
if keyword_set(trail) and nn0 GT 0 then begin
	; check the decimal numbers for trailing zeroes
	out1 = out[wn0]
	repeat begin
		nt = 0
		for j = 0, nn0-1 do begin
			len = strlen(out1[j])
			last = strmid(out1[j], len-1, 1)
			if last eq '0' then begin
				out1[j] = strmid(out1[j], 0, len-1)
				nt = 1
			endif
		endfor
	endrep until nt eq 0
	; now there might be some numbers ending in a decimal point.
	; remove them.
	for j = 0, nn0-1 do begin
		pos = strpos(out1[j], '.')
		len = strlen(out1[j])
		if len eq (pos+1) then out1[j] = strmid(out1[j], 0, len-1)
	endfor
	out[wn0] = out1
endif

endelse

wneg = where(xxxx LT 0., nneg)
if nneg GT 0 then out[wneg] = '-' + out[wneg]


return, out

END





