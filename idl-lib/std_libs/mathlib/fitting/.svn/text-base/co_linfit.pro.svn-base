function co_linfit, x, y, xerr, yerr, covar=covar, outx=outx, error=error

; Optimal estimation for a linear fit in which both x and y have errors.
; return value is the values for the 2 fit paramaters P = [P[0], P[1]]
; such that
; y = P[0] + P[1] * x
;
; x, y, xerr, yerr must all be 1D arrays with the same number of elements.

m = n_elements(y)

; p : the fitted parameters


; SET UP INITIAL VALUES OF THINGS
wx = 1./xerr^2
Sainv = diag(wx)
w = 1./yerr^2 ; just what it looks like
p = fltarr(2+m) ; the retrieved vector

p0 = fit_poly(y, x, meas_err=yerr) ; get the first guess
p[0:1] = p0
p[2:*] = x

i = 0
KtSyinv = fltarr(m, 2+m)
Sinv = fltarr(2,2)
S = Sinv
print, 0, p0
repeat begin
	KtSyinv[*,0] = w
	KtSyinv[*,1] = p[2:*] * w
	KtSyinv[*,2:*] = diag(p[1]*w)

	Sinv[0,0] = total(w)
	Sinv[1,0] = total(w * p[2:*])
	Sinv[0,1] = Sinv[1,0]
	Sinv[1,1] = total(w * p[2:*]^2)
;	Sinv[2:*, 0] = w*0.
;	Sinv[2:*, 1] = p[2:*]*w*0.
;	Sinv[0, 2:*] = Sinv[2:*, 0]

;	Sinv[1, 2:*] = Sinv[2:*, 1]
;	Sinv[2:*, 2:*] = Sainv + diag(p[1]*p[1]*w)

	fx = p[0] + p[2:*] * p[1]
	dp = KtSyinv ## transpose(y-fx)
	dp[2:*] = dp[2:*] + wx *  (x - p[2:*])
	dp = transpose(dp)

  ; now let us use the Choleski Decomposition Method!
	S[0:1, 0:1] = invert_symmetric(Sinv[0:1, 0:1])
;	S[2:*, 2:*] = diag(1./(p[1]^2*w + wx))
;	dp = transpose( S ## transpose(dp) )
	dp[0:1] = S[0:1,0:1] ## transpose(dp[0:1])
	dp[2:*] = 1./(p[1]^2*w + wx) * dp[2:*]
	p = p + dp ; iterate
	i = i+1

print, i, p[0:1], dp[0:1], format = '(i5, 4f10.4)'
endrep until (i eq 40)

if keyword_set(error) then begin
; compute final covariance matrix
	Sinv[0,0] = total(w)
	Sinv[1,0] = total(w * p[2:*])
	Sinv[0,1] = Sinv[1,0]
	Sinv[1,1] = total(w * p[2:*]^2)
	Sinv[2:*, 0] = w
	Sinv[0, 2:*] = Sinv[2:*, 0]
	Sinv[2:*, 1] = p[2:*]*w
	Sinv[1, 2:*] = Sinv[2:*, 1]
	Sinv[2:*, 2:*] = Sainv + diag(p[1]*p[1]*w)
	S = invertspd(Sinv)
	covar = S[0:1, 0:1]
endif

outx = p[2:*]
p = p[0:1]


return, p

END



; little testing routine
n = 100
slope =  3.0
offset = 2.0
xerror = 1.0
yerror = 1.0 + xerror*0.

xtrue = findgen(n)*5. / (n-1)
xerr = randomn(seed, n) * xerror ;realized x errors
xmeas = xtrue + xerr ; actual measured values of x

ytrue = xtrue * slope + offset
yerr = randomn(seed,n)* yerror ;realized y errors
ymeas = ytrue + yerr; actual measured values of y

;fitco= co_linfit(xmeas, ymeas, xerror+fltarr(n), yerror+fltarr(n),  outx=xco )
fit = linfit_xy(xmeas, ymeas, xerror, yerror, covar=covar, /get, outx=xret, rev=1)
print, fit
fit = linfit_xy(xmeas, ymeas, xerror, yerror, covar=covar, /get, outx=xret, rev=1, /approx)
print, fit

;fit = linfit_xy(xmeas, ymeas, xerror, yerror, covar=covar, /get, outx=xret, rev=0, /approx)
;print, fit


;regfit = fit_poly(ymeas, xmeas, meas_err = yerror, /err, covar=rcov)

END