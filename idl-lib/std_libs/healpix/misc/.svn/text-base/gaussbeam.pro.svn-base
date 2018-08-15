function gaussbeam, fwhm, lmax
;+
; NAME:
;   gaussbeam
;
; PURPOSE:
;    returns the spherical transform of a gaussian beam
;    from l=0 to lmax with a fwhm in arcmin
;
; CATEGORY:
;
; CALLING SEQUENCE:
;   result = gaussbeam(fwhm, lmax)
; 
; INPUTS:
;   fwhm : scalar, FWHM in arcmin
;   lmax : scalar integer, lmax
;
; OUTPUTS:
;   result contains the window for l in [0,lmax]
;   corresponding to a gaussian beam of FWHM 'fwhm'
;
; PROCEDURE:
;    result = exp(-0.5*l*(l+1)*sigma^2)
;    with sigma = fwhm/60.*!DtoR / sqrt(8.*alog(2.))
;    and l = lindgen(lmax+1)
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;     version 1.0, EH, Caltech, 11-1999
;     version 1.1, EH, Caltech, 03-2000 : double precision
;
;-

; translates fwhm (arcmin) into sigma = rms (radians)
sigma = fwhm/60.d0*!DtoR / sqrt(8.d0*alog(2.d0))

; l is in [0,lmax]
l = dindgen(lmax+1)

; computes the gaussian window
g = exp(-0.5d0*l*(l+1)*sigma^2)

return,g
end

