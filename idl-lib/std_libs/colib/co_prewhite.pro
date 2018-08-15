function co_prewhite, y, sigma, filter=filter, knee = knee, nomean=nomean, Ntrue=Ntrue, diagonal=diagonal

; fit for power spectrum in fourier space, fitting for 1/f but that's it.
;
; form your filter, H(f) = sqrt(f/(f+fknee))
;
; C = fft(H)  this is your time-domain filter
;
; form D from C, always centering it on the diagonal and making it time-symmetric
;
; return the final filter matrix D which is D ## D0 (D0 removes the mean!)
; y' = D y

KNEE_MIN = 0.002 ; less than this and I declare you white

N = n_elements(y)
copsd_old, y, nbins = 1, psd, f, /nograph, samp=1.0
if n_elements(knee) eq 0 then begin ; find 1/f knee
	model = fit_1f2(f[1:*], psd[1:*]^2, /double, yfit=yfit2, /quiet)
	knee = model[1]
;	print, knee
	if n_elements(sigma) ne 0 then begin
		if knee ne 0 then begin
			Ntrue = make_Ntrue(sigma, knee, samp=1.0)
		endif else Ntrue = diag(sigma^2)
	endif
endif


if knee ge KNEE_MIN then begin
	W = sqrt(f/(f+knee))
	W = [W,reverse(W)]
	C = fft(W,/inverse)
	C = float(C)
	C = C/C[0] * total(W)/N  ; normalization
	C = C[0:N/2]
	diagonal = 0
endif else begin
	C = dblarr(N/2+1)
	C[0] = 1.0
	diagonal = 1
endelse

if keyword_set(nomean) then begin ; kill mean if desired
	I0 = fltarr(N,N) + 1.0
	D0 = (identity(N) - 1./N*I0)
	if keyword_set(filter) then out = form_N(c,N) ## D0 else out = form_N(c,N) ## (D0 ## y)
endif else begin
	if keyword_set(filter) then out = form_N(c, N) else out = form_N(c,N) ## y
endelse

return, out
end