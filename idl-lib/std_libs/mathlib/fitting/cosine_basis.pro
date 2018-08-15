function cosine_basis, t, period=period, N = N
	; t : array of times
	; Period = the period, in units of t, of the sinusoid.
	; fitting function is y(t) = P0 + P1 sin(wt) + P2 cos(wt) + p3 sin(2wt) + p4 cos(2wt) + ...
	; the number of harmonics to keep is N (default is 1)

	if n_elements(period) eq 0 then period=12. ; default period
	if n_elements(N) eq 0 then N = 1
	Nt = n_elements(t)
	if size(t, /type) eq 5 then begin
		twopi = 2.0d * !dpi
		one = 1.0d
		out = dblarr(Nt,1+2*N)
	endif else begin
		twopi = 2.0*!pi
		one = 1.0
		out = fltarr(Nt,1+2*N)
	endelse
	omega = twopi / period

	out[*,0] = one
	for i = 1, N do begin
		out[*,2*i-1] = sin(i*omega*t)
		out[*,2*i] = cos(i*omega*t)
	endfor

	return, out

END