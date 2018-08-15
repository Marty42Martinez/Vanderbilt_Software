function nside2npix, nside, error=error
;+
; npix = nside2npix(nside, error=error)
;
; returns npix = 12*nside*nside
; number of pixels on a Healpix map of resolution nside
;
; if nside is not a power of 2 <= 8192,
; -1 is returned and the error flag is set to 1
;
;-

error = 1
; is nside a power of 2 ?
junk = where(nside eq [1L,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192], count)
if count ne 1 then return,-1

npix = 12L* long(nside)^2

error = 0
return, npix
end

