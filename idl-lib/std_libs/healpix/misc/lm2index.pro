PRO LM2INDEX, l, m, index

;+
; NAME:
;       INDEX2LM 
;
; PURPOSE:
;       to convert l,m mode indices in the spherical harmonic basis
;       to an integer index value.
;       
;
; CALLING SEQUENCE:
;       LM2INDEX, l, m, index
; 
; INPUTS:
;       l     = (long) integer or integer array
;       m     = (long) integer or integer array
;
; OUTPUTS:
;       index = (long) integer or integer array
;
; MODIFICATION HISTORY:
;       May 1999: written by A.J. Banday (MPA)       
;       Feb 2000: now works for large l, EH (Caltech)
;
;-

; define output arrays
ndim = n_elements(l)
if(ndim gt 1)then begin
  index = lonarr(ndim)
endif

; compute {l,m} to index relation
index = long(l)^2 + l + m  + 1

; Exit routine
return
end



