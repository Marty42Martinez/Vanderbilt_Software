Function StrParse, line, delim, list

;+
; NAME:
;	STRPARSE
; VERSION:
;	3.3
; PURPOSE:
;	Parses the string LINE using the characters in DELIM as delimiters.  
;	Puts individual pieces into consecutive locations in LIST.
; CATEGORY:
;	String Processing.
;	Obsolete.  Replaced by STRPARSE_MM.
; PROCEDURE:
;	Calls OBSTAT and STRPARSE_MM from MIDL.  See STRPARSE_MM for details.
; MODIFICATION HISTORY:
;	Created 15-JUL-1991 by Mati Meron.
;	Replaced by STRPARSE_MM on 30-SEP-1999.
;-

    Obstat

    return, Strparse_mm(line, delim, list)
end
