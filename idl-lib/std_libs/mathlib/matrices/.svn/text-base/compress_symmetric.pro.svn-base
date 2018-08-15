function compress_symmetric, S
; take a symmetric NxN matrix, S; store it in a vector with N*(N+1)/2 elements.
; S can look like this: fltarr(N, N, n1,n2,n3...) . First 2 dimensions are the square matrices.
; V will look like this: fltarr(nv, n1,n2,n3...).  First dimension is the compressed matrix.

	sz = size(S)
    n = sz[1]
    nextra = n_elements(S)/(sz[1]*sz[2])
    if sz[0] GT 3 then S = reform(S, sz[1], sz[2], nextra, /over)

    nv = n*(n+1)/2
    v = bytarr(nv,nextra) + 0b * S[0]
    for i=0, n-1 do v[i,*] = S[i,i,*] ; set diagonal elements
    c = n
    for r=1,n-1 do begin
        v[c:c+(r-1),*] = S[r,0:(r-1),*]
        c = c+r
    endfor

	if sz[0] GT 3 then begin
		v = reform(v, [nv, sz[3:sz[0]]], /over)
		S = reform(S, sz[1:sz[0]], /over)
	endif
    return, v
end

