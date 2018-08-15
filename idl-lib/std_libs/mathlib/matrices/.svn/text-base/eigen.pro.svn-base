function eigen, M_, hessenberg=hessenberg, tri=tri, symmetrize_=symmetrize_

; returns the eigenvalues of M
; M must be close to symmetric

if keyword_set(symmetrize_) then M = symmetrize(M_) else M = M_

if keyword_set(hessenberg) then begin
	evals = HQR(ELMHES(M))
	if (where(abs(imaginary(evals)) GT 1e-10))[0] then begin
		evals = real_part(evals)
		evals = evals[sort(evals)]
	endif
endif else begin
	if keyword_set(tri) then begin
		A = M
		TRIRED, A, evals, E
		TRIQL, evals, E, A
	endif else evals = eigenQL(M)
	evals = evals[sort(evals)]
endelse

return, evals

end