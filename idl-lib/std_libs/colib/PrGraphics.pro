PRO PrGraphics

currdevice=!D.NAME

; Get the image from the current window.
image = TVRD()

; Make the printer the current device.
SET_PLOT, 'PRINTER', /copy
xOldSize = !D.X_SIZE ;Retain x for user.
yOldSize = !D.Y_SIZE ;Retain y for user.

; Get the true printer device sizes for SF of 1.
DEVICE, SCALE_FACTOR = 1

; Get the printer device size.
xSize = !D.X_SIZE
ySize = !D.Y_SIZE

; Compute the controlling aspect ratio.
aspX = (SIZE(image))[1]
aspY = (SIZE(image))[2]
aspC = (FLOAT(aspX) / xSize) > (FLOAT(aspY) / ySize)

scaleFactor = 1.0 / aspC

DEVICE, SCALE_FACTOR = scaleFactor

; Send image to printer
TV, image

;Close printer device and restore original device
DEVICE, /CLOSE_DOC
SET_PLOT, currdevice

END