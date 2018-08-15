FUNCTION dB2lin, data

; data is an array of dB values
; returns linear values

return, 10.^(data/10.)

END