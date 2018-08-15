;NUMSTR.PRO
;make a number into a string with no padding w/ a minimum of typing

FUNCTION numstr,a,l
	s=0
	;p=floor(alog10(a))
	
	b=a

	;b=float(round(b))

	;b=b/(10^(-p+l))

	b=strtrim(string(b),2)
	b=strmid(b,s,l+2)
	return,b
end
