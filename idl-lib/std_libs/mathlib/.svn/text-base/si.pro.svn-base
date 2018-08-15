function si_ind, x, eps=eps, jmax = jmax

; Returns the sine integral of x (x is real; result may be complex)
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

if (t eq 0.) then return, -1./fpmin
if (t le tmin) then begin				; power series expansion
	si = t
	if t ge sqrt(fpmin) then begin
		fact = t
		for k = 1, jmax do begin
			j = 2.0*k+1
			fact = -1*fact * t^2 /(j*(j-1))
			term = fact/j
			si = si + term
			err = abs(term/si)
			if err LE EPS then goto, done1
		endfor
		message, 'MAX No of Iterations Exceeded in power series for si() !!'
		done1 : si = si ; do nothing
	endif
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
	done_cont : si = imaginary(h) * cos(t) - float(h) * sin(t) + !pi/2.
endelse

if x LT 0. then return, -si else return, si

END

function si, x, _extra=_extra

if n_elements(x) gt 1 then begin
	out = x
	for i=0,n_elements(x)-1 do out[i] = si_ind(x[i], _extra=_extra)
endif else out = si_ind(x)

return, out

end