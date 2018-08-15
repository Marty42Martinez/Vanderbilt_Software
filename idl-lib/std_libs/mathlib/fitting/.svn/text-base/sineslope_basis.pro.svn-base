function sineslope_basis, t, period=period, N = N

	; t : array of times
	; Period = the period, in units of t, of the sinusoid.
	; fitting function is y(t) = P0 + P1*t + P2 sin(wt) + P3 cos(wt) + p4 sin(2wt) + p5 cos(2wt) + ...
	; the number of harmonics to keep is N (default is 1)

	if n_elements(period) eq 0 then period=12. ; default period
	if n_elements(N) eq 0 then N = 1
	Nt = n_elements(t)
	if size(t, /type) eq 5 then begin
		twopi = 2.0d * !dpi
		one = 1.0d
		out = dblarr(Nt,2+2*N)
	endif else begin
		twopi = 2.0*!pi
		one = 1.0
		out = fltarr(Nt,2+2*N)
	endelse
	omega = twopi / period

	out[*,0] = one
	out[*,1] = t
	for i = 1, N do begin
		out[*,2*i] = sin(i*omega*t)
		out[*,1+2*i] = cos(i*omega*t)
	endfor

	return, out

END