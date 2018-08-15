Function M_real, x

;+
; NAME:
;	M_REAL
; VERSION:
;	3.3
; PURPOSE:
;	Returns real values.
; CATEGORY:
;	Mathematical, general.
;	Obsolete.  Replaced by REAL_MM.
; PROCEDURE:
;	Calls OBSTAT and REAL_MM from MIDL.  See REAL_MM for details.
; MODIFICATION HISTORY:
;	Created 5-MAY-1996 by Mati Meron.
;	Modified 15-SEP-1998 by Mati Meron.  Underflow filtering added.
;	Replaced by REAL_MM on 30-SEP-1999.
;-

    Obstat

    return, Real_mm(x)
end
