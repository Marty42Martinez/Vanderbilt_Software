PRO pix2vec_ring, nside, ipix, vec_out
;*******************************************************************************
;+
; PIX2VEC_RING, Nside, Ipix, Vec_out
; 
;       renders cartesian coordinates Vec_out of the nominal pixel center
;       given the RING scheme pixel number Ipix and map resolution parameter Nside
;
; INPUT
;    Nside     : determines the resolution (Npix = 12* Nside^2)
;	SCALAR
;    Ipix  : pixel number in the RING scheme of Healpix pixelisation in [0,Npix-1]
;	can be an ARRAY of size (np) 
;       pixels are numbered along parallels (ascending phi), 
;       and parallels are numbered from north pole to south pole (ascending theta)
;
; OUTPUT
;    Vec_out : (x,y,z) position unit vector(s) with North pole = (0,0,1)
;       stored as x(0), x(1), ..., y(0), y(1), ..., z(0), z(1) ..
;       is an ARRAY of dimension (np,3)
;
; HISTORY
;    June-October 1997,  Eric Hivon & Kris Gorski, TAC : pix_ang
;    Feb 1999,           Eric Hivon,               Caltech
;
;-
;*******************************************************************************

ns_max = 8192L
if N_params() ne 3 then begin
    print,' syntax = pix2vec_ring, nside, ipix, vec'
    stop
endif

if (N_ELEMENTS(nside) GT 1) then begin
	print,'nside should be a scalar in pix2vec_ring'
	stop
endif
if (nside lt 1) or (nside gt ns_max) then stop, 'nside out of range'

nside = LONG(nside)
nl2 = 2*nside
nl3 = 3*nside
nl4 = 4*nside
npix = nl3*nl4
ncap = nl2*(nside-1L)
nsup = nl2*(5L*nside+1L)
fact1 = 1.5d0*nside
fact2 = (3.d0*nside)*nside
np = N_ELEMENTS(ipix)
vec_out = DBLARR(np,3)

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

pix_np = WHERE(ipix LT ncap,   n_np)   ; north polar cap
pix_eq = WHERE(ipix GE ncap AND ipix LT nsup,  n_eq) ; equatorial strip
pix_sp = WHERE(ipix GE nsup,   n_sp)   ; south polar cap
if ((n_np + n_eq + n_sp) NE np ) then stop,'STOP :  pix2vec_ring'

IF (n_np GT 0) THEN BEGIN ; north polar cap ; ---------------------------------

   ip = ipix(pix_np) + 1
   iring = LONG( SQRT( ip/2.d0 - SQRT(ip/2) ) ) + 1L ; counted from NORTH pole
   iphi  = ip - 2L*iring*(iring-1L)

   phi   = (iphi - 0.5d0) * !DPI/(2.d0*iring)
   z = 1.d0 - iring^2 / fact2 
   sz = SQRT(1.d0 - z*z)
   vec_out(pix_np,2) = z
   vec_out(pix_np,1) = sz * SIN( phi )
   vec_out(pix_np,0) = sz * COS( phi )

ENDIF ; ------------------------------------------------------------------------

IF (n_eq GT 0) THEN BEGIN ; equatorial strip ; ---------------------------------

   ip    = ipix(pix_eq) - ncap
   iring = LONG( ip / nl4) + nside                        ; counted from NORTH pole
   iphi  = ( ip MOD nl4 )  + 1

   fodd  = 0.5d0 * (1 + ((iring+nside) MOD 2)) ; 1 if iring is odd, 1/2 otherwise

   phi   = (iphi - fodd) * !DPI/(2.d0*nside)
   z = (nl2 - iring) / fact1 
   sz = SQRT(1.d0 - z*z)
   vec_out(pix_eq,2) = z
   vec_out(pix_eq,1) = sz * SIN( phi )
   vec_out(pix_eq,0) = sz * COS( phi )

ENDIF ; ------------------------------------------------------------------------

IF (n_sp GT 0) THEN BEGIN ; south polar cap ; ---------------------------------

   ip =  npix - ipix(pix_sp)
   iring = LONG( SQRT( ip/2.d0 - SQRT(ip/2) ) ) + 1      ; counted from SOUTH pole
   iphi  = 4*iring + 1 - (ip - 2L*iring*(iring-1L))
   
   phi   = (iphi - 0.5d0) * !DPI/(2.d0*iring)
   z = - 1.d0 + iring^2 / fact2 
   sz = SQRT(1.d0 - z*z)
   vec_out(pix_sp,2) = z
   vec_out(pix_sp,1) = sz * SIN( phi )
   vec_out(pix_sp,0) = sz * COS( phi )

ENDIF ; ------------------------------------------------------------------------


RETURN
END

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
