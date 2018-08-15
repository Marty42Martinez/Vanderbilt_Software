function fullmean, x, M, inverted = inverted, double=double

; x = data vector
; M = noise covariance matrix (must be invertible, and symmetric)
; inverted: if you set this, then M is the INVERSE of the covariance matrix

N = n_elements(x)
zt = fltarr(N) + 1
if keyword_set(inverted) then begin
	atninv = zt ## M
endif else begin
	atninv = zt ## invertspd(M,double=double)
endelse

norm = (1./(atninv ## transpose(zt)))[0]

return, (norm * (atninv ## x))[0]

end