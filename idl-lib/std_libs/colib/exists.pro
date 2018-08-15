; NAME:
;     exists
; PURPOSE: (one line)
;     Check for file (or directory) existence.
; DESCRIPTION:
; CATEGORY:
;     File I/O
; CALLING SEQUENCE:
;     flag = exists(file)
; INPUTS:
;     file - string containing file name to look for.
; OPTIONAL INPUT PARAMETERS:
; KEYWORD PARAMETERS:
; OUTPUTS:
;     Return value is 1 (true) if file exists.  0 if it doesn't.
; COMMON BLOCKS:
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
;     Calls OPENR recasts answer for a simple boolean flag.
; MODIFICATION HISTORY:
;    93/03/29 - Written by Marc W. Buie, Lowell Observatory
;    96/10/17, MWB, modified to use OPENR for Unix
;    97/02/16, MWB, fixed DOS bug for dirs with trailing \
;-
function exists,file

return, file_test(file)

end