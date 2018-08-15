function blockadd, M , eta

; adds the value eta to the upper left and lower right block of the (square) matrix M,
; and returns the result.

N = n_elements(M[0,*])/2

out = M
out[0:N-1,0:N-1] = out[0:N-1,0:N-1] + eta
out[N:*,N:*] = out[N:*,N:*] + eta

return, out

end