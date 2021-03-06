;+
; NAME:
;       COLOR24
;
; PURPOSE:
;       The purpose of this function is to convert a RGB color triple
;       into the equivalent 24-big long integer. 
;
; CATEGORY:
;       Graphics, Color Specification.
;
; CALLING SEQUENCE:
;       color = COLOR24(rgb_triple)
;
; INPUTS:
;       RGB_TRIPLE: A three-element column or row array representing 
;       a color triple. The values of the elements must be between 
;       0 and 255.
;
; KEYWORD PARAMETERS:
;       None. 
;
; COMMON BLOCKS:
;       None.
;
; SIDE EFFECTS:
;       None.
;
; RESTRICTIONS:
;       None.
;
; EXAMPLE:
;       To convert the color triple for the color YELLOW, 
;       (255, 255, 0), to the hexadecimal value '00FFFF'x 
;       or the decimal number 65535, type:
;
;       color = COLOR24([255, 255, 0])
;       
;       This routine was written to be used with routines like 
;       COLORS or GETCOLOR
;
; MODIFICATION HISTORY:
;       Written by:	David Fanning, 3 February 96.
;-


FUNCTION COLOR24, number

   ; This FUNCTION accepts a [red, green, blue] triple that
   ; describes a particular color and returns a 24-bit long
   ; integer that is equivalent to that color. The color is
   ; described in terms of a hexidecimal number (e.g., FF206A)
   ; where the left two digits represent the blue color, the 
   ; middle two digits represent the green color, and the right 
   ; two digits represent the red color.
   ;
   ; The triple can be either a row or column vector of 3 elements.
   
ON_ERROR, 1

IF N_ELEMENTS(number) NE 3 THEN $
   MESSAGE, 'Augument must be a three-element vector.'

IF MAX(number) GT 255 OR MIN(number) LT 0 THEN $
   MESSAGE, 'Argument values must be in range of 0-255'

base16 = [[1L, 16L], [256L, 4096L], [65536L, 1048576L]]

num24bit = 0L

FOR j=0,2 DO num24bit = num24bit + ((number(j) MOD 16) * base16(0,j)) + $
   (Fix(number(j)/16) * base16(1,j))
   
RETURN, num24bit
END ; ******************************  of COLOR24  **************************
