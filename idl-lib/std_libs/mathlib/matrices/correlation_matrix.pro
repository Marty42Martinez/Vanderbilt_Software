function Correlation_matrix, c

; C is the correlation vector of length N.
; Return the matrix that is N by N that is the proper
; Correlation matrix.

	N = n_elements(C)
	M = C # C
	rc = (reverse(c[1:*]))
	for r = 1, N-1 do begin
		M[r:*, r] = c[0:(N-r-1)]
		M[0:(r-1), r] = rc[(N-r-1):(N-2)]
	endfor

	return, M
END

