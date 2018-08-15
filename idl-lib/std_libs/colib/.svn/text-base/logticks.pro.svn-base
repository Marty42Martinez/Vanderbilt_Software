function logticks, xrange

; INPUT : The range of x-values used.

x0 = ceil(min(alog10(xrange), max=max_))
x1 = floor(max_)
nt = x1-x0 + 1 ; # of ticks (most likely)
tnames = strarr(nt)
x_ = indgen(nt) + x0 ; log10 of the tick values.


for t = 0, nt-1 do begin
	case x_[t] of
		-1 :  tnames[t] = '0.1'
		0  : tnames[t] = '1'
		1  : tnames[t] = '10'
		else :  tnames[t] = tex('10^{'+strcompress(x_[t], /rem)+'}')
	endcase
endfor

return, tnames

end