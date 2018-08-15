function noise, tod,  frange=frange, onephi=onephi, twophi=twophi, samp_rate=samp_rate, $
		print=print,_extra=_extra
; returns the noise in Volts / sqrt(Hz)

if not keyword_set(frange) then frange=[1.0,3.0] ; freq range over which to average
if keyword_set(onephi) then frange=[0.031,0.034]
if keyword_set(twophi) then frange=[0.062,0.068]

copsd, tod, psdarr, f, /nograph, samp_rate = samp_rate, _extra = _extra

Nb= n_elements(f) * 2.

n_ = n_elements(psdarr)
f0 = round(frange[0] * Nb/samp_rate)
if f0 LT 0 then f0 = 0
if n_elements(frange) eq 1 then f1 = f0 else begin
	f1 = round(frange[1] * Nb/samp_rate)
	if f1 GT n_-1 then f1 = n_ - 1
endelse

if keyword_set(print) then begin
	print,((total(tod^2))/N)       ; print time-power integral
	print,(mean(psdarr^2)*samp_rate/2.)  ; print integral of PSD
	print, f0, f1
endif
if (f0 eq f1) then return, psdarr[f0] else return, mean(psdarr[f0:f1])

END