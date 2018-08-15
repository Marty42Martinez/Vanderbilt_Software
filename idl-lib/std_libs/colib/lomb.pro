pro lomb, t, tod, _extra = _extra, f, psd, oplot=oplot

; produces the lomb periodogram estimate of the power spectral density amplitude
; for unevenly sampled data.

; this program is slow and should only be used to evaluate a fairly small set of frequencies.
; (perhaps in the future I'll include the fast algorithm of Press and Rybicki, NR p81)
;
; INPUT PARAMETERS
; 	t 		: vector of sample times
;	tod		: corresponding vector of data
; 	f		: the desired evalation frequencies of the PSD
;
; OUTPUT PARAMS
;	psd 	: the psd values at the given frequencies
;
; KEYWORDS
;	_extra : for the resulting plot

w = 2*!pi*f
Nf = n_elements(f)
psd = fltarr(Nf)
todmean = mean(tod)
todvar = variance(tod)
tod_ = tod-todmean
N = n_elements(tod)

for i=0,Nf-1 do begin
	Sh = total(tod_ * sin(w[i]*t))
	Ch = total(tod_ * cos(w[i]*t))
	S2 = total(sin(2*w[i]*t))
	C2 = total(cos(2*w[i]*t))
	S2tau = S2/sqrt(S2^2 + C2^2)
	C2tau = C2/sqrt(S2^2 + C2^2)
	theta2 = Acos(C2tau)
	theta = theta2/2
	S1tau = Sin(theta)
	C1tau = Cos(theta)

	C1_ = Ch*C1tau + Sh*S1tau
	S1_ = Sh*c1tau - Ch*S1tau
	C2_ = 0.5 * (N + C2*C2tau + S2*S2tau)
	S2_ = 0.5 * (N - C2*C2tau - S2*S2tau)

	psd[i] = 0.5/todvar * ( C1_^2/C2_ + S1_^2/S2_ )
endfor

if keyword_set(oplot) then oplot, f, psd, _extra = _extra $
					  else  plot, f, psd, _extra = _extra

end

