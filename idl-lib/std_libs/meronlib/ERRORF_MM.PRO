Function Errorf_mm, x, complementary = comp

;+
; NAME:
;	ERRORF_MM
; VERSION:
;	3.3
; PURPOSE:
;	Calculates the error function.  Replacement for the IDL ERRORF function
;	which accepts only real input.
; CATEGORY:
;	Mathematical function (general).
; CALLING SEQUENCE:
;	Result = ERRORF_MM (X [, /COMPLEMENTARY)]
; INPUTS:
;    X
;	Numeric, otherwise arbitrary.
; OPTIONAL INPUT PARAMETERS:
;	None.
; KEYWORD PARAMETERS:
;    /COMPLEMENTARY
;	Switch.  If set, 1 - ERRORF(X) is returned.
; OUTPUTS:
;	Returns the error function of X or, if /COMPLEMENTARY is set,
;	1 - error_function.
; OPTIONAL OUTPUT PARAMETERS:
;	None.
; COMMON BLOCKS:
;	None.
; SIDE EFFECTS:
;	None.
; RESTRICTIONS:
;	For very large (in absolute value) complex values of x, with
;		pi/4 < |abs(phase(x))| < 3*pi/4
;	the results may be meaningless.  A warning will be issued in this case.
; PROCEDURE:
;	Uses CAST IGAMMA_MM and IMAGINARY_MM from MIDL.
; MODIFICATION HISTORY:
;	Created 20-MAR-1996 by Mati Meron as M_ERRORF.
;	Renamed 25-SEP-1999 by Mati Meron, to ERRORF_MM.
;-

    zex = 0*x
    sn = long(zex + 1)
    tem = double(zex)
    dum = where(Imaginary_mm(x) ne 0, ndum)
    if ndum gt 0 then tem(dum) = atan(dcomplex(x(dum)))
    dum = where(tem gt !dpi/2 or tem lt -!dpi/2, ndum)
    if ndum gt 0 then sn(dum) = -1l
    wx = Cast(x,4)

    return, sn*Igamma_mm(wx^2, 0.5d, comp = comp) + keyword_set(comp)*(1 - sn)
end
