function psin, n, R, x

; computes anti-derivative of x^n * sin(R*x) evaluated at x.

sum = 0.
s = sin(R*x)
c = cos(R*x)
fact = 1.
if (R ne 0.) then begin
for j = 0,n do begin
	sign = odd(ceil(j/2.))*2 - 1
	if even(j) then trig = c else trig = s
	if j gt 0 then fact = fact * (n-j+1)
	sum = sum + sign*trig*fact*x^(n-j)/R^(j+1)
endfor
endif

return, sum

end

