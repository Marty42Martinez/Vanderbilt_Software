function expand_symmetric, v

	sv = size(v)
    nv = sv[1]
    n = (sqrt(1 + 8*nv)-1)/2.
    if fix(n) ne n then print, 'Vector is not a valid compressed symmetric matrix!'

	nextra = n_elements(v) / nv
	if sv[0] GT 2 then v = reform(v, sv[1], nextra, /over)

    S = bytarr(n,n,nextra) + 0b*v[0]
    for i = 0, n-1 do S[i,i,*] = v[i,*]
    c = n
    for r = 1, n-1 do begin
        S[r,0:(r-1),*] = v[c:c+(r-1),*]
        S[0:(r-1),r,*] = v[c:c+(r-1),*]
        c = c+r
    endfor

	if sv[0] GT 2 then begin
		S = reform(S, [n,n, sv[2:sv[0]]] , /over)
		v = reform(v, sv[1:sv[0]], /over)
	endif
    return, S
end