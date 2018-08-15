function ci_ind, x, eps=eps, jmax = jmax

; Returns the cosine integral of x (x is real; result may be complex)
; this algorithm adopted from numerical recipes, p 252.
; currently only works in floating-point math

; eps : the desired relative fractional accuracy {def = 1e-6}
; jmax : the maximum number of iterations allowed { def = 40 }


tmin = 2.0
fpmin = 1.0e-30
EULER = 0.57721566490153

if n_elements(eps) eq 0 then eps = 1e-7
if n_elements(jmax) eq 0 then jmax = 40
t = abs(x)

if (t eq 0) then return, -1./fpmin

if (t le tmin) then begin				; power series expansion
	ci = 0.
	fact = 1.
	for k = 1, jmax do begin
		j = 2.0*k
		fact = -1*fact * t^2 /(j*(j-1))
		term = fact/j
		ci = ci + term
		err = abs(term/ci)
		if err LE EPS then goto, done1
	endfor
	message, 'MAX No of Iterations Exceeded in power series for ci() !!'
	done1 : ci = ci + EULER + alog(t)
endif else begin						; continued fraction
	b = complex(1., t)
	c = 1./fpmin
	d = 1./b
	h = d
	for i=2, jmax do begin
		a = -(i-1.0)^2
		b = b + 2.
		d = 1./(a*d+b)
		c = b + a/c
		del = c * d
		h = h * del
		if abs(del-1.) LT EPS then goto, done_cont
	endfor
	message, 'MAX No. of Iterations Failed in Continued Fraction for ci() !'
	done_cont : ci = -1*(float(h) * cos(t) + imaginary(h) * sin(t))
endelse

if x LT 0. then return, complex(ci, -!pi) else return, ci

END

function ci, x, _extra=_extra

if n_elements(x) gt 1 then begin
	out = x
	for i=0,n_elements(x)-1 do out[i] = ci_ind(x[i], _extra=_extra)
endif else out = ci_ind(x)

return, out

end