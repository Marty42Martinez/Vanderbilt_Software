;pro AddNoise, n,option, A, nois
;        ; Computes a diagonal noise covariance matrix to C.
;        implicit none
;        integer  np, n, option, i
;        real     dQ(np), dU(np), A(3*np,3*np)
;	sigma = fltarr(n) + nois^2
;	if (option ne 0) then for i=0,n-1 do A(i,i) = A(i,i) + sigma(i)**2

;end

	pro test
	; Checks what happens for |z|=1.
;	implicit none
;	integer  llmax, lmax
;	parameter(llmax=500)
	llmax= 500

	;real     Pl2 (0:llmax), Pl0 (0:llmax)
;	real     F1l2(0:llmax), F2l2(0:llmax), F1l0(0:llmax)
	;real     z
	lmax = 100
	if (lmax gt llmax) then print,'SIZE ERROR'
	z    = 0.9999999999d

	ComputePl2, lmax,z,Pl2
	ComputePl0, lmax,z,Pl0
	ComputeF1l2, lmax,z,Pl2,F1l2
	ComputeF2l2, lmax,z,Pl2,F2l2
	ComputeF1l0, lmax,z,Pl0,F1l0
	for l=2,10 do print, l, F1l2(l), F2l2(l), F1l0(l)

	end

	pro LoadNewPixelizedMap, np,n,dir,FWHM,Q,dQ,U,dU,fname
	;NOT DONE YET!!

;	implicit none
;	integer  np, n, i
;	real     dir (3,np), ra, dec, r(3)
;	real     FWHM  (np)
;	real     Q     (np)
;	real     dQ    (np)
;	real     U     (np)
;	real     dU    (np)
;	character*80 fname
;	open (2,file=fname)
;	n=1
;555	read (2,*,end=666) ra, dec, FWHM(n), Q(n), dQ(n), U(n), dU(n)
    readcol, fname, ra, dec, fwhm, Q, dQ, U, dU, skipline = 0
	n = n_elements(ra)
	radec2vec, ra,dec,dir
;
	if (n gt np) then print, 'np SIZE ERROR'
	print, 'Number of pixels..........', np
	print, 'Loaded pixels.............', n
	end

 pro radec2vec, ra,dec,r
 ;       implicit none
  ;      real     ra, dec, phi, theta, r(3)
   ;     real     pi, dtr
    ;    pi    = 4.*atan(1.)
    ; WORKS on ARRAYS
    	r = fltarr(3,n_elements(ra))
    	if n_elements(ra) ne n_elements(dec) then print, 'N_el(ra) != n_el(dec)! Toxic death error!!'
    	dtr   = !pi/180.
        phi   = dtr*ra
        theta = dtr*(90.-dec)
        r(0,*)  = sin(theta)*cos(phi)
        r(1,*)  = sin(theta)*sin(phi)
        r(2,*)  = cos(theta)
 end

	pro NormalizeUnitVectors, n, direction
;	implicit none
;	integer  n, i, k
;	real     dot, direction(3,n)

		lengths = transpose(sqrt(total(direction^2,1))) ; array of lengths
		direction = direction/([1,1,1] # lengths)
	end

pro LoadCl, lmax,Cl,fname
; Loads in a pre-made (via CMBFAST?) Cl file
;	implicit none
;	integer  lmax, l, lread, i
;	real     Cl(4,0:lmax), pi
;	character*80 fname
;	pi = 4.*atan(1.)
	Cl = fltarr(4,lmax+1)
	readcol, fname, l, TT, EE, BB, TE, skipline = 1
	w = where(l le lmax)
	ell = l[w]
    Cl[0,ell] = TT[w]*ell*(ell+1.)/(2*!pi)
	Cl[1,ell] = EE[w]*ell*(ell+1.)/(2*!pi)
	Cl[2,ell] = BB[w]*ell*(ell+1.)/(2*!pi)
	Cl[3,ell] = TE[w]*ell*(ell+1.)/(2*!pi)

	print, 'lmax......................', lmax
	print, 'l.........................', max(l)
end

pro GetB, np,lmax,FWHM,B
;	implicit none
;	integer  np, n, lmax, i, l
;	real     FWHM(np)
;	real     B   (np,0:lmax), pi, theta
;	pi = 4.*atan(1.)
	B = fltarr(np, lmax+1)
	theta = FWHM*(!pi/180.)/sqrt(8.*alog(2.)); same length as FWHM
	l = findgen(lmax)+1 ; goes from 1 to lmax
	for i=0,np-1 do B[i,1:lmax] = exp(-0.5*l*(l+1.)*theta[i]^2)
	B[*,0] = 1.0
end