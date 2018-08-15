PRO nest2ring, nside, ipnest, ipring
;*******************************************************************************
;+
;   NEST2RING, Nside, Ipnest, Ipring
;
;         performs conversion from NESTED to RING pixel number in
;         the Healpix tesselation for a parameter Nside
;
;   INPUT :
;     Nside  : determines the resolution (Npix = 12* Nside^2)
;         should be a power of 2 (not tested)
;	  SCALAR
;     Ipnest : pixel number in the NEST scheme of Healpix pixelisation in [0,Npix-1]
;	can be an ARRAY
;
;   OUTPUT :
;     Ipring : pixel number in the RING scheme of Healpix pixelisation in [0,Npix-1]
;	is an ARRAY of same size as Ipnest
;
;
; HISTORY
;    Feb 1999,           Eric Hivon,               Caltech
;
;-
;*******************************************************************************

;   coordinate of the lowest corner of each face
  jrll = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4] ; in unit of nside
  jpll = [1, 3, 5, 7, 0, 2, 4, 6, 1, 3, 5, 7] ; in unit of nside/2

  ns_max = 8192L

  if N_params() ne 3 then begin
      print,' syntax = nest2ring, nside, ipnest, ipring'
      stop
  endif

  if (N_ELEMENTS(nside) GT 1) then begin
      print,'nside should be a scalar in NEST2RING'
      stop
  endif
  if (nside lt 1) or (nside gt ns_max) then stop, 'nside out of range'

  nside = LONG(nside)
  ncap = 2L*nside*(nside-1L)
  nl3  = 3L*nside
  nl4  = 4L*nside
  npface = nside*LONG(nside)
  npix = 12L * npface
  np = N_ELEMENTS(ipnest)

  min_pix = MIN(ipnest)
  max_pix = MAX(ipnest)
  IF (min_pix LT 0) THEN BEGIN
      PRINT,'pixel index : ',min_pix,FORMAT='(A,I10)'
      PRINT,'is out of range : ',0,npix-1,FORMAT='(A,I2,I8)'
      RETURN
  ENDIF
  IF (max_pix GT npix-1) THEN BEGIN
      PRINT,'pixel index : ',max_pix,FORMAT='(A,I10)'
      PRINT,'is out of range : ',0,npix-1,FORMAT='(A,I2,I8)'
      RETURN
  ENDIF

;     initiates the array for the pixel number -> (x,y) mapping
  common pix2xy, pix2x, pix2y
  sz = size(pix2x)
  if (sz(sz(0)+1) eq 0) then init_pix2xy ; initiate pix2x and pix2y

;     finds the face, and the number in the face
  face_num = ipnest/npface      ; face number in {0,11}
  ipf = ipnest MOD npface       ; pixel number in the face {0,npface-1}

;     finds the x,y on the face (starting from the lowest corner)
;     from the pixel number
  ip_low = ipf MOD 1024         ; content of the last 10 bits
  ip_trunc =   ipf/1024         ; truncation of the last 10 bits
  ipf = 0                       ; free memory
  ip_med = ip_trunc MOD 1024    ; content of the next 10 bits
  ip_hi  =     ip_trunc/1024    ; content of the high weight 10 bits
  ip_trunc = 0                  ; free memory

;     computes (x,y) coordinates on the face
  ix = 1024*pix2x(ip_hi) + 32*pix2x(ip_med) + pix2x(ip_low)
  iy = 1024*pix2y(ip_hi) + 32*pix2y(ip_med) + pix2y(ip_low)
  ip_hi = 0 & ip_med = 0 & ip_low = 0 ; free memory
  
;     transforms this in (horizontal, vertical) coordinates
  jrt = ix + iy                 ; 'vertical' in {0,2*(nside-1)}
  jpt = ix - iy                 ; 'horizontal' in {-nside+1,nside-1}
  ix = 0 & iy = 0               ; free memory

;     computes the z coordinate on the sphere
  jr =  jrll(face_num)*nside - jrt - 1 ; ring number in {1,4*nside-1}
  jrt = 0                       ; free memory

  pix_npl = WHERE( jr LT nside, n_npl) ; north pole
  pix_spl = WHERE( jr GT nl3,   n_spl) ; south pole
  pix_eqt = WHERE( jr GE nside AND jr Le nl3, n_eqt) ; equatorial region
  IF (n_npl + n_spl + n_eqt) NE np THEN STOP, 'STOP, error in nest2ring'
  nr       = INTARR(np)
  n_before = LONARR(np)
  kshift   = BYTARR(np)

  IF (n_eqt GT 0) THEN BEGIN   ; equatorial region 
      nr(pix_eqt)       = nside
      n_before(pix_eqt) = ncap + nl4 * (jr(pix_eqt) - nside)
      kshift(pix_eqt)   = (jr(pix_eqt) - nside) MOD  2
  ENDIF
  IF (n_npl GT 0) THEN BEGIN    ; north pole region
      nr(pix_npl) = jr(pix_npl)
      n_before(pix_npl) = 2L * nr(pix_npl) * (nr(pix_npl) - 1L)
      kshift(pix_npl) = 0
  ENDIF
  IF (n_spl GT 0) THEN BEGIN    ; south pole region
      nr(pix_spl) = nl4 - jr(pix_spl)
      n_before(pix_spl) = npix - 2L * (nr(pix_spl) + 1L) * nr(pix_spl)
      kshift(pix_spl) = 0
  ENDIF

;     computes the phi coordinate on the sphere, in [0,2Pi]
  jp = (jpll(face_num)*LONG(nr) + jpt + 1 + kshift)/2  ; 'phi' number in the ring in {1,4*nr}

  jp = jp - nl4*(jp GT nl4)
  jp = jp + nl4*(jp LT 1)

  ipring = n_before + jp - 1L ; in {0, npix-1}

  RETURN
END      ; nest2ring

;=======================================================================
; The permission to use and copy this software and its documentation, 
; without fee or royalty is limited to non-commercial purposes related to 
; Boomerang, Microwave Anisotropy Probe (MAP) and
; PLANCK Surveyor projects and provided that you agree to comply with
; the following copyright notice and statements,
; and that the same appear on ALL copies of the software and documentation.
;
; An appropriate acknowledgement has to be included in any
; publications based on work where the package has been used
; and a reference to the homepage http://www.tac.dk/~healpix
; should be included
;
; Copyright 1997 by Eric Hivon and Kris Gorski.
;  All rights reserved.
;=======================================================================
