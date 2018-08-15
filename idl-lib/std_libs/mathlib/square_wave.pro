function square_wave, freq, n, samp_rate=samp_rate, offset=offset

; returns a square wave (0 to 1) of frequency "Freq", at a specifiable sampling rate,
;  with a total of n samples.

if n_elements(samp_rate) eq 0 then samp_rate = 1.0 ; the sampling rate of the output

return, even(fix((findgen(n)+1-offset)*2*freq/samp_rate))

END