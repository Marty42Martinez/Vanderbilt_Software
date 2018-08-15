topColor = !D.N_Colors-1
LoadCT, 3, NColors=!D.N_Colors-1
TvLCT, 255, 255, 0, topColor
TV, BytScl(image, Top=!D.N_Colors-2)
!Mouse.Button = 1
REPEAT BEGIN
   Cursor, col, row, /Down, /Device
   Print, 'Pixel Value: ', image(col, row)
ENDREP UNTIL !Mouse.Button NE 1
END