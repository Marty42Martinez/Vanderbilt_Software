function poly_func, x, p, dp

; x = the indep varaible
; y = the function output
; dp = the derivatives
; p = the parameters

	n = n_elements(p)
	dp = (x * 0) # (fltarr(n) + 1.)
	xx = 1.
	y = x * 0.
	for i = 0, n-1 do begin
		y = y + xx * p[i]
		dp[*,i] = xx
		xx = xx * x
	endfor

	return, y

END

function polyfit, x, y, N, weight=weight, measure_errors = measure_errors, $
				guess=guess, double=double, _ref_extra = _extra

	if ~(keyword_set(double)) then if size(x, /type) eq 5 OR size(y, /type) eq 5 then double = 1 else double=0
	if double then ONE = 1.0d else ONE = 1.0
	if double then ZERO = 0.0d else ZERO = 0.0

	if n_elements(N) eq 0 then $
		if n_elements(guess) eq 0 then N = 2 else N = n_elements(guess)

	; deal with weights and errors.  normalize weights to one.
	Nx = n_elements(x)
	if n_elements(weight) eq 0 AND n_elements(measure_errors) eq 0 then begin
		weight = make_array(Nx, type=4+double, value=ZERO) + ONE
	endif
	if n_elements(weight) eq 0 then weight = ONE / measure_errors^2 ; create weights if not already
	weight_ = weight / total(weight) ; normalize weights
	if n_elements(measure_errors) eq 0 then measure_errors = ONE/sqrt(weight_)


	if n_elements(guess) eq 0 then begin
		; must create a plausible first guess
		guess = make_array(N, type=4+double, value=ZERO)
		guess[0] = mean(y)
		if N GT 1 then guess[0:1] = linfit(x,y, double=double, measure_errors = measure_errors)
	endif

	; now perform the fit
	fit = mpfitfun('poly_func', x, y, measure_errors, guess, auto=0, _extra=_extra)

	return, fit

END


