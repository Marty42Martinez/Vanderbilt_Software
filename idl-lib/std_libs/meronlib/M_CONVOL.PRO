Function M_Convol, far, gar, nocenter = noc, reverse = rev, clip = cli, $
    edge_val = edv, edge_truncate = edt

;+
; NAME:
;	M_CONVOL
; VERSION:
;	3.3
; PURPOSE:
;	Calculates the convolution of two functions represented by arrays.
; CATEGORY:
;	Mathematical, array function.
;	Obsolete, replaced by CONVOL_MM.
; PROCEDURE:
;	Calls CONVOL_MM and OBSTAT from MIDL.  See CONVOL_MM for details.
; MODIFICATION HISTORY:
;	Created 15-NOV-1996 by Mati Meron.
;	Modified 20-JAN-1997 by Mati Meron.  Streamlined (through the use of
;	EXTEND_ARRAY and added keyword EDGE_TRUNCATE.
;	Modified 15-SEP-1998 by Mati Meron.  Underflow filtering added.
;	Replaced by CONVOL_MM on 30-SEP-1999.
;-

    Obstat

    return, Convol_mm(far,gar, nocenter = noc, reverse = rev, clip = cli, $
    edge_val = edv, edge_truncate = edt)
end
