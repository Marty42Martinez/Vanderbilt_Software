Function Beselk, x, ni, eps, integral = int

;+
; NAME:
;	BESELK
; VERSION:
;	3.3
; PURPOSE:
;	Calculates an approximation to Bessel K functions or their integrals.
; CATEGORY:
;	Mathemetical Function (General).
;	Obsolete, replaced by BESELK_MM.
; PROCEDURE:
;	Calls BESELK_MM and OBSTAT from MIDL.  See BESELK_MM for details.
; MODIFICATION HISTORY:
;	Created 1-MARCH-1993 by Mati Meron.
;	Modified 15-SEP-1998 by Mati Meron.  Underflow filtering added.
;	Replaced by BESELK_MM on SEP-30-1999.
;-

    Obstat

    return, Beselk_mm(x, ni, eps, integral = int)
end
