function invertcirc, row0

; row0: row 0 from circulant matrix

; returns : row 0 of inverse matrix


ft = real(fft(row0))

N = n_elements(row0)

return, 1./N^2 * real(fft(1/ft, /inverse))

end

