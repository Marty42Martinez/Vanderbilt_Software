pro ComputeC, npix,n,lmax,dir,B,Cl,option,C
        ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
        ; Computes the *covar* matrix.

	; THIS ROUTINE is HIGHLY OPTIMIZABLE FOR IDL. CHECK if necessary.

	; Remember: option 0 => T,Q,U
	; 	    option 1 => T
	; 	    option 2 =>	  Q,U
        ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
;	implicit none
;	integer  npix, n, lmax, option, i, j, k, l, size
      ; integer  np
;	real     dir (3,npix)
;	real     C   (3*npix,3*npix)
	if option eq 0 then sz = 3 else sz = option
	C = dblarr(sz*npix,sz*npix)
;	real     Cl(4   ,0:lmax)
;	real     B (npix,0:lmax)
;	real     M (3,3), r1(3), r2(3)
	r1 = dblarr(3)
	r2 = r1
;	integer  lmaxx
	lmaxx=10000
;	real	 beam (0:lmaxx)
	if (lmax gt lmaxx) then print, 'DEATH ERROR: lmaxx too small'
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
      ; USED FOR DEBUGGING ONLY:
      ; np = 0
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
 	for i=0,0 do begin
 	   for j=0,n-1 do begin
	         r1 = double(dir(*,i))	; direction vector of pixel 1
	         r2 = double(dir(*,j))  ; 	" 		" 		"	 "  2
	      beam = double(B[i,*] * B[j,*])

	    ; print ('(999f8.4)'), (r1(l),l=1,3)
	    ; print ('(999f8.4)'), (r2(l),l=1,3)
	      Compute_PPt, lmax,Cl,beam,r1,r2,M
	    ;!;!;!;!;!;!;!;!;!;!;!;!;!
	    ; USED FOR DEBUGGING ONLY:
	    ; do k=1,3
	    ;    do l=1,3
            ;       np = np + 1
	    ;       M(k,l) = np
	    ;    end do
	    ; end do
	    ;!;!;!;!;!;!;!;!;!;!;!;!;!
	      if (option eq 0) then begin ; T,Q,U
	         for k=0,2 do for l=0,2 do C(k*n+i,l*n+j) = M(k,l)
		     ; print *, i,j,k,l,k*n+i,l*n+j,C(k*n+i,l*n+j)
		 endif

		 if (option eq 1) then begin ; T only
	         C(i,j) = M(1,1)
	       ; print *, i,j,C(i,j)
	     endif
	     if (option eq 2) then begin ; Q,U only
	         for k=0,1 do for l=0,1 do $
	               C(k*n+i,l*n+j) = M(1+k,1+l)
		     ; print *, i,j,k,l,k*n+i,l*n+j,C(k*n+i,l*n+j)
	     endif
	   endfor
	endfor
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
      ; USED FOR DEBUGGING ONLY:
      ;	print *, 'Covar matrix:'
      ;	do i=1,size
      ;	   print ('(999f10.4)'), (C(i,j),j=1,size)
      ; end do
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
end

pro Compute_PPt, lmax,Cl,beam,r1,r2,PPt
;	implicit none
;	integer  lmax
      ; integer  i, j
;	real     r1   (3), alpha1, z
;	real     r2   (3), alpha2
;	real     RR1(3,3)
;	real     RR2(3,3)
;	real     M  (3,3)
;	real     CC (3,3)
;	real     PPt(3,3)
;	real     Cl (4,0:lmax)
;	real     beam (0:lmax)
	Compute_Alphas, r1,r2,alpha1,alpha2
	Compute_MatrixAlpha, alpha1,RR1
	Compute_MatrixAlpha, alpha2,RR2
	Compute_ProdutoEscalar, r1,r2,z
	Compute_TQUcovar, lmax,z,Cl,beam,M
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
      ; USED FOR DEBUGGING ONLY:
      ; print *, 'alpha1(in deg).............', alpha1*57.2958
      ; print *, 'alpha2(in deg).............', alpha2*57.2958
      ; print *, 'z..........................', z
      ; print ('(999f8.4)'), r1
      ; print ('(999f8.4)'), r2
      ; print *, 'M   matrix:'
      ; do i=1,3
      ;    print ('(999f10.4)'), (M  (i,j),j=1,3)
      ; end do
      ;!;!;!;!;!;!;!;!;!;!;!;!;!

; HERE IS WHAT ANGELICA HAD:
	;call matmul (3,3,3,3,3,3,3,RR1,M,CC  ) ; CC  = RR1 M
	;call matmul3(3,3,3,3,3,3,3,CC,RR2,PPt) ; PPt = CC RR2^t = RR1 M RR2^t

; DO THIS THE COOL IDL WAY:
      PPt = (RR1 ## M) ## transpose(RR2)

      ;!;!;!;!;!;!;!;!;!;!;!;!;!
      ; USED FOR DEBUGGING ONLY:
      ;	print *, 'RR1 matrix:'
      ;	do i=1,3
      ;	   print ('(999f10.4)'), (RR1(i,j),j=1,3)
      ; end do
      ; print *, 'RR2 matrix:'
      ; do i=1,3
      ;    print ('(999f10.4)'), (RR2(i,j),j=1,3)
      ; end do
      ; print *, 'M   matrix:'
      ; do i=1,3
      ;    print ('(999f10.4)'), (M  (i,j),j=1,3)
      ; end do
      ; print *, 'PPt matrix:'
      ; do i=1,3
      ;    print ('(999f10.4)'), (PPt(i,j),j=1,3)
      ; end do
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
 	return
	end

pro Compute_Alphas, r1,r2,alpha1,alpha2
;	implicit none
;	real     r1(3), r2(3), r3(3), r4(3), r5(3), r(3)
;	real     alpha1, alpha2, length
;  alpha's are just scalars (i think they are angles) \\ co
 	Compute_ProdutoVetorial2, r1,r2,r3
	NormalizeUnitVector, r3,length
	if (length lt 1.e-10) then begin
	  ; r1 and r2 are either parallel or perpendicular,
	  ; so we *don't* need to do any rotations at all:
	  alpha1 = 0.
	  alpha2 = 0.
	endif else begin
	  UnitVector, r
	  Compute_ProdutoVetorial2, r,r1,r4
	  Compute_ProdutoVetorial2, r,r2,r5
	  NormalizeUnitVector, r4,length
	  if (length eq 0) then print, $
     	'DEATH ERROR: pixel at north or south pole'
	  NormalizeUnitVector, r5,length
	  if (length eq 0) then print, $
        'DEATH ERROR: pixel at north or south pole'
	  Compute1alpha, r3,r4,alpha1
	  Compute1alpha, r3,r5,alpha2
	  ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;
	  ; NOTES ABOUT THE CONFUSING ROTATION BUSINESS:
	  ; The correlations are  originally computed in a coordinate
	  ; system where the reference direction lies along the great
	  ; circle connecting the two pixels.  To rotate this "3 x 3"
	  ; covariance  matrix into the global coordinate frame where
	  ; the reference directions are the meridians,  we therefore
	  ; need to apply a **rotation matrix** corresponding to each
	  ; pixel.
	  ; 	alpha1 = amount to rotate by for pixel 1
	  ; 	alpha2 = amount to rotate by for pixel 2
	  ; Since r2 =  r1 x r2 =  -r1 x r2, we need to rotate in the
	  ; opposite direction at pixel "2" for the covariance matrix
	  ; to come out symmetric:
	  ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;
	  alpha2 = - alpha2
	endelse
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
      ; USED FOR DEBUGGING ONLY:
      ;	print ('(999f10.4)'), r1
      ;	print ('(999f10.4)'), r2
      ;	print ('(999f10.4)'), r3
      ;	print ('(999f10.4)'), r4
      ;	print ('(999f10.4)'), r5
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
	end

pro UnitVector, r
	; Unit vector in the z-direction.
;	implicit none
	r = [0.,0.,1.]
end

pro NormalizeUnitVector, r,length
;	implicit none
;	real     r(3), length
	length = sqrt(total(r^2))
	if (length ne 0.) then r = r/length
end

pro Compute_ProdutoVetorial, r1,r2,r
; Actually, this r = r1 x r2 is normalized.
;	implicit none
;	real     r1(3), r2(3), r(3), z(3), mod
	Compute_ProdutoVetorial2, r1, r2, r
	modulus = sqrt(total(r^2))
	if (abs(modulus) lt 1.e-10) then begin
	  ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	  ; **** NB:
	  ; The two pixels are aither identical or
	  ; diametrically opposite.This means that
	  ; we can pick r to be any vector that is
	  ; perpendicular to r1.
	  ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	  UnitVector, z
	  Compute_ProdutoVetorial2, r1, z, r
	  modulus = sqrt(total(r^2))
	endif
    r = r/modulus
	;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	; **** IN FACT, WE CAN MAKE IT EVEN SIMPLER:
	; if |r1 x r2| = 0, we don't need to rotate at
	; all and we can set alpha1 = alpha2 = 0.(This
	; isn't  implemented now, since accuracy seems
	; good enough anyway.)
	;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	return
	end

pro Compute_ProdutoVetorial2, r1,r2,r
	; r = r1 x r2
	;implicit none
;	real     r1(3), r2(3), r(3)
	r = r1 * 0.
	r[0] = r1[1]*r2[2] - r1[2]*r2[1]
	r[1] = r1[2]*r2[0] - r1[0]*r2[2]
	r[2] = r1[0]*r2[1] - r1[1]*r2[0]
end

pro Compute1alpha, r1,r2,alpha
;	implicit none
;	real     r1(3), r2(3), z, alpha
	Compute_ProdutoEscalar, r1, r2, z
    alpha = -acos(z)
	;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;
	; **** NB:
	; This "-" sign is needed to match the sign
	; convention used in our equations. *Alpha*
	; is defined to be  the angle by  which you
	; need to rotate Zalda's  meridian into the
	; global meridian, clockwise.
	;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;
end

pro Compute_MatrixAlpha, alpha,R ; simple 2phi rotation matrix
;	implicit none
;	real     alpha, R(3,3), cos2a, sin2a
	R = fltarr(3,3)
	cos2a  = cos(2.*alpha)
	sin2a  = sin(2.*alpha)
	R(0,0) =  1.
	R(0,1) =  0.
	R(0,2) =  0.
	R(1,0) =  0.
	R(1,1) =  cos2a
	R(1,2) =  sin2a
	R(2,0) =  0.
	R(2,1) = -sin2a
	R(2,2) =  cos2a
end

pro Compute_ProdutoEscalar, r1,r2,z ; Scalar Product of 2 vectors
;	implicit none
;	real     r1(3), r2(3), z
	z = total(r1*r2)
end

pro Compute_TQUcovar, lmax,z,Cl,beam,M
;	implicit none
;	integer  llmax, lmax
	llmax=500  ; max l value.
      ;	integer  i, j
;	real     Pl2 (0:llmax), Pl0 (0:llmax)
;	real     F1l2(0:llmax), F2l2(0:llmax), F1l0(0:llmax)
;	real     C   (0:llmax), E   (0:llmax)
;	real     B   (0:llmax), X   (0:llmax)
;	real     Cl(4,0: lmax)
;	real	 beam(0: lmax)
;	real     z, sumTT, sumQQ, sumUU, sumTQ, M(3,3)
	M = dblarr(3,3) ; M goes from 0 to 2 instead of 1-3 like Angelica does.
	if (lmax gt llmax) then print, 'CTQUc SIZE ERROR'
	CopyCl2vec, lmax,Cl,beam,C,E,B,X
	ComputePl2, lmax,z,Pl2
	ComputePl0, lmax,z,Pl0
	ComputeF1l2, lmax,z,Pl2,F1l2
	ComputeF2l2, lmax,z,Pl2,F2l2
	ComputeF1l0, lmax,z,Pl0,F1l0
	ComputeTT, lmax,Pl0,C,sumTT
	ComputeQQ, lmax,F1l2,F2l2,E,B,sumQQ
	ComputeUU, lmax,F1l2,F2l2,E,B,sumUU
    ComputeTQ, lmax,F1l0,X,sumTQ
	M(0,0) = sumTT	; TT
	M(0,1) = sumTQ	; TQ
	M(0,2) = 0.	; TU
	M(1,0) = sumTQ 	; TQ
	M(1,1) = sumQQ	; QQ
	M(1,2) = 0. 	; QU
	M(2,0) = 0.	; TU
	M(2,1) = 0. 	; QU
	M(2,2) = sumUU	; UU
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
      ; USED FOR DEBUGGING ONLY:
      ; print *, 'M   matrix inside compute_TQUcovar:'
      ; do i=1,3
      ;	   print ('(999f10.4)'), (M(i,j),j=1,3)
      ; end do
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
end

pro CopyCl2vec, lmax,Cl,beam,C,E,B,X
;	implicit none
;	integer  lmax, l
      ; integer  i
;	real     C   (0:lmax)
;	real     E   (0:lmax)
;	real     B   (0:lmax)
;	real     X   (0:lmax)
;	real     Cl(4,0:lmax)
;	real 	 beam(0:lmax)
	C = dblarr(lmax+1) & E = C & B = C & X = C
    l = findgen(lmax-1) + 1 ; goes from 2 to lmax
    C(l) = Cl(0,l)*beam(l)
    E(l) = Cl(1,l)*beam(l)
    B(l) = Cl(2,l)*beam(l)
    X(l) = Cl(3,l)*beam(l)
; if (l.lt.10) print *, (Cl(i,l),i=1,4)
end