; $Id: cvttobm.pro,v 1.11 2003/02/03 18:13:09 scottm Exp $
;
; Copyright (c) 1996-2003, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;
;+
; NAME: Cvttobm
;
; PURPOSE:
;	Converts a byte array in which each byte represents one pixel
;       into a bitmap byte array in which each bit represents one
;       pixel. This is useful when creating bitmap labels for buttons
;       created with the WIDGET_BUTTON function.
;
;       Bitmap byte arrays are monochrome; by default, CVTTOBM converts
;       pixels that are darker than the median value to black and pixels
;       that are lighter than the median value to white. You can supply
;       a different threshold value via the THRESHOLD keyword.
;
;       Most of IDL's image file format reading functions (READ_BMP,
;       READ_PICT, etc.) return a byte array which must be converted
;       before use as a button label. Note that there is one exception
;       to this rule; the READ_X11_BITMAP routine returns a bitmap
;       byte array that needs no conversion before use.
;
; CATEGORY:
;
;       Widgets, button bitmaps
;
; CALLING SEQUENCE:
;
;	bitmap = Cvttobm(array [,THRESHOLD = Threshold])
;
; INPUTS:
;	array - A 2-dimensional pixel array, one byte per pixel
;
;
; OPTIONAL INPUTS:
;       None
;
;
; KEYWORD PARAMETERS:
;
;	THRESHOLD - A byte value (or an integer value between 0 and 255)
;                   to be used as a threshold value when determining if
;                   a particular pixel is black or white. If not specified,
;                   the threshold is calculated to be the average of the
;                   input array.
;
; OUTPUTS:
;	bitmap - bitmap byte array, in which each bit represents one pixel
;
;
; OPTIONAL OUTPUTS:
;       None
;
;
; COMMON BLOCKS:
;       None
;
;
; SIDE EFFECTS:
;       None
;
;
; RESTRICTIONS:
;       None
;
;
; PROCEDURE:
; 1. Creates mask from input array, where values are 0/1 based on threshold.
; 2. Calculates the size of the output array.
; 3. Calculates the bitmap array from byte array based on mask.
;
; EXAMPLE:
;
; IDL> image=bytscl(dist(100))
; IDL> base=widget_base(/column)
; IDL> button=widget_button(base,value=Cvttobm(image))
; IDL> widget_control,base,/realize
;
;
; MODIFICATION HISTORY:
;       Created: Mark Rehder, 10/96
;       Modified: Lubos Pochman, 10/96
;-

function bmtocvt, bmp
	; converts a bitmap to a byte map.
	; may be one or two dimensional [not more]

	; the chris way
	sm = size(bmp)
	dims = sm[1:sm[0]]
	dims[0] = dims[0] * 8
	out = make_array(dims, /byte)

	two_n = [1b,2b,4b,8b,16b,32b,64b,128b]
	for n=0,7 do out[n:*:8, *] = (bmp AND two_n[n]) < 1

	return, out

end
