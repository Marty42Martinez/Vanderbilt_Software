PRO vec2pix_ring, nside, vec_in, ipix
;*******************************************************************
;+
; VEC2PIX_RING, Nside, Vec_in, Ipix
;
;        renders the RING scheme pixel number Ipix for a pixel which, given the
;        map resolution parameter Nside, contains the point on the sphere
;        at cartesian coordinates Vec_in
;
; INPUT
;    Nside     : determines the resolution (Npix = 12* Nside^2)
;	     SCALAR 
;    Vec_in    : (x,y,z) position unit vector(s) with North pole = (0,0,1)
;            stored as x(0), x(1), ..., y(0), y(1), ..., z(0), z(1) ..
;            ARRAY of dimension = (np,3)
;
; OUTPUT
;    Ipix  : pixel number in Healpix pixelisation in [0,Npix-1]
;	is a VECTOR of dimension = (np)
;    pixels are numbered along parallels
;    and parallels are numbered from north pole to south pole
;
;
; HISTORY
;    June-October 1997,  Eric Hivon & Kris Gorski, TAC
;    Feb 1999,  Eric Hivon, Caltech
;
;-
;*****************************************************************************

ns_max = 8192L

if N_params() ne 3 then begin
    print,' syntax = vec2pix_ring, nside, vec, ipix'
    stop
endif

if (N_ELEMENTS(nside) GT 1) then begin
	print,'nside should be a scalar in vec2pix_ring'
        print,'VEC2PIX_RING, nside, vec_in, ipix'
	stop
endif
if (nside lt 1) or (nside gt ns_max) then stop, 'nside out of range'

np1 = N_ELEMENTS(vec_in)
np = LONG(np1/3) 
if (np1 NE np*3) then begin
	print,'inconsistent vec_in in vec2pix_ring'
        print,'VEC2PIX_RING, nside, vec_in, ipix'
	stop
endif
vec_in = reform(vec_in,np,3,/OVERWRITE)
;------------------------------------------------------------
nside  = LONG(nside)
pion2 = !DPI * 0.5d0
twopi = !DPI * 2.d0
nl2   = 2*nside
nl4   = 4*nside
npix  = (3L*nside)*(4L*nside)
ncap  = nl2*(nside-1L)

cth0 = 2.d0/3.d0

cth_in = vec_in(*,2)/SQRT(vec_in(*,0)^2 + vec_in(*,1)^2 + vec_in(*,2)^2)
phi_in = ATAN(vec_in(*,1),vec_in(*,0))
phi_in = phi_in + (phi_in LE 0.d0)*twopi

pix_eqt = WHERE(cth_in LE  cth0 AND cth_in GT -cth0, n_eqt) ; equatorial strip
pix_np  = WHERE(cth_in GT  cth0, n_np)                      ; north caps
pix_sp  = WHERE(cth_in LE -cth0, n_sp)                      ; south pole

ipix = LONARR(np)
IF (n_eqt GT 0) THEN BEGIN ; equatorial strip ----------------
      tt = phi_in(pix_eqt) / pion2

      jp = LONG(nside*(0.5d0 + tt - cth_in(pix_eqt)*0.75d0)) ; increasing edge line index
      jm = LONG(nside*(0.5d0 + tt + cth_in(pix_eqt)*0.75d0)) ; decreasing edge line index

      ir = (nside + 1) + jp - jm ; in {1,2n+1} (ring number counted from z=2/3)
      k =  ( (ir MOD 2) EQ 0)   ; k=1 if ir even, and 0 otherwise

      ip = LONG( ( jp+jm+k + (1-nside) ) / 2 ) + 1 ; in {1,4n}
      ip = ip - nl4*(ip GT nl4)

      ipix(pix_eqt) = ncap + nl4*(ir-1) + ip - 1
      tt = 0 & jp = 0 & jm = 0 & ir = 0 & k = 0 & ip = 0
ENDIF

IF (n_np GT 0) THEN BEGIN ; north polar caps ------------------------

      tt = phi_in(pix_np) / pion2
      tp = tt MOD 1.d0
      tmp = SQRT( 3.d0*(1.d0 - ABS(cth_in(pix_np))) )

      jp = LONG( nside * tp          * tmp ) ; increasing edge line index
      jm = LONG( nside * (1.d0 - tp) * tmp ) ; decreasing edge line index

      ir = jp + jm + 1         ; ring number counted from the closest pole
      ip = LONG( tt * ir ) + 1 ; in {1,4*ir}
      ir4 = 4*ir
      ip = ip - ir4*(ip GT ir4)

      ipix(pix_np) =        2*ir*(ir-1) + ip - 1
ENDIF ; -------------------------------------------------------

IF (n_sp GT 0) THEN BEGIN ; south polar caps ------------------------

      tt = phi_in(pix_sp) / pion2
      tp = tt MOD 1.d0
      tmp = SQRT( 3.d0*(1.d0 - ABS(cth_in(pix_sp))) )

      jp = LONG( nside * tp          * tmp ) ; increasing edge line index
      jm = LONG( nside * (1.d0 - tp) * tmp ) ; decreasing edge line index

      ir = jp + jm + 1         ; ring number counted from the closest pole
      ip = LONG( tt * ir ) + 1 ; in {1,4*ir}
      ir4 = 4*ir
      ip = ip - ir4*(ip GT ir4)

      ipix(pix_sp) = npix - 2*ir*(ir+1) + ip - 1
ENDIF ; -------------------------------------------------------

return
end

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
