; Batch file to print a frames call to the printer device

; Initialize Stuff
bins = 72
!p.multi= [0,1,2]
loadct, 12
!x.style=1
!y.style=1
set_plot, 'printer', /copy
device, xoff=2,yoff=2, xsize=15, ysize=24, set_font='Times Bold', /tt_font
angle = (360./bins)*findgen(bins)

