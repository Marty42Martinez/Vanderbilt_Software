;+
; NAME:
;       IMAGE_BLEND
;
; PURPOSE:
;       The purpose of this program is to demonstrate how to
;       use the alpha channel to blend one image into another.
;       The specific purpose is to see a color image on top of
;       a gray-scale image, with the gray-scale image showing
;       through behind the color image.
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
;       Widgets, Object Graphics.
;
; CALLING SEQUENCE:
;       Image_Blend
;
; REQUIRED INPUTS:
;       None. The images "worldelv.dat" and "ctscan.dat" from the
;       examples/data directory are used.
;
; OPTIONAL INPUTS:
;
;       backgroundImage::  A 2D image variable that will be used for the background image.
;       foregroundImage: A 2D image variable that will be used for the foreground image.
;
; OPTIONAL KEYWORD PARAMETERS:
;
;       COLORTABLE: The number of a color table to use for the foreground image.
;       Color table 3 (red temperature) is used as a default.
;
; COMMON BLOCKS:
;       None.
;
; SIDE EFFECTS:
;       None.
;
; RESTRICTIONS:
;       None. The program XCOLORS is required from the Coyote library.
;
; EXAMPLE:
;       Image_Blend, Colortable=5
;
; MODIFICATION HISTORY:
;       Written by David Fanning, 30 March 99.
;       Fixed bug where I redefined the image parameter. Duh... 1 April 99. DWF.
;-


PRO Image_Blend_Output, event

   ; This event handler creates GIF and JPEG files.

Widget_Control, event.top, Get_UValue=info, /No_Copy

   ; Get a snapshop of window contents. (TVRD equivalent.)

info.thisWindow->GetProperty, Image_Data=snapshot

   ; JPEG or GIF file wanted?

Widget_Control, event.id, Get_UValue=whichFileType
CASE whichFileType OF

   'GIF': BEGIN

         ; Because we are using a window set up for RGB color,
         ; snapshot contains a 3xMxN array. Use Color_Quan to
         ; create a 2D image and appropriate color tables for
         ; the GIF file.

      image2D = Color_Quan(snapshot, 1, r, g, b)
      filename = Dialog_Pickfile(/Write, File='idl.gif')
      IF filename NE '' THEN Write_GIF, filename, image2d, r, g, b
      END

   'JPEG': BEGIN

      filename = Dialog_Pickfile(/Write, File='idl.jpg')
      IF filename NE '' THEN Write_JPEG, filename, snapshot, True=1
      END

ENDCASE

    ;Put the info structure back.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END
;-------------------------------------------------------------------



PRO Image_Blend_Exit, event

   ; Exit the program via the EXIT button.
   ; The Image_Blend_CLEANUP procedure will be called automatically.

Widget_Control, event.top, /Destroy
END
;-------------------------------------------------------------------



PRO Image_Blend_Foreground_Colors, event

    ; This event handler changes foreground image colors.

Widget_Control, event.top, Get_UValue=info, /No_Copy

    ; Is this an XCOLORS event?

thisEvent = Tag_Names(event, /Structure_Name)
IF thisEvent EQ 'XCOLORS_LOAD' THEN BEGIN

   ; Set the color palette with the new colors.

   s = Size(*info.foregroundImage, /Dimensions)
   alpha_image = BytArr(4, s[0], s[1])
   alpha_image[0,*, *] = event.r[*info.foregroundImage]
   alpha_image[1,*, *] = event.g[*info.foregroundImage]
   alpha_image[2,*, *] = event.b[*info.foregroundImage]
   Widget_Control, info.sliderID, Get_Value=currentBlend
   alpha_image[3, *, *] = info.blendMask * currentBlend
   info.alphaImage->SetProperty, Data=alpha_image
   info.thisWindow->Draw, info.thisView

ENDIF ELSE XColors, NotifyID=[event.id, event.top], $
   Group_Leader=event.top, Title='Foreground Image Colors', $
   XOffset=100, YOffset=100
Widget_Control, event.top, Set_UValue=info, /No_Copy
END
;---------------------------------------------------------------------



PRO Image_Blend_Background_Colors, event

    ; This event handler changes background image colors.

Widget_Control, event.top, Get_UValue=info, /No_Copy

    ; Is this an XCOLORS event?

thisEvent = Tag_Names(event, /Structure_Name)
IF thisEvent EQ 'XCOLORS_LOAD' THEN BEGIN

   ; Set the color palette with the new colors.

   info.grayPalette->SetProperty, Red=event.r, Green=event.g, Blue=event.b
   info.thisWindow->Draw, info.thisView

ENDIF ELSE XColors, NotifyID=[event.id, event.top], $
   Group_Leader=event.top, Title='Background Image Colors', $
   XOffset=100, YOffset=200
Widget_Control, event.top, Set_UValue=info, /No_Copy
END
;---------------------------------------------------------------------



PRO Image_Blend_CleanUp, id

    ; Come here when the widget dies. Free all the program
    ; objects, pointers, pixmaps, etc. and release memory.

Widget_Control, id, Get_UValue=info
IF N_Elements(info) NE 0 THEN BEGIN
   Obj_Destroy, info.thisContainer
   Ptr_Free, info.foregroundImage
ENDIF
END
;---------------------------------------------------------------------



PRO Image_Blend_Slider, event

    ; This event handler sets the blending values.

Widget_Control, event.top, Get_UValue=info, /No_Copy

    ; Set the blend value.

info.alphaImage->GetProperty, Data=thisData
s = Size(*info.foregroundImage, /Dimensions)
thisData[3, *, *] = info.blendMask * event.value
info.alphaImage->SetProperty, Data=thisData
info.thisWindow->Draw, info.thisView

    ;Put the info structure back.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END
;---------------------------------------------------------------------



PRO Image_Blend_Expose, event

    ; This event handler responds to draw widget expose events..

Widget_Control, event.top, Get_UValue=info, /No_Copy

   ; Redisplay the graphic.

info.thisWindow->Draw, info.thisView

    ;Put the info structure back.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END
;---------------------------------------------------------------------



PRO Image_Blend_Event, event

    ; This is main event handler for the TLB. It currently
    ; handles resize events.

Widget_Control, event.top, Get_UValue=info, /No_Copy

    ; Resize the draw widget.

info.thisWindow->SetProperty, Dimension=[event.x, event.y*info.drawScale+15]

   ; Redisplay the graphic.

info.thisWindow->Draw, info.thisView

    ;Put the info structure back.

Widget_Control, event.top, Set_UValue=info, /No_Copy
END
;---------------------------------------------------------------------



PRO Image_Blend, backgroundImage, foregroundImage, Colortable=colortable

    ; Get images to display

IF N_Elements(backgroundImage) EQ 0 THEN BEGIN
   filename = Filepath(SubDir=['examples', 'data'], 'worldelv.dat')
   OpenR, lun, filename, /Get_LUN
   backgroundImage = BytArr(360,360)
   ReadU, lun, backgroundImage
   Free_Lun, lun
ENDIF

IF N_Elements(foregroundImage) EQ 0 THEN BEGIN
   filename = Filepath(SubDir=['examples', 'data'], 'ctscan.dat')
   OpenR, lun, filename, /Get_LUN
   foregroundImage = BytArr(256,256)
   ReadU, lun, foregroundImage
   Free_Lun, lun
ENDIF

IF N_Elements(colortable) EQ 0 THEN colortable = 3

    ; Create the gray color palette.

grayPalette = Obj_New('IDLgrPalette')
grayPalette->LoadCT, 0

   ; The foreground image must be 24-bit for alpha blending to work.

s = Size(foregroundImage, /Dimensions)
alpha_image = BytArr(4, s[0], s[1])
LoadCT, colortable
TVLCT, r, g, b, /Get
alpha_image[0, *, *] = r[foregroundImage]
alpha_image[1, *, *] = g[foregroundImage]
alpha_image[2, *, *] = b[foregroundImage]

   ; Pixels with value 0 with be totally transparent.
   ; Other pixels will start out half transparent.

blendMask = BytArr(s[0], s[1])
blendMask[Where(foregroundImage GT 0)] = 1B
alpha_image[3, *, *] = blendMask * 128B

backgroundImgObj = Obj_New('IDLgrImage', backgroundImage, $
   Dimensions=[400,400], Palette=grayPalette)

alphaImage = Obj_New('IDLgrImage', alpha_image, $
   Dimensions=[400,400], Interleave=0, $
   Blend_Func=[3,4])

   ; Create a model for the images. Add images to model.

thisModel = Obj_New('IDLgrModel')
thisModel->Add, backgroundImgObj
thisModel->Add, alphaImage

    ; Create a view.

viewRect = [0, 0, 400, 400]
thisView = Obj_New('IDLgrView', Viewplane_Rect=viewRect)
thisView->Add, thisModel

    ; Create the widgets for this program.

tlb = Widget_Base(Title='Image Overlay Example', $
   MBar=menubase, TLB_Size_Events=1, Column=1)

drawID = Widget_Draw(tlb, XSize=400, YSize=400, $
   Graphics_Level=2, Expose_Events=1, Retain=0, $
   Event_Pro='Image_Blend_Expose')

   ; Create a slider widget to control the amount of
   ; transparency in the foreground image.

sliderID = Widget_Slider(tlb, Scr_XSize=406, Min=0, Max=255, $
   Value=128, Title='Opacity Control', Event_Pro='Image_Blend_Slider')

    ; Create FILE menu buttons for output and exiting.

filer = Widget_Button(menubase, Value='File', /Menu)

   ; Create OUTPUT menu buttons for formatted output files.

output = Widget_Button(filer, Value='Output', /Menu)
b = Widget_Button(output, Value='GIF File', $
   UValue='GIF', Event_Pro='Image_Blend_Output')
b = Widget_Button(output, Value='JPEG File', $
   UValue='JPEG', Event_Pro='Image_Blend_Output')
b = Widget_Button(filer, Value='Quit', /Separator, $
   Event_Pro='Image_Blend_Exit')

   ; Create a colors menu.

colors = Widget_Button(menubase, Value='Colors', /Menu)
b = Widget_Button(colors, Value='Foreground Image Colors', $
   Event_Pro='Image_Blend_Foreground_Colors')
b = Widget_Button(colors, Value='Background Image Colors', $
   Event_Pro='Image_Blend_Background_Colors')

   ; Get geometry information for resizing.

tlbGeo = Widget_Info(tlb, /Geometry)
drawGeo = Widget_Info(drawID, /Geometry)
drawScale = Float(drawGeo.Scr_YSize) / tlbGeo.YSize

    ; Realize the widgets and get the window object.

Widget_Control, tlb, /Realize
Widget_Control, drawID, Get_Value=thisWindow

thisWindow->Draw, thisView

   ; Create a container object to hold all the other
   ; objects. This will make it easy to free all the
   ; objects when we are finished with the program.

thisContainer = Obj_New('IDL_Container')
thisContainer->Add, backgroundImgObj
thisContainer->Add, thisWindow
thisContainer->Add, thisModel
thisContainer->Add, grayPalette
thisContainer->Add, thisView

    ; Create an info structure to hold program information.

info = { thisContainer:thisContainer, $              ; The container object.
         thisWindow:thisWindow, $                    ; The window object.
         alphaImage:alphaImage, $                    ; The foreground image object.
         foregroundImage:Ptr_New(foregroundImage), $ ; The original foreground image.
         blendMask:blendMask, $                      ; A mask for screening blending values.
         grayPalette:grayPalette, $                  ; The background image palette.
         drawScale:drawScale, $                      ; The draw widget scaling factor.
         drawID:drawID, $                            ; The draw widget identifier.
         sliderID:sliderID, $                        ; The slider widget identifier.
         thisView:thisView}                          ; The object view.

Widget_Control, tlb, Set_UValue=info, /No_Copy

XManager, 'Image_Blend', tlb, Cleanup='Image_Blend_Cleanup', $
   Group_Leader=group, /No_Block
END