;+
; NAME:
;       GETIMAGE
;
; PURPOSE:
;       The purpose of this function is to allow the user to open either
;       regular or XDR binary image files of two or three dimensions.
;
; CATEGORY:
;       Widgets, File I/O.
;
; CALLING SEQUENCE:
;       image = GETIMAGE(filename)
;
; INPUTS:
;       filename: The name of the file to open for reading.
;
; KEYWORD PARAMETERS:
;
;       CANCEL: An output variable that can be set to a named variable.
;       The value of the return variable will be 1 if the user clicked
;       the "Cancel" button or if there was a problem reading the file.
;
;       DIRECTORY: The name of the directory the file is located in. By
;       default the program looks in the "training" directory under the
;       main IDL directory, if one exists. Otherwise, it defaults to the
;       current directory.
;
;       FRAMES: The 3rd dimension of a 3D data set. Defaults to 0.
;
;       HEADER: The size of any header information in the file in BYTES.
;       Default is 0.
;
;       PARENT: The group leader for this widget program. The PARENT is
;       required if GETIMAGE is called from another widget program.
;
;       XDR: Set this keyword if the binary file is of XDR type.
;
;       XOFFSET: This is the X offset of the program on the display. The
;       program will be placed approximately in the middle of the display
;       by default.
;
;       XSIZE: The size of the 1st dimension of the data.
;
;       YOFFSET: This is the Y offset of the program on the display. The
;       program will be placed approximately in the middle of the display
;       by default.
;
;       YSIZE: The size of the 2nd dimension of the data.
;
; COMMON BLOCKS:
;       None.
;
; SIDE EFFECTS:
;       A "CANCEL" operation is indicated by a 0 return value.
;       Any error in reading the file results in a 0 return value.
;
; RESTRICTIONS:
;       None.
;
; EXAMPLE:
;       To load the image "galaxy.dat" in the $IDL/examples/data
;       directory, type:
;
;       image = GETIMAGE('galaxy.dat', DIRECTORY=!DIR + '/examples/data', $
;          XSIZE=256, YSIZE=256, Cancel=cancelled, Parent=event.top)
;       IF NOT cancelled THEN TV, image
;
; MODIFICATION HISTORY:
;       Written by: David Fanning, 3 February 96.
;       Fixed bug that prevented reading INTEGER data. 19 Dec 96.
;       Modifed program for IDL 5 MODAL operation. 19 Oct 97.
;       Added CANCEL keyword. 27 Oct 97. DWF.
;-



PRO GETIMAGE_INTEGER_ONLY, event

; This event handler for text widgets only allows integers to be entered
; in the text widget. A maximum of four digits are allowed.

   ; Deal with simple one-character insertion events.

IF event.type EQ 0 THEN BEGIN

      ; Get the current text in the widget and find its length.

   Widget_Control, event.id, Get_Value=text
   text = text(0)
   length = StrLen(text)

      ; Only react if the insertion character is a number and there
      ; are less than four characters already in the widget.

   IF Byte(event.ch) GE 48B AND Byte(event.ch) LE 57B $
      AND length LT 4 THEN BEGIN

         ; Get the current text selection.

      selection = Widget_Info(event.id, /Text_Select)

         ; Insert the character at the proper location.

      Widget_Control, event.id, /Use_Text_Select, Set_Value=String(event.ch)

         ; Update the current insertion point in the text widget.

      Widget_Control, event.id, Set_Text_Select=event.offset + 1

   ENDIF

ENDIF ; of insertion event

   ; Deal with deletion events.

IF event.type EQ 2 THEN BEGIN

      ; Get the current text in widget.

   Widget_Control, event.id, Get_Value=text
   text = text(0)
   length = StrLen(text)

      ; Put it back with the deletion subtracted.

   Widget_Control, event.id, Set_Value=StrMid(text, 0, length-event.length)

      ; Reset the text insertion point in the text widget.

   Widget_Control, event.id, Set_Text_Select=event.offset
ENDIF

END ;-------------------------------------------------------------------------



PRO GETIMAGE_NULL_EVENTS, event

   ; The purpose of this event handler is to do nothing
   ;and ignore all events that come to it.

END ;-------------------------------------------------------------------------



FUNCTION GETIMAGE_FIND_COYOTE

   ; The purpose of this function is to find the "coyote"
   ; training directory and return its path. If no
   ; directory is found, the function returns a null string.

ON_ERROR, 1

   ; Check this directory first.

CD, Current=thisDir
IF STRPOS(STRUPCASE(thisDir), 'COYOTE') GT 0 THEN RETURN, thisDir

   ; Look in !Path directories.

pathDir = EXPAND_PATH(!Path, /Array)
s = SIZE(pathDir)
IF s(1) LT 1 THEN RETURN, ''
FOR j=0,s(1)-1 DO BEGIN
   check = STRPOS(STRUPCASE(pathDir(j)), 'COYOTE')
   IF check GT 0 THEN RETURN, pathDir(j)
ENDFOR
RETURN, ''
END ;-------------------------------------------------------------------------



PRO GETIMAGE_EVENT, event

   ; The only events that can come here are button events.

   ; Get the info structure out of the user value of the top-level base.

Widget_Control, event.top, Get_UValue=info

   ; There may be errors we can't anticipate. Catch them here, alert the
   ; user as to what the error was, and exit the event handler without
   ; doing any damage.

Catch, error
IF error NE 0 THEN BEGIN
   ok = Widget_Message(!Err_String)
   formdata = {cancel:1}
   *info.ptrToFormData =formdata
   Widget_Control, event.top, /Destroy
   RETURN
ENDIF

   ; Which button caused this event?

Widget_Control, event.id, Get_Value=buttonValue

CASE buttonValue OF

   'Pick Filename': BEGIN

         ; Start in the directory listed in the directory text widget.
         ; Convert the text value to a scalar.

      Widget_Control, info.dirnameID, Get_Value=startDirectory
      startDirectory = startDirectory(0)

         ; If this directory doesn't exist, use the current directory.

      test = Findfile(startDirectory, Count=foundfile)
      IF foundfile NE 1 THEN CD, Current=startDirectory

         ; Use PICKFILE to pick a name.

      pick = Pickfile(Path=startDirectory, /NoConfirm, $
         Get_Path=path, Filter='*.')

         ; Set the directory text widget with the name of the directory.
         ; Make sure the user didn't cancel out of PICKFILE.

      IF pick NE '' THEN BEGIN

            ; Find the lengths of the PICK and the PATH.

         pathLen = StrLen(path)
         picklen = StrLen(pick)

           ; Shorten the PATH to take off last file separator.

         path = StrMid(path,0,pathLen-1)

            ; Put the PATH in the directory location.

         Widget_Control, info.dirnameID, Set_Value=path

            ; Set the filename text widget with the name of the file.

         filename = StrMid(pick, pathlen, picklen-pathlen)
         Widget_Control, info.filenameID, Set_Value=filename

      ENDIF

      END ; of the Pick Filename button case

    'Cancel': BEGIN

         ; Have to exit here gracefully. Set the "CANCEL" flag.

      formdata = {cancel:1}
      *info.ptrToFormData =formdata

         ; Out of here!

      Widget_Control, event.top, /Destroy
      END ; of the Cancel button case

    'Accept': BEGIN  ; Gather the form information.

          ; Put the directory and filename together to make a path.

       Widget_Control, info.dirnameID, Get_Value=directory
       Widget_Control, info.filenameID, Get_Value=file

       filename = Filepath(Root_Dir=directory(0),file(0))

          ; Get the size and header info. Remember these are STRINGS!

       Widget_Control, info.headerID, Get_Value=header
       Widget_Control, info.xsizeID, Get_Value=xsize
       Widget_Control, info.ysizeID, Get_Value=ysize
       Widget_Control, info.frameID, Get_Value=frames

       header = Fix(header(0))
       xsize =  Fix(xsize(0))
       ysize =  Fix(ysize(0))
       frames =  Fix(frames(0))

          ; Get the data type from the droplist widget.

       listIndex = Widget_Info(info.droplistID, /Droplist_Select)
       datatype = info.datatypes(listIndex)

          ; Get the format index from the formatlist widget.

       formatIndex = Widget_Info(info.formatlistID, /Droplist_Select)

          ; Create the formdata structure from the information you collected.

       formdata = {header:header, xsize:xsize, ysize:ysize, frames:frames, $
          filename:filename, datatype:datatype, formatIndex:formatIndex, cancel:0}

          ; Store the formdata in the pointer location.

       *info.ptrToFormData = formdata

         ; Out of here!

      Widget_Control, event.top, /Destroy
      END ; of the Accept button case

ENDCASE

END ; of GETIMAGE_EVENT event handler ***************************************



FUNCTION GETIMAGE, filename, Directory=directory, XSize=xsize, YSize=ysize, $
   Frames=frames, Header=header, Parent=parent, XDR=xdr, XOffSet=xoffset, $
   YOffSet=yoffset, Cancel=canceled

   ; This is a function to specify the size, data type, and header information
   ; about an image that you would like to read. It reads the data and returns
   ; it as the result of the function. If an error occurs or the user CANCELS,
   ; the function returns a 0.

   ; Must have IDL 5 because of pointers and other functionality.

thisRelease = StrMid(!Version.Release, 0, 1)
IF thisRelease NE '5' THEN BEGIN
   ok = Widget_Message('This program requires IDL 5 functionality. Sorry.')
   RETURN, 0
ENDIF

   ; Check for parameters and keywords.

IF N_Params() EQ 0 THEN filename='ctscan.dat'

   ; If DIRECTORY keyword is not used, use the "coyote" directory.
   ; If that is not found, use the current directory.

IF N_Elements(directory) EQ 0 THEN BEGIN

   startDirectory = GetImage_Find_Coyote()
   IF startDirectory EQ '' THEN CD, Current=startDirectory

ENDIF ELSE startDirectory = directory

   ; If the default file is not in the directory, make the filename
   ; a null string.

thisFile = Filepath(Root_Dir=startDirectory, filename)
ok = Findfile(thisFile, Count=count)
IF count EQ 0 THEN filename = ''

   ; Check for size and header keywords. These probably come in as
   ; numbers and you need strings to put them into text widgets.

IF N_Elements(xsize) EQ 0 THEN xsize='256' ELSE xsize=StrTrim(xsize,2)
IF N_Elements(ysize) EQ 0 THEN ysize='256' ELSE ysize=StrTrim(ysize,2)
IF N_Elements(frames) EQ 0 THEN frames='0' ELSE frames=StrTrim(frames,2)
IF N_Elements(header) EQ 0 THEN header='0' ELSE header=StrTrim(header,2)

   ; Find the center of the display.

Device, Get_Screen_Size=screenSize
xCenter = Fix(screenSize(0) / 2.0)
yCenter = Fix(screenSize(1) / 2.0)

IF N_Elements(xoffset) EQ 0 THEN xoffset = xCenter - 275
IF N_Elements(yoffset) EQ 0 THEN yoffset = yCenter - 150

   ; Create a modal top-level base if PARENT is present.

IF N_Elements(parent) EQ 0 THEN $
   tlb = Widget_Base(Column=1, Title='Read Image Data', XOffSet=xoffset, $
      YOffSet=yoffset) ELSE $
   tlb = Widget_Base(Column=1, Title='Read Image Data', XOffSet=xoffset, $
      YOffSet=yoffset, Modal=1, Group_Leader=parent)

   ; Create the directory widgets.

dirnamebase = Widget_Base(tlb, Row=1)
   dirnamelabel = Widget_Label(dirnamebase, Value='Directory:')
   dirnameID = Widget_Text(dirnamebase, Value=startDirectory, /Editable, $
      Event_Pro='GETIMAGE_NULL_EVENTS', XSize=Fix(2.0*StrLen(startDirectory) > 50))

   ; Create the filename widgets.

filenamebase = Widget_Base(tlb, Row=1)
   filenamelabel = Widget_Label(filenamebase, Value='Filename:')
   filenameID = Widget_Text(filenamebase, Value=filename, /Editable, $
      Event_Pro='GETIMAGE_NULL_EVENTS', XSize=2*StrLen(filename) > 20)

   ; Create a button to allow user to pick a filename.

pickbutton = Widget_Button(filenamebase, Value='Pick Filename')

   ; Create a droplist widget to select file data types.

database = Widget_Base(tlb, Row=1)
   datatypes = ['Byte', 'Integer', 'Long', 'Float']
   droplistID = Widget_Droplist(database, Value=datatypes, $
      Title='Data Type: ', Event_Pro='GETIMAGE_NULL_EVENTS')

   ; Create a droplist widget to select file formats.

   formatlistID = Widget_Droplist(database, Value=['None', 'XDR'], $
      Title='File Format: ', Event_Pro='GETIMAGE_NULL_EVENTS')

   ; Create a text widget to accept a header size.

   headlabel = Widget_Label(database, Value='Header Size:')
   headerID = Widget_Text(database, Value=header, All_Events=1, Editable=0, $
      Event_Pro='GETIMAGE_INTEGER_ONLY', XSize=8)

   ; Create widgets to gather the required file sizes.

sizebase = Widget_Base(tlb, Row=1)
   xlabel = Widget_Label(sizebase, Value='X Size:')
   xsizeID = Widget_Text(sizebase, Value=xsize, All_Events=1, Editable=0, $
      Event_Pro='GETIMAGE_INTEGER_ONLY', XSize=8)
   ylabel = Widget_Label(sizebase, Value='Y Size:')
   ysizeID = Widget_Text(sizebase, Value=ysize, All_Events=1, Editable=0, $
      Event_Pro='GETIMAGE_INTEGER_ONLY', XSize=8)
   zlabel = Widget_Label(sizebase, Value='Frames:')
   frameID = Widget_Text(sizebase, Value=frames, All_Events=1, Editable=0, $
      Event_Pro='GETIMAGE_INTEGER_ONLY', XSize=8)

   ; Create cancel and accept buttons.

cancelbase = Widget_Base(tlb, Column=2, Frame=1)
   cancel = Widget_Button(cancelbase, Value='Cancel')
   accept = Widget_Button(cancelbase, Value='Accept')

   ; Realize the program.

Widget_Control, tlb, /Realize

   ; Create a pointer to store the information collected from the form.

ptrToFormData = Ptr_New({cancle:1})

   ; Set the correct file format in the format droplist widget.

Widget_Control, formatlistID, Set_Droplist_Select=Keyword_Set(xdr)

   ; Set the text insertion point at the end of the filename text widget.

tip = [StrLen(filename),0]
Widget_Control, filenameID, Input_Focus=1
Widget_Control, filenameID, Set_Text_Select=tip

   ; Create an info structure with program information.

info = { filenameID:filenameID, $
         dirnameID:dirnameID, $
         xsizeID:xsizeID, $
         ysizeID:ysizeID, $
         frameID:frameID, $
         headerID:headerID, $
         droplistID:droplistID, $
         formatlistID:formatlistID, $
         datatypes:datatypes, $
         ptrToFormData:ptrToFormData}

  ; Store the info structure in the user value of the top-level base.

Widget_Control, tlb, Set_UValue=info

   ; The form will be a MODAL or BLOCKING widget, depending upon the
   ; presence of the PARENT.

XManager, 'getimage', tlb, Event_Handler='GETIMAGE_EVENT'

   ; Get the form data that was collected by the form.

formdata = *ptrToFormData

   ; If there is nothing here. Free the pointer and return.

IF N_Elements(formdata) EQ 0 THEN BEGIN
   Ptr_Free, ptrToFormData
   canceled = 1
   RETURN, 0
ENDIF

   ; Did the user cancel out of the form? If so, return a 0.

IF formdata.cancel EQ 1 THEN BEGIN
   Ptr_Free, ptrToFormData
   canceled = 1
   RETURN, 0
ENDIF

   ; Make the proper sized image array. Check for success.

image = 0
IF STRUPCASE(formdata.datatype) EQ 'INTEGER' THEN formdata.datatype = 'INT'
IF formdata.frames EQ 0 THEN $
   command = 'image = Make_Array(formdata.xsize, formdata.ysize, ' + $
      formdata.datatype + '=1)' ELSE $
   command = 'image = Make_Array(formdata.xsize, ' + $
      'formdata.ysize, formdata.frames, ' + formdata.datatype + '=1)'

check = Execute(command)
IF check EQ 0 THEN BEGIN
   ok = Widget_Message("Problem making image array. Returning 0.")
   canceled = 1
   RETURN, 0
ENDIF

   ; We can have all kinds of trouble reading data. Let's catch all
   ; input and output errors and alert user without crashing the program!

Catch, error
IF error NE 0 THEN BEGIN

      ; If we can't read the file for some reason, let the user know
      ; why, free the pointer and its information, check the logical
      ; unit number back in if it is checked out, and return a 0.

   ok = Dialog_Message(!Err_String)
   Ptr_Free, ptrToFormData
   canceled = 1
   IF N_ELements(lun) NE 0 THEN Free_Lun, lun
   RETURN, 0
ENDIF

   ; Set the canceled flag.

canceled = formdata.cancel

   ; Read the data file.

IF formdata.header GT 0 THEN header = BytArr(formdata.header)
Get_Lun, lun
OpenR, lun, formdata.filename, XDR=formdata.formatIndex
IF formdata.header EQ 0 THEN ReadU, lun, image $
   ELSE ReadU, lun, header, image
Free_Lun, lun

   ; Free the pointer.

Ptr_Free, ptrToFormData

RETURN, image

END ; of GETIMAGE program ***************************************************
