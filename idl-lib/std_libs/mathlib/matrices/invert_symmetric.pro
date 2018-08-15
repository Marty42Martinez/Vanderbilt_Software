
FUNCTION invert_symmetric, A_

	; Invert a symmetric matrix.  For 4x4 or larger matrices,
	;	the matrix must also be positive definite, as
	;	choleski factorization is used. For 2x2 or 3x3 matrices,
	;	the direct inversion is used (from analytic formulae).
	;
	; May be an array of matrices.  The array dimension MUST be the last dimension.

    IF N_ELEMENTS(A_) EQ 1 THEN RETURN,1.0/A_
 
	sz = size(A_)
	if sz[0]  LT 2 or (sz[1] ne sz[2]) then begin
		print, 'This is not a square matrix! Quitting'
		stop
	endif

	n = sz[1]
	if sz[0] GT 2 then npix= sz[3] else npix = 1

	c = 1.
	;pseudo-normalize A just to make the eigenvalues nicer
	if npix eq 1 then A = c * A_ else begin
		A = A_
		for i = 0, n-1 do for j =0,n-1 do A[i,j,*] = c * A_[i,j,*]
	endelse

	Ainv = A*0.
	case n of
		2: begin
				idet = 1./(A[0,0,*]*A[1,1,*] - A[1,0,*]*A[0,1,*])
				Ainv[0,0,*] = idet * A[1,1,*]
				Ainv[1,1,*] = idet * A[0,0,*]
				Ainv[0,1,*] = -idet * A[0,1,*]
				Ainv[1,0,*] = Ainv[0,1,*]
			end
		3:  begin
			det = A[0,0,*]*(A[2,2,*]*A[1,1,*]-A[1,2,*]*A[2,1,*]) - $
	  		A[0,1,*]*(A[2,2,*]*A[1,0,*]-A[1,2,*]*A[2,0,*]) + $
	  		A[0,2,*]*(A[2,1,*]*A[1,0,*]-A[1,1,*]*A[2,0,*])
			idet = 1./det
			Ainv[0,0,*] = idet*(A[2,2,*]*A[1,1,*] - A[1,2,*]*A[2,1,*])
			Ainv[1,0,*] = idet*(A[1,2,*]*A[2,0,*] - A[2,2,*]*A[1,0,*])
			Ainv[2,0,*] = idet*(A[2,1,*]*A[1,0,*] - A[1,1,*]*A[2,0,*])
			Ainv[1,1,*] = idet*(A[2,2,*]*A[0,0,*] - A[0,2,*]*A[2,0,*])
			Ainv[2,1,*] = idet*(A[0,2,*]*A[1,0,*] - A[1,2,*]*A[0,0,*])
			Ainv[2,2,*] = idet*(A[1,1,*]*A[0,0,*] - A[0,1,*]*A[1,0,*])
			Ainv[0,1,*] = Ainv[1,0,*]
			Ainv[0,2,*] = Ainv[2,0,*]
			Ainv[1,2,*] = Ainv[2,1,*]
			end
		else: begin
				Ainv = A*0.
				for i = 0, npix-1 do $
					Ainv[*,*,i] = invertspd(A[*,*,i]) ; use cholesky decomposition
	  		end
	endcase


	if npix eq 1 then Ainv = c * Ainv else begin
		for i = 0, n-1 do for j =0,n-1 do Ainv[i,j,*] = c * Ainv[i,j,*]
	endelse

	return, Ainv

END




