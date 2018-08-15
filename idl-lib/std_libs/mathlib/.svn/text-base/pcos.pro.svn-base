function pcos, n, R, x

; computes anti-derivative of x^n * cos(R*x) evaluated at x.
; n must be >= 0, and be an integer.

sum = 0.
s = sin(R*x)
c = cos(R*x)
fact = 1.
if (R ne 0.) then begin
for j = 0,n do begin
	sign = even(floor(j/2.))*2 - 1
	if odd(j) then trig = c else trig = s
	if j gt 0 then fact = fact * (n-j+1)
	sum = sum + sign*trig*fact*x^(n-j)/R^(j+1)
endfor
endif else begin
	sum = x^(n+1)/(n+1.)
endelse
return, sum

end

