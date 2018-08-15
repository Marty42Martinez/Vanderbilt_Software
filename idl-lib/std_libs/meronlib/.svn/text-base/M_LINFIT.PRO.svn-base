Function M_Linfit, x, y, w, order = nord, residual = resid, $
    base = bas, params = pars, parmask = pmsk

;+
; NAME:
;	M_LINFIT
; VERSION:
;	3.3
; PURPOSE:
;	Linear fitting with an arbitrary number of parameters.
; CATEGORY:
;	Mathematical Function.
;	Obsolete, replaced by LINFIT_MM.
; CALLING SEQUENCE:
;	Result = M_LINFIT( X, Y [,W] [, keywords])
; PROCEDURE:
;	Calls LINFIT_MM and OBSTAT from MIDL.  See LINFIT_MM for details.
; MODIFICATION HISTORY:
;	Created 1-JUN-93 by Mati Meron.
;	Renamed from LINFIT to M_LINFIT to avoid clashes with an IDL library
;	routine bearing the same name.
;	Modified 20-SEP-1998 by Mati Meron.  Underflow filtering added.
;	Replaced by LINFIT_MM on 30-SEP-1999.
;-

    Obstat

    Return, Linfit_mm(x, y, w, order = nord, residual = resid, $
    base = bas, params = pars, parmask = pmsk)
end
