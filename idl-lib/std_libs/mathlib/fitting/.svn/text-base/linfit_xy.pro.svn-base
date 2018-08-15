function linfit_xy, xin, yin, xerr, yerr, reversed = reversed, $
	get_covar=get_covar, covar=covar, outx=outx, approx=approx
; xin, yin: measured data
; xerr, yerr; 1-sigma error on each x,y point (MUST BE CONSTANT)
; reversed: set this keyword to compute the slope,offset in the reversed (x=g(y)) space.
;        otherwise, program will attempt to figure out best space to compute this in.
a = 0.
b = 0.
max_delta = 1e-5
max_iter = 200
N = n_elements(xin)
fit = fltarr(max_iter, 2)

fit0 = linfit(xin,yin) ; test fit
fit1 = linfit(yin,xin)
atest = mean([fit0[1], 1./fit1[1]])
fact = atest * xerr/yerr
;print, 'FACT = ', fact
if n_elements(reversed) gt 0 then fact = 100*reversed[0]
if fact GT 1 then begin
    xa = yin
    y = xin
    dx2 = 1./yerr^2
    dy2 = 1./xerr^2
    reversed = 1
endif else begin
    xa = xin
    y = yin
    dx2 = 1./(xerr*xerr)
    dy2 = 1./(yerr*yerr)
    reversed = 0
endelse
x = xa
ybar = total(y)/N
iter = 0

chi_sq = 100.
repeat begin
    last_a = a
    last_b = b
    last_chi = chi_sq ;
    xy = total(x*y) / N
    x2 = total(x*x) / N
    xbar = total(x) / N
    sigx2 = x2 - xbar*xbar

    b = (ybar*x2 - xbar*xy)/sigx2
    a = (xy - xbar*ybar)/sigx2
    x = ( a*dy2*(y-b) + dx2 * xa)/(dy2*a^2 + dx2)
    iter = iter + 1
    delta = 2*max([abs(a-last_a)/abs(a+last_a),abs(b-last_b)/abs(b+last_b)])
    chi_sq = (total( (y-a*x-b)^2 ) * dy2 + total((x-xa)^2) * dx2)/N ; reduced chi squared
    ;delta = abs(chi_sq-last_chi)/abs(chi_sq+last_chi) * 2.

    fit[iter-1,*] = [b,a]

endrep until (iter eq max_iter OR delta LT max_delta)
  print, iter, a, b, chi_sq
if reversed then begin
    a = 1/a
    b = -b * a

	; get updated x vector
    x = ( a*(yin-b)/yerr^2 + xin/xerr^2 )/(a^2/yerr^2 + 1/xerr^2)
endif

if keyword_set(get_covar) then begin
	w = 1/yerr^2
; compute final covariance matrix
	Sinv = fltarr(N+2, N+2)
	Sinv[0,0] = N*w
	Sinv[1,0] = total(x) * w
	Sinv[0,1] = Sinv[1,0]
	Sinv[1,1] = total(x^2) * w
	if keyword_set(approx) then covar = invertspd(Sinv[0:1, 0:1]) else begin
		Sinv[2:*, 0] = w
		Sinv[0, 2:*] = Sinv[2:*, 0]
		Sinv[2:*, 1] = x*w
		Sinv[1, 2:*] = Sinv[2:*, 1]
		Sinv[2:*, 2:*] = diag(a*a*w + fltarr(N) + 1./xerr^2)
		S = invertspd(Sinv)
		covar = S[0:1, 0:1]
	endelse
	; conver to fit errors on slope and offset, as well as correlation
	; between slope error and offset error
	cmatrix = covar
	cmatrix[0,0] = sqrt(covar[0,0])
	cmatrix[1,1] = sqrt(covar[1,1])
	cmatrix[0,1] = covar[0,1] / (cmatrix[0,0]*cmatrix[1,1])
	cmatrix[1,0] = cmatrix[0,1]
	print
	print, cmatrix
endif

outx = temporary(x)

return, [b,a]

END