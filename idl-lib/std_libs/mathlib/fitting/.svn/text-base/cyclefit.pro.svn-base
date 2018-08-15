; Fit a sin or cosine cycle to a data set, fast.
; X-values (times) need not be evenly sampled.

function cyclefit, data, time, period=period, yfit=yfit, $
	yminus = yminus, phasetime=phasetime, double=double

; data : the data.  Note : this may be 2D (ntimes, npixels)
; time : the times corresponding to each data point (a 1D vector only!)
; period : the nominal seasonal period of the data.  Default is 365.25
; yminus : the data with the cycle removed
; yfit : the cycle fit
; phasetime : the fit time of the first maximum of the cycle (the time delay)

; MODEL :
; f(x) = P[0] * sin(x) + P[1] * cos(x) + P[2]
; where
; x = 2 * !pi/period * time

	sd = size(data)
	n = sd[1]
	if sd[0] eq 1 then npix = 1 else npix = sd[2]
	if n_elements(time) eq 0 then time = findgen(n)

	s = sort(time)
	x = time[s]
	y = data[s, *]


	if n_elements(period) eq 0 then period = 1. ; assume a unit period
	phi = 2*!pi / period * x
	sin1 = sin(phi)
	cos1 = cos(phi)

	S1 = total(sin1)
	C1 = total(cos1)
	S2 = total(sin1^2)
	C2 = total(cos1^2)
	SC1 = total(sin1 * cos1)

	M = dblarr(3,3)
	M[*,2] = [S1, C1, N]
	M[*,0] = [S2, SC1, S1]
	M[*,1] = [SC1, C2, C1]

	; create the "B" vector in AX = B, created by hitting y with each basis vector.
	yvec = dblarr(npix, 3)
	for i = 0, npix-1 do yvec[i,*] = $
	  [ total(y[*,i] * sin1), total(y[*,i] * cos1), total(y[*,i]) ]

  ; now let us use the Choleski Decomposition Method!
  	Mch = M
	LA_CHOLDC, Mch, double=double ; get the choleski factorization
	P0 = LA_CHOLSOL(Mch, yvec, double=double) ; initial solution vector
	P = LA_CHOLMPROVE(M, Mch, yvec, P0, double=double)

;   Minv = invert(M, double=double)
;	P = transpose(Minv ## yvec)

	yfit = data * 0.
	for i = 0, npix-1 do yfit[*,i] = P[i,0] * sin1 + P[i,1] * cos1 + P[i,2]

	yminus = y - yfit

	; now unsort yfit and yminus
	us = sort(s) ; the unsort is just the sort of the sorting vector!
	yfit = yfit[us,*]
	yminus = yminus[us,*]

	phasetime = reform(period / (2*!pi) * Atan(P[*,0] / P[*,1]))
	if npix eq 1 then phasetime = phasetime[0]

	P = transpose(P)
	return, P

END

