Function M_nerfc, x

;+
; NAME:
;	M_NERFC
; VERSION:
;	3.3
; PURPOSE:
;	Calculates A renormalized complementary error function.
; CATEGORY:
;	Mathematical function.
;	Obsolete, replaced by NERFC_MM.
; PROCEDURE:
;	Calls NERFC_MM and OBSTAT from MIDL.  See NERFC_MM for details.
; MODIFICATION HISTORY:
;	Created 20-DEC-1994 by Mati Meron, under the name RENERF_FUN.
;	Renamed M_NERFC and completely rewritten 15-JAN-1996, by Mati Meron, 
;	in order to enhance range and accuracy.  
;	Modified 25-SEP-1998 by Mati Meron.  Underflow filtering added.
;	Replaced by NERFC_MM on 30-SEP-1999.
;-

    Obstat

    return, Nerfc_mm(x)
end
