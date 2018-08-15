Function StrMatch, str, list, len, caseon = cas, all = all, exclude = exl

;+
; NAME:
;	STRMATCH
; VERSION:
;	3.3
; PURPOSE:
;	Compares the string STR with the strings in the array LIST.  Comparison
;	is done for the first LEN characters, or all of them if LEN is 0.  If a
;	 match is found, STR is replaced by the full string from the list (or
;	if the keyword /ALL is set, by an array containing all the matching 
;	strings).
; CATEGORY:
;	String Processing.
;	Obsolete.  Replaced by STRMATCH_MM.
; PROCEDURE:
;	Calls OBSTAT and STRMATCH_MM from MIDL.  See STRMATCH_MM for details.
; MODIFICATION HISTORY:
;	Created 15-JUL-1991 by Mati Meron.
;	Modified 20-NOV-1993 by Mati Meron.  Added keyword ALL.
;	Modified 11-OCT-1997 by Roger J. Dejus.  Added keyword EXCLUDE.
;	Replaced by STRMATCH_MM on 30-SEP-1999.
;-

    Obstat

    return, StrMatch_mm(str, list, len, caseon = cas, all = all, exclude = exl)
end
