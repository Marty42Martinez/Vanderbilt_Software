function polycosintegral, a, x, x0, R

; returns the definite integral of poly(x) * cos((x-x0)*R) from x[0] to x[1]
; where poly(x) := a[0] + a[1]*x + a[2]*x^2 +...+ a[n]*x^n

; a : vector of coefficients of the polynomial:
;	a0 : x^0 coeff
;   a1 : x^1 coeff
;   an : x^n coeff
;
; x : [x1,x2] integration range
; x0 : x offset
; R : x multiplier in cos()

n = n_elements(a)-1
sum = 0
for k = 0, n do sum = sum + a[k] * (  cos(R*x0) * (pcos(k,R,x[1])-pcos(k,R,x[0])) $
			       					- sin(R*x0) * (psin(k,R,x[1])-pcos(k,R,x[0])))

return, sum

end