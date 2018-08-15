function npix2nside, npix, error=error
;+
; NAME:
;   npix2nside
;
; PURPOSE:
;   returns the Nside resolution parameter corresponding to the pixel number Npix
;
; CATEGORY:
;   healpix toolkit
;
; CALLING SEQUENCE:
;   nside = npix2nside(npix [, err=err] )
;
; INPUTS:
;   npix : integer, number of healpix pixels over the full sky
;
; OUTPUTS:
;   nside : integer, healpix resolution parameter,
;           nside = sqrt(npix/12)
;
; OPTIONAL OUTPUTS:
;   error : is set to 0 only if the number of pixels does correpond to a Healpix
;     tesselation of the full sphere
;     ie, npix = 12*nside^2 with nside 
;     in [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192]
;   in any other cases, error = 1
;
; PROCEDURE:
;   trivial
;
; EXAMPLE:
;    nside = npix2nside(786432,err=err)
;    print,nside
;           will return : 256 
;
; MODIFICATION HISTORY:
;
;     v1.0, EH, Caltech, 2000-02-11
;
;-


error = 1
fnside = sqrt(npix/12.)

; closest integer
nside = long(round(fnside))

; is npix = 12*nside^2 ?
nnpix = 12L*nside*nside
if abs(nnpix-npix) gt .1 then return,-1  ;fnside

; is nside a power of 2 ?
junk = where(nside eq [1L,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192], count)
if count ne 1 then return,-1  ;nside

; npix and nside are fine
error=0
return,nside
end

