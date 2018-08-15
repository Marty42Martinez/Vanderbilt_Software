function convert_covar, S, reverse=reverse

; Takes a symmetric, positive-definite covariance matrix S
; and converts the diagonal elements to their square roots,
; and their off-diagonal elements to correlation coefficients.

; If keyword REVERSE is set, then this procedure reverses the above
; process.

; S is of the form S[n,n,*]

sz = size(S)
out = S*0.
n = sz[1]
if ~keyword_set(reverse) then begin
	for i = 0,n-1 do out[i,i,*] = sqrt(S[i,i,*])
	for i = 0, n-2 do for j = i+1, n-1 do begin
		out[j,i,*] = S[j,i,*] / (out[i,i,*] * out[j,j,*])
		out[i,j,*] = out[j,i,*]
	endfor
endif else begin
	for i = 0, n-2 do for j = i+1, n-1 do begin
		out[j,i,*] = S[j,i,*] * (S[i,i,*] * S[j,j,*])
		out[i,j,*] = out[j,i,*]
	endfor
	for i = 0,n-1 do out[i,i,*] = S[i,i,*]^2
endelse

return, out

END
