;+
; NAME:
;       XCOLORS
;
; PURPOSE:
;       The purpose of this routine is to change color tables in a
;       manner similar to XLOADCT. It does not use common blocks so
;       multiple copies of XCOLORS can be on the display at the same
;       time. It works extremely well when you are using a restricted
;       number of colors in a window. This program has been modified
;       to work on 8-bit, 16-bit, and 24-bit displays. Use the
;       NOTIFYID keyword to pass the identifier of a widget that should
;       be notified when XCOLORS loads a color table. A widget event will
;       be sent to that widget. The event handler will be responsible
;       for updating the graphic display on 16-bit and 24-bit devices.
;       The program runs as a non-blocking widget in IDL 5.
;
; AUTHOR:
;       FANNING SOFTWARE CONSULTING
;       David Fanning, Ph.D.
;       2642 Bradbury Court
;       Fort Collins, CO 80521 USA
;       Phone: 970-221-0438
;       E-mail: davidf@dfanning.com
;       Coyote's Guide to IDL Programming: http://www.dfanning.com
;
; CATEGORY:
;       Widgets.
;
; CALLING SEQUENCE:
;       XCOLORS
;
; INPUTS:
;       None.
;
; KEYWORD PARAMETERS:
;       BOTTOM: The lowest color index of the colors to be changed.
;
;       FILE: A string variable pointing to a file that holds the
;       color tables to load.
;
;       GROUP_LEADER: The group leader for this program. When the group
;       leader is destroyed, this program will be destroyed.
;
;       JUST_REG: Setting this keyword allows the program to just register
;       itself with XMANAGER. This prevents blocking until you are ready
;       in IDL 4.0 and earlier.
;
;       NCOLORS: This is the number of colors to load when a color table
;       is selected.
;
;       NOTIFYID: A a 2 column by n row array that contains the IDs of widgets
;       that should be notified when XCOLORS loads a color table. The first
;       column of the array is the widgets that should be notified. The
;       second column contains IDs of widgets that are at the top of the
;       hierarch in which the corresponding widgets in the first column
;       are located. (The purpose of the top widget IDs is to make it
;       possible for the widget in the first column to get the "info"
;       structure of the widget program.) An XCOLORS_LOAD event will be
;       sent to the widget identified in the first column. The event
;       structure is defined like this:
;
;       event = {XCOLORS_LOAD, ID:0L, TOP:0L, HANDLER:0L, $
;          r:BytArr(!D.N_COLORS < 256), g:BytArr(!D.N_COLORS < 256), $
;          b:BytArr(!D.N_COLORS < 256)}
;
;       The ID field will be filled out with NOTIFYID(0, n) and the TOP
;       field will be filled out with NOTIFYID(1, n). The R, G, and B
;       fields will have the current color table vectors, obtained by
;       exectuing the command TVLCT, r, g, b, /Get.
;
;       TITLE: This is the window title. It is "Load Color Tables" by
;       default. The program is registered with the name 'XCOLORS:' plus
;       the TITLE string. The register name is checked before the widgets
;       are defined. This gives you the opportunity to have XCOLORS
;       functionality in multiple windows, but only one version of XCOLORS
;       per window.
;
;       XOFFSET: This is the X offset of the program on the display. The
;       program will be placed approximately in the middle of the display
;       by default.
;
;       YOFFSET: This is the Y offset of the program on the display. The
;       program will be placed approximately in the middle of the display
;       by default.
;
; COMMON BLOCKS:
;       None.
;
; SIDE EFFECTS:
;       Colors are changed. Events are sent to widgets if the NOTIFYID
;       keyword is used. This program is a non-blocking widget in IDL 5
;       and a blocking widget in other versions of IDL.
;
; RESTRICTIONS:
;       None.
;
; EXAMPLE:
;       To load a color table into 100 colors, starting at color index
;       50 and send an event to the widget identified at info.drawID
;       in the widget heirarchy of the top-level base event.top, type:
;
;       XCOLORS, NCOLORS=100, BOTTOM=50, NOTIFYID=[info.drawID, event.top]
;
; MODIFICATION HISTORY:
;       Written by:     David Fanning, 15 April 97. Extensive modification
;         of an older XCOLORS program with excellent suggestions for
;         improvement by Liam Gumley. Now works on 8-bit and 24-bit
;         systems. Subroutines renamed to avoid ambiguity. Cancel
;         button restores original color table.
;       23 April 97, added color protection for the program. DWF
;       24 April 97, fixed a window initialization bug. DWF
;       18 June 97, fixed a bug with the color protection handler. DWF
;       18 June 97, Turned tracking on for draw widget to fix a bug
;         in TLB Tracking Events for WindowsNT machines in IDL 5.0. DWF
;       20 Oct 97, Changed GROUP keyword to GROUP_LEADER. DWF
;       19 Dec 97, Fixed bug with TOP/BOTTOM reversals and CANCEL. DWF.
;-

PRO XColors_Set, info

TVLCT, r, g, b, /Get

   ; Make sure the current bottom index is less than the current top index.

IF info.currentbottom GE info.currenttop THEN BEGIN
   temp = info.currentbottom
   info.currentbottom = info.currenttop
   info.currenttop = temp
ENDIF

r(info.bottom:info.currentbottom) = info.bottomcolor(0)
g(info.bottom:info.currentbottom) = info.bottomcolor(1)
b(info.bottom:info.currentbottom) = info.bottomcolor(2)
r(info.currenttop:info.top) = info.topcolor(0)
g(info.currenttop:info.top) = info.topcolor(1)
b(info.currenttop:info.top) = info.topcolor(2)

red = info.r
green = info.g
blue = info.b
number = ABS((info.currenttop-info.currentbottom) + 1)

gamma = info.gamma

index = Findgen(info.ncolors)
distribution = index^gamma
index = Round(distribution * (info.ncolors-1) / Max(distribution))

IF info.currentbottom GE info.currenttop THEN BEGIN
   temp = info.currentbottom
   info.currentbottom = info.currenttop
   info.currenttop = temp
ENDIF

IF info.reverse EQ 0 THEN BEGIN
   r(info.currentbottom:info.currenttop) = Congrid(red(index), number)
   g(info.currentbottom:info.currenttop) = Congrid(green(index), number)
   b(info.currentbottom:info.currenttop) = Congrid(blue(index), number )
ENDIF ELSE BEGIN
   r(info.currentbottom:info.currenttop) = $
      Reverse(Congrid(red(index), number))
   g(info.currentbottom:info.currenttop) = $
      Reverse(Congrid(green(index), number))
   b(info.currentbottom:info.currenttop) = $
      Reverse(Congrid(blue(index), number))
ENDELSE

TVLct, r, g, b
WSet, info.windowindex
TV, info.colorimage

   ; Are there widgets to notify?

s = SIZE(info.notifyID)
IF s(0) EQ 1 THEN count = 0 ELSE count = s(2)-1
FOR j=0,count DO BEGIN
   colorEvent = { XCOLORS_LOAD, $
                  ID:info.notifyID(0,j), $
                  TOP:info.notifyID(1,j), $
                  HANDLER:0L, $
                  R:r, $
                  G:g, $
                  B:b }
   IF Widget_Info(info.notifyID(0,j), /Valid_ID) THEN $
      Widget_Control, info.notifyID(0,j), Send_Event=colorEvent
ENDFOR

END ; ***************************************************************



PRO XCOLORS_GAMMA_SLIDER, event

   ; Get the info structure from storage location.

Widget_Control, event.top, Get_UValue=info, /No_Copy

   ; Get the gamma value from the slider.

Widget_Control, event.id, Get_Value=gamma
gamma = 10^((gamma/50.0) - 1)
info.gamma = gamma

   ; Update the gamma label.

Widget_Control, info.gammaID, Set_Value=String(gamma, Format='(F6.3)')

   ; Make a pseudo structure.

IF info.currentBottom GT info.currentTop THEN $
   pseudo = {currenttop:info.currentbottom, currentbottom:info.currenttop, $
      reverse:1, bottomcolor:info.topcolor, topcolor:info.bottomcolor, $
      gamma:info.gamma, top:info.top, bottom:info.bottom, $
      ncolors:info.ncolors, r:info.r, g:info.g, b:info.b, $
      notifyID:info.notifyID, colorimage:info.colorimage, $
      windowindex:info.windowindex} $
ELSE $
   pseudo = {currenttop:info.currenttop, currentbottom:info.currentbottom, $
      reverse:0, bottomcolor:info.bottomcolor, topcolor:info.topcolor, $
      gamma:info.gamma, top:info.top, bottom:info.bottom, $
      ncolors:info.ncolors, r:info.r, g:info.g, b:info.b, $
      notifyID:info.notifyID, colorimage:info.colorimage, $
      windowindex:info.windowindex}

   ; Load the colors.

XColors_Set, pseudo

   ; Put the info structure back in storage location.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END ; ************************************************************************



PRO XCOLORS_COLORTABLE, event

   ; Get the info structure from storage location.

Widget_Control, event.top, Get_UValue=info, /No_Copy

LoadCt, event.index, File=info.file, /Silent, $
   NColors=info.ncolors, Bottom=info.bottom

TVLct, r, g, b, /Get
info.r = r(info.bottom:info.top)
info.g = g(info.bottom:info.top)
info.b = b(info.bottom:info.top)
info.topcolor = [r(info.top), g(info.top), b(info.top)]
info.bottomcolor = [r(info.bottom), g(info.bottom), b(info.bottom)]

   ; Update the slider positions and values.

Widget_Control, info.botSlider, Set_Value=0
Widget_Control, info.topSlider, Set_Value=info.ncolors-1
Widget_Control, info.gammaSlider, Set_Value=50
Widget_Control, info.gammaID, Set_Value=String(1.0, Format='(F6.3)')
info.currentBottom = info.bottom
info.currentTop = info.top
info.gamma = 1.0

   ; Create a pseudo structure.

pseudo = {currenttop:info.currenttop, currentbottom:info.currentbottom, $
reverse:info.reverse, windowindex:info.windowindex, $
   bottomcolor:info.bottomcolor, topcolor:info.topcolor, gamma:info.gamma, $
   top:info.top, bottom:info.bottom, ncolors:info.ncolors, r:info.r, $
   g:info.g, b:info.b, notifyID:info.notifyID, colorimage:info.colorimage}

   ; Update the colors.

XColors_Set, pseudo

   ; Put the info structure back in storage location.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END ; ************************************************************************



PRO XCOLORS_BOTTOM_SLIDER, event

   ; Get the info structure from storage location.

Widget_Control, event.top, Get_UValue=info, /No_Copy

   ; Update the current bottom value of the slider.

info.currentBottom = info.bottom + event.value

   ; Error handling. Is currentBottom = currentTop?

IF info.currentBottom EQ info.currentTop THEN BEGIN
   info.currentBottom = info.currentTop
   Widget_Control, info.botSlider, Set_Value=(info.currentBottom-info.bottom)
ENDIF

   ; Error handling. Is currentBottom > currentTop?

IF info.currentBottom GT info.currentTop THEN BEGIN

   bottom = info.currentTop
   top = info.currentBottom
   bottomcolor = info.topColor
   topcolor = info.bottomColor
   reverse = 1

ENDIF ELSE BEGIN

   bottom = info.currentBottom
   top = info.currentTop
   bottomcolor = info.bottomColor
   topcolor = info.topColor
   reverse = 0

ENDELSE

   ; Create a pseudo structure.

pseudo = {currenttop:top, currentbottom:bottom, reverse:reverse, $
   bottomcolor:bottomcolor, topcolor:topcolor, gamma:info.gamma, $
   top:info.top, bottom:info.bottom, ncolors:info.ncolors, r:info.r, $
   g:info.g, b:info.b, notifyID:info.notifyID, colorimage:info.colorimage, $
   windowindex:info.windowindex}

   ; Update the colors.

XColors_Set, pseudo

   ; Put the info structure back in storage location.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END ; ************************************************************************




PRO XCOLORS_PROTECT_COLORS, event

   ; Get the info structure from storage location.

Widget_Control, event.top, Get_UValue=info, /No_Copy

   ; Create a pseudo structure.

pseudo = {currenttop:info.currenttop, currentbottom:info.currentbottom, $
   reverse:info.reverse, $
   bottomcolor:info.bottomcolor, topcolor:info.topcolor, gamma:info.gamma, $
   top:info.top, bottom:info.bottom, ncolors:info.ncolors, r:info.r, $
   g:info.g, b:info.b, notifyID:info.notifyID, colorimage:info.colorimage, $
   windowindex:info.windowindex}

   ; Update the colors.

WSet, info.windowindex
XColors_Set, pseudo

   ; Put the info structure back in storage location.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END ; ************************************************************************



PRO XCOLORS_TOP_SLIDER, event

   ; Get the info structure from storage location.

Widget_Control, event.top, Get_UValue=info, /No_Copy

   ; Update the current top value of the slider.

info.currentTop = info.bottom + event.value

   ; Error handling. Is currentBottom = currentTop?

IF info.currentBottom EQ info.currentTop THEN BEGIN
   info.currentBottom = (info.currentTop - 1) > 0
   thisValue = (info.currentBottom-info.bottom)
   IF thisValue LT 0 THEN BEGIN
      thisValue = 0
      info.currentBottom = info.bottom
   ENDIF
   Widget_Control, info.botSlider, Set_Value=thisValue
ENDIF

   ; Error handling. Is currentBottom > currentTop?

IF info.currentBottom GT info.currentTop THEN BEGIN

   bottom = info.currentTop
   top = info.currentBottom
   bottomcolor = info.topColor
   topcolor = info.bottomColor
   reverse = 1

ENDIF ELSE BEGIN

   bottom = info.currentBottom
   top = info.currentTop
   bottomcolor = info.bottomColor
   topcolor = info.topColor
   reverse = 0

ENDELSE

   ; Create a pseudo structure.

pseudo = {currenttop:top, currentbottom:bottom, reverse:reverse, $
   bottomcolor:bottomcolor, topcolor:topcolor, gamma:info.gamma, $
   top:info.top, bottom:info.bottom, ncolors:info.ncolors, r:info.r, $
   g:info.g, b:info.b, notifyID:info.notifyID, colorimage:info.colorimage, $
   windowindex:info.windowindex}

   ; Update the colors.

XColors_Set, pseudo

   ; Put the info structure back in storage location.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END ; ************************************************************************



PRO XCOLORS_CANCEL, event
Widget_Control, event.top, Get_UValue=info, /No_Copy

   ; Create a pseudo structure.

pseudo = {currenttop:info.currenttop, currentbottom:info.currentbottom, $
   reverse:info.reverse, windowindex:info.windowindex, $
   bottomcolor:info.bottomcolor, topcolor:info.topcolor, gamma:info.gamma, $
   top:info.top, bottom:info.bottom, ncolors:info.ncolors, r:info.rstart, $
   g:info.gstart, b:info.bstart, notifyID:info.notifyID, colorimage:info.colorimage}

   ; Update the colors.

XColors_Set, pseudo
Widget_Control, event.top, /Destroy
END ; ************************************************************************



PRO XCOLORS_DISMISS, event
Widget_Control, event.top, /Destroy
END ; ************************************************************************



PRO XCOLORS, NColors=ncolors, Bottom=bottom, Title=title, File=file, $
   Group_Leader=group, XOffset=xoffset, YOffset=yoffset, Just_Reg=jregister, $
   NotifyID=notifyID

   ; This is a procedure to load color tables into a
   ; restricted color range of the physical color table.
   ; It is a highly simplified version of XLoadCT.

On_Error, 1

   ; Make sure colors are initiated.

thisWindow = !D.Window
Window, /Pixmap, /Free, XSize=10, YSize=10
WDelete, !D.Window
IF thisWindow GE 0 THEN WSet, thisWindow

   ; Check keyword parameters. Define defaults.

IF N_Elements(ncolors) EQ 0 THEN ncolors = 256 < !D.N_Colors
IF N_Elements(bottom) EQ 0 THEN bottom = 0
top = bottom + (ncolors-1)
IF N_Elements(title) EQ 0 THEN title = 'Load Color Tables'
IF N_ELements(file) EQ 0 THEN $
   file = Filepath(SubDir=['resource','colors'], 'colors1.tbl')
IF N_Elements(notifyID) EQ 0 THEN notifyID = [-1L, -1L]

   ; Find the center of the display.

DEVICE, GET_SCREEN_SIZE=screenSize
xCenter = FIX(screenSize(0) / 2.0)
yCenter = FIX(screenSize(1) / 2.0)

IF N_ELEMENTS(xoffset) EQ 0 THEN xoffset = xCenter - 150
IF N_ELEMENTS(yoffset) EQ 0 THEN yoffset = yCenter - 200

registerName = 'XCOLORS:' + title

   ; Only one XCOLORS with this title.

IF XRegistered(registerName) THEN RETURN

   ; Create the top-level base. No resizing.

tlb = Widget_Base(Column=1, Title=title, TLB_Frame_Attr=1, $
   XOffSet=xoffset, YOffSet=yoffset, Base_Align_Center=1)

   ; Create a draw widget to display the current colors.

draw = Widget_Draw(tlb, XSize=256, YSize=40, Expose_Events=1, $
   Retain=0, Event_Pro='XCOLORS_PROTECT_COLORS')

   ; Create sliders to control stretchs and gamma correction.

sliderbase = Widget_Base(tlb, Column=1, Frame=1)
botSlider = Widget_Slider(sliderbase, Value=0, Min=0, $
   Max=ncolors-1, XSize=256, /Drag, Event_Pro='XColors_Bottom_Slider', $
   Title='Stretch Bottom')
topSlider = Widget_Slider(sliderbase, Value=ncolors-1, Min=0, $
   Max=ncolors-1, XSize=256, /Drag, Event_Pro='XColors_Top_Slider', $
   Title='Stretch Top')
gammaID = Widget_Label(sliderbase, Value=String(1.0, Format='(F6.3)'))
gammaSlider = Widget_Slider(sliderbase, Value=50.0, Min=0, Max=100, $
   /Drag, XSize=256, /Suppress_Value, Event_Pro='XColors_Gamma_Slider', $
   Title='Gamma Correction')

   ; Get the colortable names for the list widget.

colorNames=''
LoadCt, Get_Names=colorNames
FOR j=0,N_Elements(colorNames)-1 DO $
   colorNames(j) = StrTrim(j,2) + ' - ' + colorNames(j)
filebase = Widget_Base(tlb, Column=1, /Frame)
listlabel = Widget_Label(filebase, Value='Select Color Table...')
list = Widget_List(filebase, Value=colorNames, YSize=8, Scr_XSize=256, $
   Event_Pro='XColors_ColorTable')

   ; Dialog Buttons

dialogbase = WIDGET_BASE(tlb, Row=1)
cancel = Widget_Button(dialogbase, Value='Cancel', $
   Event_Pro='XColors_Cancel', UVALUE='CANCEL')
dismiss = Widget_Button(dialogbase, Value='Accept', $
   Event_Pro='XColors_Dismiss', UVALUE='ACCEPT')
Widget_Control, tlb, /Realize

   ; Get window index number of the draw widget.

Widget_Control, draw, Get_Value=windowIndex


   ; Put a picture of the color table in the window.

colorImage = BIndgen(256,40)
colorRow = BIndgen(ncolors)
colorRow = Congrid(colorRow, 256)
FOR j=0,39 DO colorImage(*,j) = colorRow
colorImage = BytScl(colorImage, Top=ncolors-1) + bottom
WSet, windowIndex
TV, colorImage

   ; Get the colors that make up the current color table
   ; in the range that this program deals with.

TVLCT, rr, gg, bb, /Get
r = rr(bottom:top)
g = gg(bottom:top)
b = bb(bottom:top)

topColor = [rr(top), gg(top), bb(top)]
bottomColor = [rr(bottom), gg(bottom), bb(bottom)]

   ; Create an info structure to hold information to run the program.

info = {  windowIndex:windowIndex, $   ; The WID of the draw widget.
          botSlider:botSlider, $       ; The widget ID of the bottom slider.
          currentBottom:bottom, $      ; The current bottom slider value.
          currentTop:top, $            ; The current top slider value.
          topSlider:topSlider, $       ; The widget ID of the top slider.
          gammaSlider:gammaSlider, $   ; The widget ID of the gamma slider.
          gammaID:gammaID, $           ; The widget ID of the gamma label
          ncolors:ncolors, $           ; The number of colors we are using.
          gamma:1.0, $                 ; The current gamma value.
          file:file, $                 ; The name of the color table file.
          bottom:bottom, $             ; The bottom color index.
          top:top, $                   ; The top color index.
          topcolor:topColor, $         ; The top color in this color table.
          bottomcolor:bottomColor, $   ; The bottom color in this color table.
          reverse:0, $                 ; A reverse color table flag.
          notifyID:notifyID, $         ; Notification widget IDs.
          r:r, $                       ; The red color vector.
          g:g, $                       ; The green color vector.
          b:b, $                       ; The blue color vector.
          rstart:r, $                  ; The original red color vector.
          gstart:g, $                  ; The original green color vector.
          bstart:b, $                  ; The original blue color vector.
          colorimage:colorimage }      ; The color table image.

   ; Store the info structure in the user value of the top-level base.

Widget_Control, tlb, Set_UValue=info, /No_Copy

thisRelease = StrMid(!Version.Release, 0, 1)
IF thisRelease EQ '5' THEN $
   XManager, registerName, tlb, Group=group, Just_Reg=Keyword_Set(jregister), $
      /No_Block ELSE $
   XManager, registerName, tlb, Group=group, Just_Reg=Keyword_Set(jregister)
END ; ************************************************************************
