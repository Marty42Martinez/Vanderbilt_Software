topColor = !D.N_Colors-1
LoadCT, 3, NColors=!D.N_Colors-1
TvLCT, 255, 255, 0, topColor
TV, BytScl(image, Top=!D.N_Colors-2)
!Mouse.Button = 1

   ; Create a pixmap window and display image in it.

Window, 1, /Pixmap, XSize=360, YSize=360
TV, BytScl(image, Top=!D.N_Colors-2)

   ;Make the display window the current graphics window.

WSet, 0

   ; Get inital cursor location. Draw cross-hair.

Cursor, col, row, /Device, /Down
PlotS, [col,col], [0,360], /Device, Color=topColor
PlotS, [0,360], [row,row], /Device, Color=topColor
Print, 'Pixel Value: ', image(col, row)

   ; Loop.

REPEAT BEGIN

      ; Get new cursor location.

   Cursor, colnew, rownew, /Down, /Device

      ; Erase old cross-hair.

   Device, Copy=[0, 0, 360, 360, 0, 0, 1]
   Print, 'Pixel Value: ', image(colnew, rownew)

      ; Draw new cross-hair.

   PlotS, [colnew,colnew], [0,360], /Device, Color=topColor
   PlotS, [0,360], [rownew,rownew], /Device, Color=topColor
ENDREP UNTIL !Mouse.Button NE 1

   ;Erase the final cross-hair.

Device, Copy=[0, 0, 360, 360, 0, 0, 1]
END
