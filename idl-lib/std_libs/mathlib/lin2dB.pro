FUNCTION lin2dB, data

; data is an array ofvalues
; returns relative dB values

return, 10.* alog10(data)

END