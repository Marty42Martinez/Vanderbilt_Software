;+
; NAME:
;       GETCOLOR
;
; PURPOSE:
;       The purpose of this function is to return the value of a
;       "named" color. The result is a 1-by-3 vector containing
;       the values of the color triple if the user specified a
;       a particular color. Or it is a 5-by-3 array containing the
;       color triples of all 5 supported color if no positional 
;       parameter is passed.
;
; CATEGORY:
;       Graphics, Color Specification.
;
; CALLING SEQUENCE:
;       result = GETCOLOR(color)
;
; OPTIONAL INPUTS:
;       COLOR: A string with the "name" of the color. Five colors
;              are allowed: "CHARCOAL", "RED", "GREEN", "BLUE" and "YELLOW".
;              If the string is anything else, a YELLOW color triple is
;              returned.
;
; KEYWORD PARAMETERS:
;       TRUE:  If this keyword is set the specified color triple is returned
;              as a 24-bit integer equivalent. The lowest 8 bits correspond to
;              the red value; the middle 8 bits to the green value; and the
;              highest 8 bits correspond to the blue value. 
;
; COMMON BLOCKS:
;       None.
;
; SIDE EFFECTS:
;       None.
;
; RESTRICTIONS:
;       The TRUE keyword is operational only if the input COLOR is present.
;
; EXAMPLE:
;       To load a yellow color in color index 100 and plot in yellow, type:
;       
;          TVLCT, GETCOLOR('yellow'), 100
;          PLOT, data, COLOR=100
;
;       To do the same thing on a 24-bit color system, type:
;       
;          PLOT, data, COLOR=GETCOLOR('yellow', /TRUE)
;       
;       To load all five colors into the current color table, starting at
;       color index 200, type:
;
;          TVLCT, GETCOLOR(), 200
;
; MODIFICATION HISTORY:
;       Written by: David Fanning, 10 February 96.
;       Fixed a bug in which N_ELEMENTS was spelled wrong. 7 Dec 96.
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
END ; ************************  of COLOR24  ******************************



FUNCTION GETCOLOR, thisColor, TRUE=truecolor
  
   ; Set up the color vectors.
   
names   = ['CHARCOAL', 'RED', 'GREEN', 'BLUE', 'YELLOW']
rvalue  = [    70,      255,      0,      0,     255   ]
gvalue  = [    70,        0,    255,      0,     255   ]
bvalue  = [    70,        0,      0,    255,       0   ]

   ; Did the user ask for a specific color? If not, return
   ; all the colors. If the user asked for a specific color,
   ; find out if a 24-bit value is required. Return to main
   ; IDL level if an error occurs.
   
ON_ERROR, 1
np = N_PARAMS()
IF np EQ 1 THEN BEGIN

      ; Make sure the parameter is an uppercase string.
   
   varInfo = SIZE(thisColor)
   IF varInfo(varInfo(0) + 1) NE 7 THEN $
      MESSAGE, 'The color name must be a string.'
   thisColor = STRUPCASE(thisColor)
   
      ; Get the color triple for this color.
      
   colorIndex = WHERE(names EQ thisColor)

      ; If you can't find it. Issue an infomational message,
      ; set the index to a YELLOW color, and continue.
      
   IF colorIndex(0) LT 0 THEN BEGIN
      MESSAGE, "Can't find color. Returning yellow.", /INFORMATIONAL
      colorIndex = 4
   ENDIF
   
      ; Get the color triple.
   
   r = rvalue(colorIndex)
   g = gvalue(colorIndex)
   b = bvalue(colorIndex)
   returnColor = REFORM([r, g, b], 1, 3)
   
      ; Did the user want a 24-bit value? If so, call COLOR24.
      
   IF KEYWORD_SET(trueColor) THEN returnColor = COLOR24(returnColor)
   RETURN, returnColor
ENDIF

   ; If you got here. Return all the colors.
   
RETURN, REFORM([rvalue, gvalue, bvalue], 5, 3)
END
