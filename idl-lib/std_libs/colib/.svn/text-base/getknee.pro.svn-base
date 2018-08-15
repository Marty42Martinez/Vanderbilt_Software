function getknee, y , _extra = _extra

; Returns the "1/f Knee" of the given data

; psd - array containing the psd
; f	  - array containing the corresponding frequencies
; frange - [fa,fb] containing the start and end floor frequency

; assumes the f's are sorted least to greatest.
; assumes there is a floor.
; if I can't find a reasonable knee, a value of -1 is returned.

copsd, y, psd, f, /nograph, _extra = _extra
model = fit_1f2(f[1:200], psd[1:200]^2, /double, /quiet)
fknee = model[1]/model[0]

return, fknee

end