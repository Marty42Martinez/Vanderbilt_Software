;+
; NAME:
;    PSWINDOW
;
; PURPOSE:
;
;    This function is used to calculate the size of a PostScript
;    window that has the same aspect ratio (ratio of height to
;    width) as the current display graphics window. It creates
;    the largest possible PostScript output window with the
;    desired aspect ratio. This assures that graphics output
;    looks similar, if not identical, to PostScript output.
;
; AUTHOR:
;
;   FANNING SOFTWARE CONSULTING
;   David Fanning, Ph.D.
;   1645 Sheely Drive
;   Fort Collins, CO 80526 USA
;   Phone: 970-221-0438
;   E-mail: davidf@dfanning.com
;   Coyote's Guide to IDL Programming: http://www.dfanning.com/
;
; CATEGORY:
;
;    Graphics.
;
; CALLING SEQUENCE:
;
;    pageInfo = PSWINDOW()
;
; INPUTS:
;
;    None.
;
; KEYWORD PARAMETERS:
;
;    CM: Normally the structure value that is returned from this
;    function reports its values in inches. Setting this keyword
;    causes the return values to be in units of centimeters.
;
;    FUDGE: A quick way to set symetrical XFUDGE and YFUDGE factors.
;    If this keyword is set to a value, XFUDGE and YFUDGE keywords are
;    set to the same value.
;
;    LANDSCAPE: Normally this function assumes a PostScript window
;    in Portrait mode. Setting this keyword assumes you want
;    the graphic in Landscape mode.
;
;    MARGIN:  The margin around the edges of the plot. The value must be
;    a floating point value between 0.0 and 0.5. It is expressed in
;    normalized coordinate units. The default margin is 0.15.
;
;    PAGESIZE: Set this keyword to a string indicating the type
;    of PostScript page size you want. Current values are "LETTER",
;    "LEGAL", and "A4". Default is "LETTER".
;
;    PRINTER: Set this keyword if the output will be used to
;    configure the PRINTER device, rather than the PS device.
;    (In the PRINTER device, offsets are always calculated from
;    the lower-left corner of the page and do not rotate in
;    Landscape mode, as they do with the PS device.) Note that
;    the PRINTER device is only able to accept these keywords
;    in IDL 5.1 and higher.
;
;    XFUDGE: Printers calculate the offset point from the printable
;    edge of the paper (sometimes), rather from the corner of the paper.
;    For example, on my Lexmark printer, both X and Y offsets are
;    calculated from a point 0.25 inches in from the edge. This keyword
;    allows you to set a "fudge" factor that will be subtracted from
;    the XOFFSET that is returned to the user. This allows you to create
;    output that is centered on the page. The fudge factor should be in
;    the same units as the returned size and offset values.
;
;    YFUDGE: Printers calculate the offset point from the printable
;    edge of the paper (sometimes), rather from the corner of the paper.
;    For example, on my Lexmark printer, both X and Y offsets are
;    calculated from a point 0.25 inches in from the edge. This keyword
;    allows you to set a "fudge" factor that will be subtracted from
;    the YOFFSET that is returned to the user. This allows you to create
;    output that is centered on the page. The fudge factor should be in
;    the same units as the returned size and offset values.
;
; OUTPUTS:
;
;    pageInfo: The output value is a named structure defined like
;    this:
;
;      pageInfo = {PSWINDOW_STRUCT, XSIZE:0.0, YSIZE:0.0, $
;         XOFSET:0.0, YOFFSET:0.0, INCHES:0, PORTRAIT:0, LANDSCAPE:0}
;
;    The units of the four size fields are inches unless the CM
;    keyword is set.
;
;    The output can be used to immediately configure the PostScript
;    or Printer device, like this:
;
;       Set_Plot, 'PS' ; or 'PRINTER'
;       Device, _Extra=pageInfo
;
; RESTRICTIONS:
;
;    The aspect ratio of the current graphics window is calculated
;    like this:
;
;       aspectRatio = FLOAT(!D.Y_VSIZE) / !D.X_VSIZE
;
; EXAMPLE:
;
;    To create a PostScript output window with the same aspect
;    ratio as the curently active display window, type:
;
;     pageInfo = PSWINDOW()
;     SET_PLOT, 'PS'
;     DEVICE, _Extra=pageInfo
;
;     To configure the PRINTER device:
;
;     pageInfo = PSWINDOW(/Printer, Fudge=0.25)
;     SET_PLOT, 'PRINTER'
;     DEVICE, _Extra=pageInfo
;
; MODIFICATION HISTORY:
;
;    Written by: David Fanning, November 1996.
;       Fixed a bug in which the YOFFSET was calculated incorrectly
;          in Landscape mode. 12 Feb 97.
;       Took out a line of code that wasn't being used. 14 Mar 97.
;       Added correct units keyword to return structure. 29 JUN 98. DWF
;       Fixed a bug in how landscape offsets were calculated. 19 JUL 99. DWF.
;       Fixed a bug in the way margins were used to conform to my
;          original conception of the program. 19 JUL 99. DWF.
;       Added Landscape and Portrait fields to the return structure. 19 JUL 99. DWF.
;       Added PageSize keyword, changed MARGIN keyword, and completely
;          rewrote most of the intenal code. 9 FEB 2000. DWF.
;       Fixed a bug in how I calculated the aspect ratio. 1 MAR 2000. DWF.
;       Added PRINTER keyword to return proper offset values for the
;          PRINTER device, where the offset location is not rotated. 1 MAR 2000. DWF.
;       Added PRINTER fudge factors to take into account that printer offsets are
;          calculated from the printable area of the paper, rather than the corner
;          of the paper. 8 AUG 2000. DWF.
;-
;
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright � 2000 Fanning Software Consulting
;
; This software is provided "as-is", without any express or
; implied warranty. In no event will the authors be held liable
; for any damages arising from the use of this software.
;
; Permission is granted to anyone to use this software for any
; purpose, including commercial applications, and to alter it and
; redistribute it freely, subject to the following restrictions:
;
; 1. The origin of this software must not be misrepresented; you must
;    not claim you wrote the original software. If you use this software
;    in a product, an acknowledgment in the product documentation
;    would be appreciated, but is not required.
;
; 2. Altered source versions must be plainly marked as such, and must
;    not be misrepresented as being the original software.
;
; 3. This notice may not be removed or altered from any source distribution.
;
; For more information on Open Source Software, visit the Open Source
; web site: http://www.opensource.org.
;
;###########################################################################



FUNCTION PSWINDOW_ASPECT, aspectRatio, MARGIN=margin, WindowAspect=wAspectRatio

ON_ERROR, 1

   ; Check for aspect ratio parameter and possibilities.

IF N_PARAMS() EQ 0 THEN aspectRatio = 1.0

IF aspectRatio EQ 0 THEN BEGIN
   MESSAGE, 'Aspect Ratio of 0. Changing to 1...', /Informational
   aspectRatio = 1.0
ENDIF

s = SIZE(aspectRatio)
IF s(s(0)+1) NE 4 THEN $
   MESSAGE, 'Aspect Ratio is not a FLOAT. Take care...', /Informational

   ; Check for margins.

IF N_ELEMENTS(margin) EQ 0 THEN margin = 0.15

   ; Error checking.

IF margin LT 0 OR margin GE 0.5 THEN $
   MESSAGE, 'The MARGIN keyword value must be between 0.0 and 0.5.'

   ; Calculate the aspect ratio of the current window.

IF N_Elements(wAspectRatio) EQ 0 THEN wAspectRatio = FLOAT(!D.Y_VSIZE) / !D.X_VSIZE

   ; Calculate normalized positions in window.

IF (aspectRatio LE wAspectRatio) THEN BEGIN
   xstart = margin
   ystart = 0.5 - (0.5 - margin) * (aspectRatio / wAspectRatio)
   xend = 1.0 - margin
   yend = 0.5 + (0.5 - margin) * (aspectRatio / wAspectRatio)
ENDIF ELSE BEGIN
   xstart = 0.5 - (0.5 - margin) * (wAspectRatio / aspectRatio)
   ystart = margin
   xend = 0.5 + (0.5 - margin) * (wAspectRatio / aspectRatio)
   yend = 1.0 - margin
ENDELSE

position = [xstart, ystart, xend, yend]

RETURN, position
END ; ----------------------------------------------------------------------------------



FUNCTION PSWINDOW, LANDSCAPE=landscape, CM=cm, MARGIN=margin, $
   PageSize=pagesize, Printer=printer, Fudge=fudge, XFudge=xfudge, YFudge=yfudge

   ; Set up default values.

landscape = Keyword_Set(landscape)
cm = Keyword_Set(cm)
printer = Keyword_Set(printer)
inches = 1

   ; Set up printer fudge factors, if necessary.

IF N_Elements(fudge) NE 0 THEN BEGIN
   xfudge = fudge
   yfudge = fudge
ENDIF
IF N_Elements(xfudge) EQ 0 THEN xfudge = 0.0
IF N_Elements(yfudge) EQ 0 THEN yfudge = 0.0

   ; Get the page size.

IF N_Elements(pagesize) EQ 0 THEN pagesize = 'LETTER' $
   ELSE pagesize = StrUpCase(pagesize)
CASE pagesize OF
   'LETTER': BEGIN
      shortside = 8.5
      longside = 11.0
      ENDCASE
   'LEGAL': BEGIN
      shortside = 8.5
      longside = 14.0
      ENDCASE
    'A4': BEGIN
      shortside = 8.27
      longside = 11.7
      ENDCASE
    ELSE: BEGIN
      Message, 'Unknown page size. Using LETTER...', /Informational
      shortside = 8.5
      longside = 11.0
      ENDCASE
ENDCASE

   ; Need measurements in centimeters?

IF KEYWORD_SET(cm) THEN BEGIN
      shortside = shortside * 2.54
      longside = longside * 2.54
      inches = 0
ENDIF

   ; Determine the margin of the window on the page.

IF N_ELEMENTS(margin) EQ 0 THEN margin=0.15

   ; Get the aspect ratio of the current display window. Aspect ratio
   ; is ratio of xsize/ysize.

aspectRatio = FLOAT(!D.Y_VSIZE) / !D.X_VSIZE

   ; Get the aspect ratio of the page.

IF Keyword_Set(landscape) THEN pAspectRatio = shortside / longside $
   ELSE pAspectRatio = longside / shortside

   ; Get the position on the page for this window.

pos = PSWindow_Aspect(aspectRatio, Margin=margin, WindowAspect=pAspectRatio)

   ; Convert normalized position coordinates to size units.

IF KEYWORD_SET(landscape) THEN BEGIN
   IF printer THEN BEGIN
      xsize = (pos[2] - pos[0]) * longside
      ysize = (pos[3] - pos[1]) * shortside
      yoffset = pos[1] * shortside - yfudge
      xoffset = pos[0] * longside - xfudge
      landscape = 1
      portrait = 0
   ENDIF ELSE BEGIN
      xsize = (pos[2] - pos[0]) * longside
      ysize = (pos[3] - pos[1]) * shortside
      xoffset = pos[1] * shortside
      yoffset = longside - (pos[0] * longside)
      landscape = 1
      portrait = 0
   ENDELSE
ENDIF ELSE BEGIN
   xsize = (pos[2] - pos[0]) * shortside
   ysize = (pos[3] - pos[1]) * longside
   IF printer THEN BEGIN
      xoffset = pos[0] * shortside - xfudge
      yoffset = pos[1] * longside - yfudge
   ENDIF ELSE BEGIN
      xoffset = pos[0] * shortside
      yoffset = pos[1] * longside
   ENDELSE
   landscape = 0
   portrait = 1
ENDELSE

   ; Return the proper DEVICE data structure.

RETURN, {PSWINDOW_STRUCT, XSIZE:xsize, YSIZE:ysize, $
   XOFFSET:xoffset, YOFFSET:yoffset, INCHES:inches, $
   PORTRAIT:portrait, LANDSCAPE:landscape}

END
