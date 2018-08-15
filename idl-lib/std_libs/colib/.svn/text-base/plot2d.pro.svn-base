 PRO plot2d, z, x, y, magnify = magnify, bartitle=bartitle,  $
	ctable=ctable, oplot=oplot, mini=min, maxi=max, mask=mask, $
	xlog=xlog, ylog=ylog, xrange=xrange, yrange=yrange, _extra=_extra, missing=missing, $
	xticknames=xticknames, ytickname=yticknames, position=position, bposition=bposition, $
	divisions=divisions, minor=minor, format=format, logarithmic=logarithmic, $
	bcharsize=bcharsize, ticknames=ticknames, yx=yx, colorbar=colorbar, $
	void_index = void_index, reverse_y = reverse_y, horizontal = horizontal

; PLOT2D is a generic 2D plotter.
; It works similarly to the native PLOT command when no colorbar is used.
; When a colorbar is used, it by default takes up most of the available plotting window (so it won't
; work with nonstandard !p.multi in this case)
; Accepts pretty much all the keywords that PLOT accepts.

;	Author 		:	Chris O'Dell, Colorado State University



; INPUT VARIABLES
;	Z	:	Dependent data (1 or 2 dimensional).  If 2D, it is assumed that the first dimension of
;			Z corresponds to the x (horizontal) axis data.  If it's the other way around, make sure
;			you set the /YX keyword.
;   X   :   The x-axis data; optional.  If this is not set, it is indexed along the first
;			dimension of Z (if YX is not set), otherwise it is indexed along the
;			second dimension of Z.
;	Y   :   Just like X, but for the Y-data.  Also optional.

; OPTIONAL KEYWORDS
;	magnify		:	Set this to an integer greater than 1 to magnify each pixel.  Uses IDL's
;					native DILATE function
;
;	ctable		:	Index number of colortable to be used.
;	oplot		:	Overplot instead of re-drawing the window
;	min			:	All Z values lower than this are plotted as if they had this value.
;	max			:	All Z values higher than this are plotted as if they had this value.
;	mask		:	A byte mask of the Z values to actually plot.  This functions in addition
;					to void_index.
;	void_index	:	Indices of Z values not to plot. This functions in addition to mask.
;	yx			: 	Set this if the first dimension of Z is the Y axis.
;   position	:	Set this to plotting position within window.  [x0,y0,x1,y1] where
;					(x0,y0) is the lower-left and (x1,y1) is the upper right. Normalized
;					units (0-1) assumed.
;	logarithmic	:	Set this to use logarithmic plotting of Z variable.  It is best to set a
;					Min value greater than zero when use this option.
;	colorbar	:	Set this if you want a colorbar (default is no colorbar)
;	reverse_y	:	Set this if you want to reverse the y-dimension (useful for cloudsat data).

;   PLOT Keywords explicitly accepted : XLOG, YLOG, XRANGE, YRANGE, XTICKNAMES, YTICKNAMES
;	PLOT Keywords implicitly accepted : pretty much all the other ones!

;   COLORBAR KEYWORDS
;	bposition	:   Same as position but sets the position of the colorbar.
;	horizontal	:   Set this to make horizontal colorbar below the plot, instead of the default
;					(which is a vertical colorbar to the left of the plot).
;	bartitle	:	Title of the colorbar
;	bcharsize	:	Size of characters in colorbar title
;	minor		: 	Number of minor divisions
;	format		: 	Format code used for the ticknames
;	ticknames	:	Set this to a string array explicitly containing the names of the colorbar ticks
;

sz = size(z)
if n_elements(yx) eq 0 then yx = 0
if n_elements(x) eq 0 then begin
	if sz[0] ne 2 then begin
		print, 'Z must be 2-dimensional if you do not give x,y data!'
		return
	endif
	x = findgen(sz[1+yx])
endif
if n_elements(y) eq 0 then begin
	y = findgen(sz[2-yx])
	if keyword_set(reverse_y) then y = reverse(y)
endif

if n_elements(missing) eq 0 then missing = !p.background
  if n_elements(xrange) eq 0 then xrange = [min(x, max=dummy), dummy]
  if n_elements(yrange) eq 0 then yrange = [min(y, max=dummy), dummy]
  xr_ = xrange
  yr_ = yrange
; 1. Deal with Color Table
;-------------------------------------------------------------
if n_elements(ctable) eq 0 then ctable = 0 ; set the default color table
tvlct, rold, gold, bold, /get ; get current color table
;COMMON colors, rc, gc, bc ; get the colors in the common block "colors"
if ( CTABLE GT 0 AND CTABLE LT 40) then begin
	if !version.os_family eq 'Windows' then $
		ctfile = 'p:\idlprogs\aos\wis_image\wis_color_tables.tbl' $
	else $
		ctfile = '~/idlprogs/aos/wis_image/wis_color_tables.tbl'
	loadct, ctable, file=ctfile, /silent
endif	else begin
	;set white, black, and grey (reserved colors)
	i_white = 255 & i_grey=1 & i_black = 0
	r = rold & g = gold & b = bold
	r[i_white] = 255 & g[i_white] = 255 & b[i_white] = 255
	r[i_black] = 0 & g[i_black] = 0 & b[i_black] = 0
	r[i_grey] = 127 & g[i_grey] = 127 & b[i_grey] = 127
	tvlct, r, g, b
endelse

if n_elements(position) eq 0 AND keyword_set(colorbar) then begin
		if keyword_set(horizontal) then position = [0.05, 0.18, 0.95, 0.9] $
			else position = [0.23,0.1,0.93,0.9]
endif

if n_elements(bposition) eq 0 AND keyword_set(colorbar) then begin
  bposition = position
  if keyword_set(horizontal) then begin
	  bposition[0] = 0.2
   	  bposition[2] = 0.8
   	  bposition[1] = 0.07
   	  bposition[3] = 0.1
  endif else begin
  	  bposition[0] = (position[0] - 0.16 * (position[2] - position[0])) > 0
   	  bposition[2] = (position[0] - 0.14  * (position[2] - position[0])) > bposition[0] + 0.01
  endelse
endif



; 2. Deal with x and y arrays.
;-------------------------------------------------------------
  x_ = x
  if n_elements(y) eq 0 then y = x
  y_ = y
  if n_elements(x) ne n_elements(z) then begin
  	if sz[0] ne 2 then begin
  		print, 'Z must be 2-dimensional if x is one dimensional! Quitting.'
  		STOP
  	endif
  	if yx then x_ = (fltarr(sz[1]) + 1.) # x_ else x_ = x_ # (fltarr(sz[2])+1.)
  endif
  if n_elements(y) ne n_elements(z) then begin
    if sz[0] ne 2 then begin
  		print, 'Z must be 2-dimensional if y is one dimensional! Quitting.'
  		STOP
  	endif
  	if yx then y_ = y # (fltarr(sz[2])+1.) else y_ = (fltarr(sz[1]) + 1.) # y_
  endif

  if keyword_set(xlog) then begin
  	x_ = alog10(x_)
  	xr_ = alog10(xr_)
  endif
  if keyword_set(ylog) then begin
  	y_ = alog10(y_)
  	yr_ = alog10(yr_)
  endif

; deal with void pixels
   if n_elements(mask) GT 0 OR n_elements(void_index) GT 0 then begin
   	  if n_elements(mask) eq n_elements(z) then good_indices = mask else good_indices = byte(z*0.0) + 1b
   	  if keyword_set(void_index) then begin
  	    if size(void_index, /type) eq 7 then begin
		   ; void_index is a string.  Example 'LT 0'.
		   ; this is interpreted as where the input image is less than zero.
		   err = execute('wvoid = where(z ' + void_index + ')')
	    endif else wvoid = void_index
	    if wvoid[0] ne -1 then good_indices[wvoid] = 0b
	  endif

   	  wgood = where(good_indices)
   	  x_ = x_[wgood]
   	  y_ = y_[wgood]
   	  z_ = z [wgood]
   endif else z_ = z

; Create the initial plot with xtitle, ytitle, axis.
if not(keyword_set(oplot)) then $
  plot, x, y, /nodata, xlog=xlog, ylog=ylog, xrange=xrange, yrange=yrange, $
    _extra=_extra, xticknam=xticknames, yticknam=yticknames, position=position

if n_elements(position) eq 0 then position = [!x.window[0], !y.window[0], !x.window[1], !y.window[1]]


nxpix = !d.x_size
nypix = !d.y_size
if ( !d.flags and 1 ) then begin
  nxpix = 640L
  nypix = long( float( nxpix ) * float( !d.y_size ) / float( !d.x_size ) )
endif

xoffset= long(position[0] * nxpix) + 1
yoffset= long(position[1] * nypix) + 1

nxpix = long(nxpix * (position[2] - position[0]))-2
nypix = long(nypix * (position[3] - position[1]))-2

; Create the image.  For each pixel, calculate a 2-254 byte value.
image = bytarr(nxpix, nypix)

; convert each (x,y) location to a given pixel in image.
dx = float(xr_[1] - xr_[0]) / nxpix
dy = float(yr_[1] - yr_[0]) / nypix
xb = long((x_ - xr_[0])/(xr_[1]-xr_[0]) * nxpix)  ; all x pixel locations
yb = long((y_ - yr_[0])/(yr_[1]-yr_[0]) * nypix)  ; all y pixel locations

xb = (xb > 0) < (nxpix-1)
yb = (yb > 0) < (nypix-1)

if n_elements(min) eq 0 then min= min(z_) + 0.
if n_elements(max) eq 0 then max = max(z_) + 0.
pix = xb + nxpix * yb
if keyword_set(logarithmic) then begin
  image[pix] = bytscl(alog10(z_ > 1e-20), min=alog10(min > 1e-20), max=alog10(max > 1e-19), top = 252,/nan) + 2
endif else begin
  image[pix] = ((round((z_-min)/(max-min)*252) + 2) > 2) < 254
endelse

;magnify with consecutive boxes.
structuring_element = intarr(3,3) + 1
if keyword_set(magnify) then begin
	for mm = 1, fix(magnify) do begin
		fill = dilate( image, structuring_element, /gray, 1, 1 )
		loc = where( ( fill ge 0 ) and ( image eq 0 ), count )
		if count ge 1 then image( loc ) = fill( loc )
	endfor
endif

;- fill remaining undefined areas of image with the missing value
loc = where( image eq 0, count )
if ( count ge 1 ) then image( loc ) = missing

; find the x and y extents of the image
wz = where(image ne missing)
x0 = min(wz mod nxpix, max=x1)
y0 = min(wz / nxpix, max=y1)
image = image[x0:x1, y0:y1]
xoffset= xoffset + x0
yoffset = yoffset + y0


tv, image, xoffset, yoffset

; redraw axes
axis, xaxis=0, xlog=xlog, xrange=xrange, xtickname = xticknames
axis, yaxis=0, ylog=ylog, yrange=yrange, ytickname = yticknames
axis, /xaxis, xlog=xlog, xrange=xrange, xtickname = strarr(30) + ' '
axis, /yaxis, ylog=ylog, yrange=yrange, ytickname = strarr(30) + ' '

; NOW PLOT THE COLORBAR
if keyword_set(colorbar) then begin
if keyword_set(horizontal) then begin
	colorbar, minrange=min, maxrange=max, position = bposition, $
	bot=2, ncolors=253, div=divisions, minor=minor, format=format, $
	charsize = bcharsize, ylog = keyword_set(logarithmic), ticknames = ticknames
	if keyword_set(bartitle) then xyouts, bposition[2] + 0.02, bposition[1]+0.01, $
		bartitle, chars=bcharsize, /norm, align=0.0
endif else begin
	colorbar, minrange=min, maxrange=max, position = bposition, /vert, tit=bartitle, $
	bot=2, ncolors=253, div=divisions, minor=minor, format=format, $
	charsize = bcharsize, ylog = keyword_set(logarithmic), ticknames = ticknames
endelse
endif

tvlct, rold, gold, bold ; restore old color table




END
