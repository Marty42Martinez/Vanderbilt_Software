function cos_func, t, P, period=period, sine=sine
; t: independent variable
; P: fit parameters

; function that looks like this:
; f(t) = P[0] + P[1] * cos(omega * (t-P[2])) +  P[3] * cos(2*omega*(t-P[4])) + ...

; if keyword SINE is set, then it looks like this:
; f(t) = P[0] + P[1] * sin(omega*t) + P[2] * cos(omega*t) + P[3]*sin(2*omega*t) + P[4]

if n_elements(period) eq 0 then period = 24.
n = (n_elements(P)-1)/2
omega = 2*!pi/period

out = t*0. + P[0]

for i =1,n do begin
	if keyword_set(sine) then out = out + P[2*i-1] * sin(omega*t*i) + P[2*i] * cos(omega*t*i) $
	else out = out + P[2*i-1] * cos(i * omega * (t-P[2*i]))
endfor

return, out

END