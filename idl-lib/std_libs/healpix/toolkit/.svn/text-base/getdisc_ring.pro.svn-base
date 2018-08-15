;+
; NAME:
;  getdisc_ring
;
; PURPOSE:
;  finds the Healpix pixels that lie within a radius (radius_in) from the
;  vector (vector_0) in the ring scheme for the resolution Nside
;
; CATEGORY:
;  Healpix pixel toolkit
;
; CALLING SEQUENCE:
;     GETDISC_RING, Nside, Vector0, Radius_In, Listpix, Nlist, Deg=Deg
;
; INPUTS:
;     Nside : scalar integer : Healpix resolution (power of 2)
;     Vector0 : 3-element vector (float or double) : position of the
;          disc center on the sphere (north pole in [0.,0.,1.])
;          the norm of Vector0 does not have to be one, what is
;          consider is the intersection of the sphere with the line of
;          direction Vector0
;     Radius_in : radius of the circle (in radians, unless Deg is set)
;
; KEYWORD PARAMETERS:
;     Deg : if set, the disc radius is in degrees instead of radians.
;
; OUTPUTS:
;     Listpix : list of pixels found within a radius Radius_in from
;          Vector0,
;     Nlist = number of elements of Listpix
;       if no pixel is found (too small a circle) Nlist is 0 and
;       listpix is -1 .
;
; COMMON BLOCKS:
;     none.
;
; RESTRICTIONS:
;     On output Listpix is (supposed to be) ranked in pixel index
;     rather than ranked in distance to the disc center.
;
; SIDE EFFECTS:
;     calls : ring_num, in_ring (included in this file).
;
; PROCEDURE:
;     uses the particular layout of the pixels in parallel rings,
;     to find rapidly the selected pixels.
;     Is much faster than a simple search among all the pixels.
;
; EXAMPLE:
;     getdisc_ring, 256L, [.5,.5,0.], 10., listpix, nlist, /Deg
;       outputs in listpix the Healpix pixel numbers of the pixels
;       with 10 deg of the point on the sphere 
;       having the direction [.5,.5,0.]
;
; MODIFICATION HISTORY:
;     1998??     EH, TAC, 1st f90 version
;     1999-??    EH, Caltech, traduction in IDL
;     1999-12-07 : correction of a bug in the build in subroutine in_ring
;+
function ring_num, nside, z
;
; gives the ring number corresponding to z for the resolution nside
;
;
twothird = 2.d0 /3.d0

;     ----- equatorial regime ---------
iring = NINT( nside*(2.d0-1.500d0*z))

;     ----- north cap ------
if (z gt twothird) then begin
    iring = NINT( nside* SQRT(3.d0*(1.d0-z)))
    if (iring eq 0) then iring = 1
endif

;     ----- south cap -----
if (z lt -twothird) then begin
    iring = NINT( nside* SQRT(3.d0*(1.d0+z)))
    if (iring eq 0) then iring = 1
    iring = 4*nside - iring
endif

return, iring
end

;******************************************************************

function in_ring, nside, iz, phi0, dphi, nir
;
;
; result = in_ring(nside, iz, phi0, dphi, nir)
; gives the list of pixels contained in [phi0-dphi,phi0+dphi]
; on the ring iz for the resolution nside
; nir is the number of pixels found
; if no pixel is found, on exit nir =0 and result = -1
;
;  bug corrected on 1999-12-07 (turned ip_low and ip_hi to long, add
;  nir on output)
;

twopi = 2.d0*!DPI
take_all = 0 ; false
to_top = 0   ; false
npix = 12 * nside * nside
ncap  = 2*nside*(nside-1L) ; number of pixels in the north polar cap
listir = -1
nir = 0

phi_low = (phi0 - dphi) MOD twopi
if (phi_low lt 0) then phi_low = phi_low + 2.d0*!dpi
phi_hi  = (phi0 + dphi) MOD twopi
if (phi_hi lt 0)  then phi_hi  = phi_hi  + 2.d0*!dpi
take_all = (ABS(dphi-!DPI) lt 1.d-6)

;     ------------ identifies ring number --------------
if (iz ge nside and iz le 3*nside) then begin ; equatorial region
    ir = iz - nside + 1L  ; in {1, 2*nside + 1}
    ipix1 = ncap + 4L*nside*(ir-1L) ;  lowest pixel number in the ring
    ipix2 = ipix1 + 4L*nside - 1L   ; highest pixel number in the ring
    kshift = ir MOD 2
    nr = nside*4L
endif else begin
    if (iz lt nside) then begin       ;    north pole
        ir = iz
        ipix1 = 2L*ir*(ir-1L)        ;  lowest pixel number in the ring
        ipix2 = ipix1 + 4L*ir - 1   ; highest pixel number in the ring
    endif else begin                         ;    south pole
        ir = 4*nside - iz
        ipix1 = npix - 2L*ir*(ir+1L) ;  lowest pixel number in the ring
        ipix2 = ipix1 + 4L*ir - 1   ; highest pixel number in the ring
    endelse
    nr = ir*4L
    kshift = 1
endelse

;     ----------- constructs the pixel list --------------
if (take_all) then begin
    nir    = ipix2 - ipix1 + 1
    listir = lindgen(nir)+ipix1
    return, listir
endif

shift = kshift * .5d0
ip_low = NINT (nr * phi_low / twopi - shift)
ip_hi  = NINT (nr * phi_hi  / twopi - shift)
ip_low = ip_low MOD nr  ; in {0,nr-1}
ip_hi  = ip_hi  MOD nr  ; in {0,nr-1}
if (ip_low gt ip_hi) then to_top = 1
ip_low = ip_low + ipix1
ip_hi  = ip_hi  + ipix1

if (to_top) then begin
    nir1 = ipix2 - ip_low + 1
    nir2 = ip_hi - ipix1 + 1
    nir  = nir1 + nir2
    if (nir1 gt 0 and nir2 gt 0) then begin
        listir   = [lindgen(nir2)+ipix1, lindgen(nir1)+ip_low]
    endif else begin
        if nir1 eq 0 then listir   = [lindgen(nir2)+ipix1]
        if nir2 eq 0 then listir   = [lindgen(nir1)+ip_low]
    endelse
endif else begin
    nir = ip_hi - ip_low + 1
    listir = lindgen(nir)+ip_low
endelse

if min(listir) le 0 then help,nr,ip_low,ip_hi,phi_low,phi_hi,iz
return, listir
end

;**************************************************************

pro getdisc_ring, nside, vector0, radius_in, listpix, nlist, deg = deg

code = ('getdisc_ring')

if n_params() lt 4 then begin
    print,'SYNTAX = '+code+' nside, vector0, radius_in, listpix, [nlist, Deg=deg]'
    return
endif

prompt = strupcase(code)+'> '
if (n_elements(vector0) ne 3) then begin
    print,prompt+'vector0 should be a 3 element vector'
    return
endif

if (radius_in lt 0.) then begin
    print,prompt+'radius should be > 0 : ',radius_in
    return
endif

if keyword_set(deg) and radius_in gt 180. then begin
    print,prompt+'radius (deg) too big :',radius_in
    return
endif

if (not keyword_set(deg)) and radius_in gt !pi then begin
    print,prompt+'radius (radian) too big :',radius_in
    return
endif

npix = nside2npix(nside,err=errpix)
if (errpix) then begin
    print,prompt+'invalid Nside:',nside
    return
endif

;radius is in radian
if (keyword_set(deg)) then radius = radius_in*!DtoR else radius = radius_in

halfpi = !DPI*.5d0
lnside = long(nside)
fnside = double(nside)

dth1 = 1.d0/(3.d0*fnside*fnside)
dth2 = 2.d0/(3.d0*fnside)
cosang = cos(radius)

norm_vect0 = sqrt(total(vector0^2))
x0 = vector0[0]/norm_vect0
y0 = vector0[1]/norm_vect0
z0 = vector0[2]/norm_vect0

phi0=0.
if ((x0 ne 0.d0) or (y0 ne 0.d0)) then phi0 = ATAN(y0, x0)  

cosphi0 = cos(phi0)
a = x0*x0 + y0*y0

; find upper and lower rings
rlat0 = asin(z0) ; lat in RAD
rlat1 = rlat0 + radius
rlat2 = rlat0 - radius
if (rlat1 ge halfpi) then zmax = 1.d0 $
                     else zmax = sin(rlat1)

irmin = ( ring_num(lnside,zmax) - 1L ) > 1L ;start from a higher point, to be safe

if (rlat2 le - halfpi) then zmin = -1.d0 $
                       else zmin = sin(rlat2)
irmax = ( ring_num(lnside,zmin) + 1L) < (4*lnside-1) ;go down to a lower point

; ------ loop on ring number ---------
nlist = 0

for iz = irmin, irmax do begin

    if (iz le lnside-1) then begin   ; north polar cap
        z = 1.d0 - double(iz)^2 * dth1
    endif else begin
        if (iz le 3*lnside) then begin
            z = double(2*lnside-iz) * dth2
        endif else begin             ; south polar cap
            z = -1.d0 + double(4*lnside-iz)^2 * dth1
        endelse
    endelse

    ; phi range in the disc for each z
    b = cosang - z*z0
    c = 1.d0 - z*z
	if ((x0 eq 0.d0) and (y0 eq 0.d0)) then begin
          cosdphi=-1.d0
          dphi=!PI
	endif  else begin
    cosdphi = b/sqrt(a*c)
    if (ABS(cosdphi) le 1.d0) then begin
        dphi = ACOS (cosdphi) ; in [0,Pi]
    endif else begin
        if (cosphi0 lt cosdphi) then goto, outofdisc ; out of the disc
        dphi = !DPI ; all the pixels at this elevation are in the disc
    endelse
endelse
    ; concatenate lists of pixels
    listir = in_ring(lnside, iz, phi0, dphi, nir)
    if nir gt 0 then begin
        if nlist le 0 then begin
            listpix = listir 
            nlist = n_elements(listir)
        endif else begin
            listpix = [listpix,listir]
            nlist = nlist + n_elements(listir)
        endelse
    endif
outofdisc:
endfor

return
end

