Function M_Igamma, x, a, eps, complementary = comp

;+
; NAME:
;	M_IGAMMA
; VERSION:
;	3.3
; PURPOSE:
;	Calculates the incomplete gamma function.  Replacement for the IDL 
;	IGAMMA function which accepts only real input.
; CATEGORY:
;	Mathematical function (general).
;	Obsolete, replaced by IGAMMA_MM.
; PROCEDURE:
;	Calls IGAMMA_MM and OBSTAT from MIDL.  See IGAMMA_MM for details.
; MODIFICATION HISTORY:
;	Created 15-MAR-1996 by Mati Meron.
;	Modified 20-SEP-1998 by Mati Meron.  Underflow filtering added.
;	Replaced by IGAMMA_MM on 30-SEP-1999.
;-

    Obstat

    return, Igamma_mm(x, a, eps, complementary = comp)
end
