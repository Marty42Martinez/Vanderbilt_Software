Function M_errorf, x, complementary = comp

;+
; NAME:
;	M_ERRORF
; VERSION:
;	3.3
; PURPOSE:
;	Calculates the error function.  Replacement for the IDL ERRORF function
;	which accepts only real input.
; CATEGORY:
;	Mathematical function (general).
;	Obsolete, replaced by ERRORF_MM.
; PROCEDURE:
;	Calls ERRORF_MM and OBSTAT from MIDL.  SEE ERRORF_MM for details.
; MODIFICATION HISTORY:
;	Created 20-MAR-1996 by Mati Meron.
;	Replaced by ERRORF_MM on 30-SEP-1999.
;-

    Obstat

    return, Errorf_mm(x, complementary = comp)
end
