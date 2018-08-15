function simpleL_co, x, cov, delta, eta = eta, svd=svd, double=double,$
				diagonal=diagonal,fwhm=fwhm,pixels=pixels,npix=npix

; Returns the liklihood L of data vector x and covariance matrix:
;
; C = Cth + Cdat  (where Cth = delta^2 * Identity Matrix)
; this is about the simplest of all liklihoods
; normalizes to the maximum liklihood

; nomean : if you set this, I'll make up the appropriate PI matrix, and use it!

if n_elements(eta) eq 0 then eta = 1.
if n_elements(fwhm) eq 0 then fwhm = 7.0
if n_elements(npix) eq 0 then npix = 360

Nd = n_elements(delta)
logL = dblarr(Nd)

N = n_elements(x)
if n_elements(pixels) eq 0 then pixels = indgen(N)

fullcov = beamcov1D(fwhm,npix)
Cth = matrix_extract(fullcov, pixels)

; Now we have Cdat and Cth!  Can calculate liklihoods now.

for i=0,Nd-1 do begin
	;if v then print, 'delta = ', i
	A = cov + delta[i]^2 * Cth
	if not keyword_set(diagonal) then begin
	if not keyword_set(svd) then begin

	choldc, A, p, double=double ; now the lower triangle of A contains the lower triangle of L
										 ; p is the diagonal of L
	logdetsqM = total(alog(p)) ; this is the log of sqrt of the determinant of M (trace of log(L))
	y = cholsol(A,p,x, double=double)
	yyt = total(y*x)

	endif else begin
		; do it the SVD way!
		SVDC, A, D, Mu, Mv, /double
		logdetsqM = total(alog(sqrt(D)))
		y = reform(Mu # x) * 1./sqrt(D)
		yyt = total(y^2)
	endelse
	endif else begin ; DIAGONAL -- EASY
		errs = sqrt(get_diag(A))
		yyt = total(x^2 /errs^2)
		logdetsqM = total(alog(errs))
	endelse
	logL[i] = -0.5 * yyt - logdetsqM
endfor

if n_elements(logL) eq 1 then logL = logL[0]

M = max(logL)
maxL = delta[where( logL eq M)]
L = exp(logL-max(logL))
;if v then print, '95% confidence Lim = ', confidencelimit(L, 0.95)

return, L

end