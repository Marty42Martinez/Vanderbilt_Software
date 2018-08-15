function circmult, r1, r2

; r1: row 0 from first circulant matrix
; r2: row 0 from second circ matrix

; returns : row 0 of mult matrix

;r = r1*0.
;n = n_elements(r1)
;for i = 0,n-1 do r[i] = total(r1 * shift(r2,i))
;return, r
;goto, endplace
;end
ft1 = fft(r1)
ft2 = fft(r2)
N = n_elements(r1)
return, N * real(fft(ft1*ft2, /inverse))

endplace:
end

