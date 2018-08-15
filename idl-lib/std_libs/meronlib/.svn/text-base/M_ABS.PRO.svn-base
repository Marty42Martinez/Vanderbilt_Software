Function M_abs, x

;+
; NAME:
;	M_ABS
; VERSION:
;	3.3
; PURPOSE:
;	Calculates absolute values.  A temporary fix needed since the IDL ABS 
;	function fails with very large or very small complex numbers.
; CATEGORY:
;	Mathematical, general.
;	Obsolete, replaced by ABS_MM.
; PROCEDURE:
;	Calling ABS_MM and OBSTAT from MIDL.  See ABS_MM for details.
; MODIFICATION HISTORY:
;	Created 15-MAR-1996 by Mati Meron.
;	Modified 30-AUG-1998 by Mati Meron.  Underflow filtering added.
;	Replaced by ABS_MM on 30-SEP-1999.
;-

    Obstat

    return, Abs_mm(x)
end
