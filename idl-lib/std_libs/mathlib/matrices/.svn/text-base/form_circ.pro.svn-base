function form_circ, ac, N, row=row

; forms an NxN circulant matrix
; keywords
;   row : set this to return only first row of the matrix

if n_params() LT 2 then N = n_elements(ac)
if keyword_set(row) then out = replicate(ac[0],N) $
					else out = replicate(ac[0],N,N)

nac = n_elements(ac)
if nac NE N then begin ; this deals with N NE Nelements(ac)
	ac_ = replicate(ac[0]*0., N)
	if nac LT N then ac_[0:nac-1] = ac else ac_ = ac[0:N-1]
endif else ac_ = ac

m = uint(N) / 2

out[0:m,0] = ac_[0:m]
out[m+1:N-1,0] = reverse(ac_[1:(N-m-1)])

; now i have the 1st row of the circulant matrix, must permute.
if not keyword_set(row) then for r = 1,N-1 do out[*,r] = shift(out[*,r-1],1) $
	else out = out[*,0] ; in this case, i just want the first row!

return, reform(out)

end