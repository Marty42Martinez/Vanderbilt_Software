PRO INDEX2LM, index, l, m

;+
; NAME:
;       INDEX2LM 
;
; PURPOSE:
;       to convert the integer index value into the corresponding
;       l,m mode indices in the spherical harmonic basis.
;
; CALLING SEQUENCE:
;       INDEX2LM, index, l, m
; 
; INPUTS:
;       index = (long) integer or integer array
;
; OUTPUTS:
;       l     = (long) integer or integer array
;       m     = (long) integer or integer array
;
; MODIFICATION HISTORY:
;       May 1999: written by A.J. Banday (MPA)    
;       June 1999: now works for large l. BDW
;
;
;-

; define output arrays
ndim = n_elements(index)
if(ndim gt 1)then begin
  l = lonarr(ndim)
  m = lonarr(ndim)
endif

; compute index to {l,m} relation
l = long(sqrt(index-1))
m = index - l^2 - l - 1

; Exit routine
return
end



