PRO pix2vec_nest, nside, ipix, vec_out
;************************************************************************************
;+
; PIX2VEC_NEST, Nside, Ipix, Vec_out
;
;       renders cartesian coordinates Vec_out of the nominal pixel center
;       given the NESTED scheme pixel number Ipix and map resolution parameter Nside
;
; INPUT
;    Nside     : determines the resolution (Npix = 12* Nside^2)
;       should be a power of 2 (not tested)
;	SCALAR
;    Ipix  : pixel number in the NEST scheme of Healpix pixelisation in [0,Npix-1]
;	can be an ARRAY of size (np) 
;
; OUTPUT
;    Vec_out : (x,y,z) position unit vector(s) with North pole = (0,0,1)
;       stored as x(0), x(1), ..., y(0), y(1), ..., z(0), z(1) ..
;       is an ARRAY of dimension (np,3)
;
; HISTORY
;    June-October 1997,  Eric Hivon & Kris Gorski, TAC : pix_ang
;    Feb 1999,           Eric Hivon,               Caltech
;    March 1999,         EH
;         correction of an error when all pixels are in the same
;         regime (eg. equatorial)
;
;-
;*****************************************************************************

;   coordinate of the lowest corner of each face
  jrll = [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4] ; in unit of nside
  jpll = [1, 3, 5, 7, 0, 2, 4, 6, 1, 3, 5, 7] ; in unit of nside/2

  ns_max = 8192L

  if N_params() ne 3 then begin
      print,' syntax = pix2vec_nest, nside, ipix, vec'
      stop
  endif

  if (N_ELEMENTS(nside) GT 1) then begin
      print,'nside should be a scalar in ang_pix'
      stop
  endif
  if (nside lt 1) or (nside gt ns_max) then stop, 'nside out of range'

  nside = LONG(nside)
  nl2 = 2L*nside
  nl3 = 3L*nside
  nl4 = 4L*nside
  npix = nl3*nl4
  npface = nside * nside
  np = N_ELEMENTS(ipix)
  fn = DOUBLE(nside)
  fact1 = 1.d0/(3.d0*fn*fn)
  fact2 = 2.d0/(3.d0*fn)
  piover2 = !DPI / 2.d0

  min_pix = MIN(ipix)
  max_pix = MAX(ipix)
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
  face_num = ipix/npface        ; face number in {0,11}
  ipf = ipix MOD npface         ; pixel number in the face {0,npface-1}

;     finds the x,y on the face (starting from the lowest corner)
;     from the pixel number
  ip_low = ipf MOD 1024         ; content of the last 10 bits
  ip_trunc =   ipf/1024         ; truncation of the last 10 bits
  ipf = 0                       ; free memory
  ip_med = ip_trunc MOD 1024    ; content of the next 10 bits
  ip_hi  =     ip_trunc/1024    ; content of the high weight 10 bits
  ip_trunc = 0                  ; free memory

;   computes (x,y) coordinates on the face
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
  IF (n_npl + n_spl + n_eqt) NE np THEN STOP, 'STOP, error in pix2vec_nest'
  nr     = INTARR(np)
  kshift = BYTARR(np)

  IF (n_eqt GT 0) THEN BEGIN   ; equatorial region 
      nr(pix_eqt)     = nside
      z_eqt           = (nl2-jr(pix_eqt))*fact2
      sz_eqt          = SQRT(1.d0 - z_eqt^2)
      kshift(pix_eqt) = (jr(pix_eqt) - nside) MOD 2
  ENDIF
  IF (n_npl GT 0) THEN BEGIN   ; north pole region
      nr(pix_npl)     = jr(pix_npl)
      z_npl           = 1.d0 - LONG(nr(pix_npl))^2 * fact1
      sz_npl          = SQRT(1.d0 - z_npl^2)
      kshift(pix_npl) = 0
  ENDIF
  IF (n_spl GT 0) THEN BEGIN   ; south pole region
      nr(pix_spl)     = nl4 - jr(pix_spl)
      z_spl           = -1.d0 + LONG(nr(pix_spl))^2 * fact1
      sz_spl          = SQRT(1.d0 - z_spl^2)
      kshift(pix_spl) = 0
  ENDIF

;     computes the phi coordinate on the sphere, in [0,2Pi]
  jp = (jpll(face_num)*LONG(nr) + jpt + 1 + kshift)/2 ; 'phi' number in the ring in {1,4*nr}
  jpt = 0  & face_num = 0         ; free memory
  jp = jp - nl4 * (jp GT nl4)
  jp = jp + nl4 * (jp LT 1)

  vec_out = DBLARR(np, 3)
  if (n_eqt GT 0) then begin
      vec_out(pix_eqt,0) = sz_eqt & vec_out(pix_eqt,1) = sz_eqt & vec_out(pix_eqt,2) = z_eqt
  endif
  if (n_npl GT 0) then begin
      vec_out(pix_npl,0) = sz_npl & vec_out(pix_npl,1) = sz_npl & vec_out(pix_npl,2) = z_npl
  endif
  if (n_spl GT 0) then begin
      vec_out(pix_spl,0) = sz_spl & vec_out(pix_spl,1) = sz_spl & vec_out(pix_spl,2) = z_spl
  endif
  
  vec_out(*,0) = vec_out(*,0) * COS( (jp - (kshift+1)*0.5d0) * (piover2 / nr) )
  vec_out(*,1) = vec_out(*,1) * SIN( (jp - (kshift+1)*0.5d0) * (piover2 / nr) )
  jp = 0 & kshift = 0 & nr = 0

  return
end ; pix2vec_nest

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
