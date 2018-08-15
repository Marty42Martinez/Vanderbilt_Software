PRO pix2ang_ring, nside, ipix, theta, phi
;****************************************************************************************
;+
; PIX2ANG_RING, nside, ipix, theta, phi
; 
;       renders Theta and Phi coordinates of the nominal pixel center
;       given the RING scheme pixel number Ipix and map resolution parameter Nside
;
; INPUT
;    Nside     : determines the resolution (Npix = 12* Nside^2)
;	SCALAR
;    Ipix  : pixel number in the RING scheme of Healpix pixelisation in [0,Npix-1]
;	can be an ARRAY 
;       pixels are numbered along parallels (ascending phi), 
;       and parallels are numbered from north pole to south pole (ascending theta)
;
; OUTPUT
;    Theta : angle (along meridian = co-latitude), in [0,Pi], theta=0 : north pole,
;	is an ARRAY of same size as Ipix
;    Phi   : angle (along parallel = azimut), in [0,2*Pi]
;	is an ARRAY of same size as Ipix
;
; HISTORY
;    June-October 1997,  Eric Hivon & Kris Gorski, TAC
;    Aug  1997 : treats correctly the case nside = 1
;    Feb 1999,           Eric Hivon,               Caltech
;         renamed pix2ang_ring
;
;-
;****************************************************************************************
ns_max = 8192L

if (N_ELEMENTS(nside) GT 1) then begin
    print,'nside should be a scalar in pix2ang_ring'
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
theta = DBLARR(np)
phi   = DBLARR(np)

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
IF (n_np + n_sp + n_eq) NE np THEN STOP, 'STOP, error in nest_ring'

IF (n_np GT 0) THEN BEGIN ; north polar cap ; ---------------------------------

   ip = ipix(pix_np) + 1
   iring = LONG( SQRT( ip/2.d0 - SQRT(ip/2) ) ) + 1L ; counted from NORTH pole
   iphi  = ip - 2L*iring*(iring-1L)

   theta(pix_np) = ACOS( 1.d0 - iring^2 / fact2 )
   phi(pix_np)   = (iphi - 0.5d0) * !DPI/(2.d0*iring)

ENDIF ; ------------------------------------------------------------------------

IF (n_eq GT 0) THEN BEGIN ; equatorial strip ; ---------------------------------

   ip    = ipix(pix_eq) - ncap
   iring = LONG( ip / nl4) + nside                        ; counted from NORTH pole
   iphi  = ( ip MOD nl4 )  + 1

   fodd  = 0.5d0 * (1 + ((iring+nside) MOD 2)) ; 1 if iring is odd, 1/2 otherwise

   theta(pix_eq) = ACOS( (nl2 - iring) / fact1 )
   phi(pix_eq)   = (iphi - fodd) * !DPI/(2.d0*nside)

ENDIF ; ------------------------------------------------------------------------

IF (n_sp GT 0) THEN BEGIN ; south polar cap ; ---------------------------------

   ip =  npix - ipix(pix_sp)
   iring = LONG( SQRT( ip/2.d0 - SQRT(ip/2) ) ) + 1      ; counted from SOUTH pole
   iphi  = 4*iring + 1 - (ip - 2L*iring*(iring-1L))
   
   theta(pix_sp) = ACOS( - 1.d0 + iring^2 / fact2 )
   phi(pix_sp)   = (iphi - 0.5d0) * !DPI/(2.d0*iring)

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
