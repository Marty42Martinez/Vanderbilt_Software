Function M_lngamma, x

;+
; NAME:
;	M_LNGAMMA
; VERSION:
;	3.3
; PURPOSE:
;	Calculates the natural log of the gamma function.  Replacement for the 
;	IDL LNGAMMA function which accepts only real input.
; CATEGORY:
;	Mathematical function (general).
;	Obsolete.  Replaced by LNGAMMA_MM.
; PROCEDURE:
;	Calls LNGAMMA_MM and OBSTAT from MIDL.  See LNGAMMA_MM for details.
; MODIFICATION HISTORY:
;	Created 30-MAR-1996 by Mati Meron.
;	Replaced by LNGAMMA_MM on 30-SEP-1999.
;-

    Obstat

    return, Lngamma_mm(x)
end
