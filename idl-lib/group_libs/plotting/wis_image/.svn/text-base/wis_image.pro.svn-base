 ; Procedure WIS_IMAGE
;
; PURPOSE:
;		To plot an image of satellite data on a lat-lon map projection, and produce a colorbar to its left.
;
;	BASIS:
;		Uses MAP_CONTINENTS to overplot boundaries of continents, countries, coasts, rivers, and/or U.S. states.
;		Uses a modified form of IMAGEMAP (by Liam Gumley)  to produce the image.
;		Uses COLORBAR (by David Fanning) to draw the colorbar.
;		Note that this procedure assumes a grid that goes from -180 to +180 in longitude (not 0 to 360),
; 		although it will automatically convert the latter to the former for its output.
;
; CALLING SEQUENCE
;
;			wis_image, image, lat, lon, title = title, magnify=magnify, $
;					xtitle=xtitle, ytitle=ytitle, projection = projection, $
;					position = position, mini=mini, maxi=maxi, limit=limit, $
;					no_colorbar = no_colorbar, format=format, bartitle=bartitle, $
;					labelaxes=labelaxes, missing=missing, _extra = _extra, $
;					coasts=coasts, rivers=rivers, countries=countries, usa=usa, $
;					fill_color = fill_color, and many many more keywords (see below)
;
; INPUTS
;-------------------------------------------------------
;   IMAGE				:		Array (2D) or vector (1D) of image values
;   LAT					:		Array or vector of latitudes corresponding to image values
;										(degrees, -90.0 = S, +90.0 = N)
;   LON					:		Array or vector of longitudes corresponding to image values
;										(degrees, -180.0 = W, +180.0 = E)
;
;		note 	-	LAT and LON *must* be the same size/dimensionality as IMAGE.
;
;
;	OPTIONAL KEYWORDS
;------------------------------------------------------
;		TITLE				:		An overall title for the image.
;		TCHARSIZE		:		Title charsize (default = !p.charsize + 1)
;		XTITLE			: 	A title for the horizontal (longtiude) axis
;		YTITLE 			:  	A title for the vertical (latitude) axis
;		LABELAXES		:		Set xtitle = 'Longitude [degrees]' and ytitle = 'Latitude [degrees]'
;		MINI				:		Setting this will causing all instances of image less than MINI
;										to be set equal to MINI for the plot.
;		MAXI 				:		Setting this will causing all instances of image greater than MAXI
;										to be set equal to MAXI for the plot.
;		LIMIT				:	  Sets the lat-range and lon-range to display. A 4-element vector of the form:
;											[lat0,lon0,lat1,lon1], where "0" denotes starting and "1" denotes ending.
;				RB: NOTE, here it's actually:[lat0,lat1,lon0,lon1], where "0" denotes starting and "1" denotes ending.
;   NEWIMAGE  	:		Named variable in which resampled image array is returned.
;										Note that this image is always scaled to a BYTE array.
;		ISOTROPIC		:		Set this keyword to ensure that the x-y ratio isn't messed with.
;		NOERASE			:		Do not clear the current window before drawing the new map.
;		LIMIT				:		Limits of map display, [LATMIN,LATMAX,LONMIN,LONMAX]
;										(default is [MIN(LAT),MAX(LAT),MIN(LON),MAX(LON)])
;		MAGNIFY			:		Setting this keyword to an integer greater than 0 will cause the resultant image
;										to undergo the DILATE procedure, which effectively scales the output pixels by 2^MAGNIFY.
;										Basically, each pixel is doubled in size until all the holes have filled in.  Has the annoying feature
;										that during a doubling, if two now-doubled pixels overlap somewhere, the value in the overlap region
;										defaults to that of the highest pixel (not the average of the two like you'd think).
;										Note: this is not the same as an interpolation, but it is much faster.
;		MISSING			:		Color index value to use for missing (unfilled) portions of image (default is zero).
;		PROJECTION	:		A string containing the map projection name to use.  Default is 'Cylindrical'.
;										Allowed map projections are:
;											Stereographic, Orthographic, LambertConic, LambertAzimuthal, Gnomic,
;											AzimuthalEquidistant, Satellite, Cylindrical, Mercator, Mollweide, Sinusoidal,
;											Aitoff, HammerAitoff, AlbersEqualAreaConic, TransverseMercator, MillerCylindrical,
;											Robinson, LambertConicEllipsoid, GoodesHomolosine
;		CENTER			:		2-element array specifying the center of the map: [lat0, lon0].  Default is [0,0].
;   CTABLE			:   Specify the Color Table Index Number to use.  This loads one of the color tables in the wis_image color
;											table file : "wis_color_tables.tbl'.  Table 1= Blue-White-Red, Table 2= Blue-Green-Red
;   VOID_INDEX 	:  	Set this keyword to image indices that will be greyed out in the plotted image.
;		LOGARITHMIC : 	Set this keyword to plot the image in log-base-10.  You may have to play with MINI and FORMAT
;											to get the colorbar output to look ok (i recommend FORMAT='(E9.1)', BCHARSIZE=1.0)

;  COLORBAR KEYWORDS
;		NO_COLORBAR	:		Setting this keyword suppresses the colorbar.
;		BHORIZONTAL		:		make color bar horizontal
;		BARTITLE		:		The title for the colorbar
;		BCHARSIZE		:		Charsize setting for Colorbar font
;		BPOSITION		:		[x0,y0,x1,y1] position of color bar lower left (x0, y0) and upper right (x1,y1) corners
;		FORMAT			:		The format specifier for the colorbar ticks; default = '(I5)'
;		MINOR			:		The number of minor tick divisions on the color bar. Default is 1.
;		DIVISIONS		:		The number of divisions to divide the colorbar into. There will
;										be (divisions + 1) annotations. The default is 5.
;		TICKNAMES		:		Set this to control the tick names
;
; GRID KEYWORDS
;		GLATS				:		Passed to map_grid as the LATS keyword.
;		GLONS				:		Passed to map_grid as the LONS keyword.
;		GCHARSIZE		:		Sets the charsize of the grid labels.  Set to 0.0 to turn off the labels.
;		GCOLOR			:		Grid line color (must set /GRID for this to take effect).
;		GLINESTYLE	:		Grid line style (must set /GRID for this to take effect).
;		GRID				:		Set this keyword to turn ON the grid (default is OFF).
;		LONDEL				:  Sets the spacing (in degrees) between meridians of longitude in the grid.
;		LATDEL				:  Sets the spacing (in degrees) between parallels of latitude in the grid.
;
; GFS GRID KEYWORDS
;		 			:		Draw grid lines at a 1-deg by 1-deg resolution (the GFS grid), using color GCOLOR
;		GFSCOLOR		:		The color to use to draw the GFS grid.  Only does anything if GFSGRID is set.
;		GFSLINESTYLE: 	The linestyle to use to draw the GFS grid.  Only does anything if GFSGRID is set.
;
;
; CONTINENT BOUNDARY KEYWORDS (keywords passed to MAP_CONTINENT)
;		NO_CONTINENTS						:	Set this to NOT draw continental borders.
;		COASTS, RIVERS, COUNTRIES, USA		:	As used by the MAP_CONTINENT native idl procedure.
;		FILL_CONTINENT						:	Set this keyword to 1 to fill continent boundaries with a solid color.
;													The color is set by the FILL_COLOR keyword.
;		FILL_COLOR 							:	Color used to draw boundaries in MAP_CONTINENTS. Default is !p.background.
;		CON_THICK							:   The thickness of the continental boundaries.  Default is 1.
;
;
;
;		MODIFICATIONS
;-----------------------------------------------------
;		-Created by Chris O'Dell, 15 March 2004.
;		-Mods 16-18 Mar 2004
;			Modified the workings of the MAGNIFY keyword
;				(which uses the native DILATE function), to be more intuitive.  MAGNIFY
;				now specifies the number of pixel doublings to occur.
;			Modified MAGNIFY keyword again; now uses a slightly different structuring element
;				in call to DILATE, centered on orignal pixel (old calls put the pixel in the upper right
;				corner of the structuring element).  Now use a 3x3 structuring elt around each pixel.
;
;			Modified LIMIT keyword so it doesn't matter if you enter longitude as -180..180 or 0..360.
;			Removed the largely unnecessary _EXTRA keyword.
;
;		-Mods 19-22 Mar 2004
;				Added lots of new keywords.  CENTER, NOERASE,
;					some colorbar-related keywords, some grid-related keywords.
;		-Mods 08 Apr 2004 (MK)
;				Added londel, latdel grid keywords to specify grid interval when plotting.
;
;		- 12 Apr 2004 (CO)
;				Added CTABLE and VOID_INDEX keywords to make more like fub_image.
;				Added LOGARITHMIC keyword.
;				Added check to see if image overlaps with LIMIT plot range.  Quits if they do not.
;				Fixed FILL_CONTINENTS keyword.
;
;		- 13 Apr 2004 (CO)
;				Fixed problem with Grid label color when GCOLOR is set.
;
;		DEPENDENCIES
;			Uses COLORBAR.pro (by David Fanning).


function TV_CT, Xo, Yo, Nx, Ny, _extra=_extra

	im = tvrd(Xo, Yo, Nx, Ny, _extra = _extra, true=1)
	imc = reform(im[0,*,*] + im[1,*,*]*256L + im[2,*,*]*256L^2)
	tvlct, r, g, b, /get
	ct = r + g*256L + b*256L^2
	out = byte(imc)

	for c = 0, 255 do begin
		w = where(imc eq ct[c])
		if w[0] ne -1 then out[w] = c
	endfor

	return, out
END


function wis_bytscl, image, mini, maxi, logarithmic = logarithmic, dualsided=dualsided

 	if keyword_set(logarithmic) then begin
	 	if keyword_set(dualsided) then begin
	 		; two-sided logarithmic
			if (n_elements(maxi) eq 1) then max = [-abs(maxi), abs(maxi)] else max=maxi
			if (n_elements(mini) eq 1) then min = [-abs(mini), abs(mini)] else min=mini
			wp = where( image GE min[1] )
			wn = where( image LE min[0] )
			byt = byte(image * 0) + 128
			if wn[0] ne -1 then byt[wn] = (125-bytscl(alog10(abs(image[wn])), max=alog10(abs(max[0])), min=alog10(abs(min[0])), top = 125, /nan)) + 2
			if wp[0] ne -1 then byt[wp] = bytscl(alog10(abs(image[wp])), min=alog10(abs(min[1])), max=alog10(abs(max[1])), top = 125, /nan) + 129
		endif else begin
		; regular one-sided logarithmic
			byt = bytscl(alog10(image > 1e-20), min=alog10(mini[0] > 1e-20), max=alog10(maxi[0] > 1e-19), top = 252,/nan) + 2
		endelse
	endif else begin
		; not a logarithmic image
		byt = bytscl(image, min=mini[0], max=maxi[0], top=252, /nan) + 2
	endelse

	return, byt
end

pro wis_imagemap, image, lat, lon, newimage = newimage, mini=mini, maxi=maxi, $
  limit = limit, position = position, isotropic = isotropic, title = title, $
  xoffset = xoffset, yoffset = yoffset, xsize = xsize, ysize = ysize, $
  missing = missing, noborder = noborder, noerase = noerase, $
  current = current, projection = projection, magnify=magnify, center = center, $
  oplot = oplot, void_index=void_index, void_color = void_color, $
  logarithmic = logarithmic, dualsided=dualsided, background=background,sat_p=sat_p,xmargin=xmargin,ymargin=ymargin

;+
;PURPOSE:
;   Display an image which has latitude and longitude defined for
;   each pixel on a map projection. If a map projection is not currently
;   defined, then a Mercator map projection is created which corresponds to
;   the lat/lon limits of the image.
;
;CALLING SEQUENCE:
;   IMAGEMAP, IMAGE, LAT, LON
;
;INPUT:
;   IMAGE      Array (2D) or vector (1D) of image values
;   LAT        Array or vector of latitudes corresponding to image values
;              (degrees, -90.0 = S, +90.0 = N)
;   LON        Array or vector of longitudes corresponding to image values
;              (degrees, -180.0 = W, +180.0 = E)
;
;OPTIONAL KEYWORDS:
;   RANGE      Range of image values used for brightness scaling, [MIN,MAX]
;              (default is [MIN(IMAGE),MAX(IMAGE)])
;
;   ISOTROPIC  If set, creates an isotropic map projection (default=non-isotropic).
;   TITLE      String variable containing image title (default=no title).
;   XOFFSET    Named variable in which the lower left device X coordinate
;              of the displayed image is returned.
;   YOFFSET    Named variable in which the lower left device Y coordinate
;              of the displayed image is returned.
;   XSIZE      Named variable in which the width of the displayed image
;              is returned (used by devices which have scalable pixels
;              such as Postscript).
;   YSIZE      Named variable in which the height of the displayed image
;              is returned (used by devices which have scalable pixels
;              such as Postscript).
;   MISSING    Byte value to use for missing (unfilled) portions of image
;              (default is zero).
;   NOBORDER   If set, do not draw border around image (default=draw border).
;   NOERASE    If set, do not erase window before creating image (default=erase).
;   CURRENT    If set, use the current map projection.
;

;OUTPUT:
;   The resampled image is displayed in the current graphics window
;   in map coordinates. Continental outlines and lat/lon grids may be
;   overlaid with MAP_CONTINENTS AND MAP_GRID.
;
;CREATED:
;   Liam Gumley, CIMSS/SSEC, 26-JUL-1996
;   liam.gumley@ssec.wisc.edu
;   http://cimss.ssec.wisc.edu/~gumley/index.html
;
;REVISED:
;   Liam Gumley, CIMSS/SSEC, 17-SEP-1996
;   Modified to work with Postscript output.
;   Added XOFFSET, YOFFSET, XSIZE, YSIZE keywords.
;   Mercator map projection is now created only if no map projection exists.
;
;   Liam Gumley, CIMSS/SSEC, 15-OCT-1996
;   Added MISSING keyword to set missing values in image.
;   Added NOBORDER keyword.
;
;   Liam Gumley, CIMSS/SSEC, 25-NOV-1996
;   Now uses MISSING keyword properly.
;   Added NOERASE keyword.
;   Added LOWRES keyword (useful for low resolution images, e.g. HIRS, AMSU).
;
;   Liam Gumley, CIMSS/SSEC, 26-MAR-1999
;   Now uses NOERASE keyword properly.
;
;   Liam Gumley, CIMSS/SSEC, 13-AUG-1999
;   Added CURRENT keyword.
;
;		Chris O'Dell, UW-AOS, 15-MAR-2004
;		Replaced LOWRES keyword with MAGNIFY keyword.
;		Added PROJECTION keyword.
;
;		17-MAR-2004, Changed MAGNIFY keyword to work more intutively.

;NOTES:
;   (1) Hermann Mannstein (h.mannstein@dlr.de) suggested this IDL method.
;   (2) This has been tested on MAS, AVHRR, GOES, and simulated MODIS data.
;       It will not work well on low resolution data like HIRS or MSU.
;   (3) You might run into problems with data over the poles - I've only
;       tried mid-latitude imagery.
;   (4) This procedure was designed for display purposes *only*.
;       If you use the resampled data for any other purpose, you do so at
;       your own risk.
;		(5)	See original IMAGEMAP procedure by Liam Gumley for more documentation/details.

if keyword_set( limit ) then begin
  if n_elements( limit ) ne 4 then $
    message, 'LIMIT must be a 4 element vector of the form [LATMIN,LATMAX,LONMIN,LONMAX]'
  latmin = limit( 0 )
  lonmin = limit( 2 )
  latmax = limit( 1 )
  lonmax = limit( 3 )
endif else begin
  latmin = min( lat, max = latmax )
  lonmin = min( lon, max = lonmax )
endelse

;- check keywords

if n_elements(center) eq 0 then center = [0.,0.] ; [lat, lon] of map center
if not keyword_set( isotropic ) then isotropic = 0
if not keyword_set( noerase ) then noerase = 0
if n_elements(projection) eq 0 then projection = 'Cylindrical'

if n_elements( title ) eq 0 then title = ' '
if n_elements( missing ) eq 0 then missing = 0
missing = byte( ( missing > 0 ) < ( !d.table_size - 1 ) )

;- create map projection if necessary after checking position keyword

if (not keyword_set( current )) AND (not keyword_set(oplot)) then begin
  if n_elements( position ) gt 0 then begin
    if n_elements( position ) ne 4 then $
      message, 'POSITION must be a 4 element vector of the form [X1,Y1,X2,Y2]'
    map_set,  limit = [ latmin, lonmin, latmax, lonmax ], $
      title = title, isotropic = isotropic, position = position, noborder=noborder, $
      noerase = noerase, name = projection, center[0], center[1], color=background,sat_p=sat_p,_EXTRA=_EXTRA,xmargin=xmargin,ymargin=ymargin
      
  endif else begin
    map_set, limit = [ latmin, lonmin, latmax, lonmax ], $
      title = title, isotropic = isotropic, /noborder, $
      noerase = noerase, name = projection, center[0], center[1], color=background,sat_p=sat_p,_EXTRA=_EXTRA,xmargin=xmargin,ymargin=ymargin
      
  endelse
endif


;- set number of samples and lines for warped image

ns = !d.x_size
nl = !d.y_size
if ( !d.flags and 1 ) then begin
  ns = 640L
  nl = long( float( ns ) * float( !d.y_size ) / float( !d.x_size ) )
endif


; -----------------------------------------------
;- Create resampled byte image
; -----------------------------------------------
;if keyword_set(magnify) then begin
; Magnify the image if output device is too large
;	s = size(image)
;	image = congrid(image, s[1]*magnify, s[2]*magnify, /interp)
;	lat = congrid(lat, s[1]*magnify, s[2]*magnify, /interp)
;	lon = congrid(lon, s[1]*magnify, s[2]*magnify, /interp)

;	p = convert_coord( congrid(lon, s[1]*magnify, s[2]*magnify, /interp), $
;							congrid(lat, s[1]*magnify, s[2]*magnify, /interp)	$
;							, /data, /to_normal )
;	newimage = replicate(0B, ns, nl)
;	newimage( p( 0, * ) * ( ns - 1 ), p( 1, * ) * ( nl - 1 ) ) = $
 ; bytscl( congrid(image, s[1]*magnify, s[2]*magnify, /interp), $
 ; 				min = imin, max = imax, top = !d.table_size - 2 ) + 1B

;endif else begin

	p = convert_coord( lon, lat, /data, /to_normal )
	x = !x.window * ns
	y = !y.window * nl

	;- compute image offset and size (device coordinates)
	p2 = convert_coord( [ x(0), x(1) ] / float( ns ), [ y(0), y(1) ] / float( nl ), $
  /normal, /to_device )
	xoffset = p2(0,0)
	yoffset = p2(1,0)
	xsize = p2(0,1) - p2(0,0)
	ysize = p2(1,1) - p2(1,0)

	if keyword_set(oplot) then begin
		newimage = tv_ct(xoffset,yoffset,xsize, ysize)
	endif

	if n_elements(newimage) eq 0 then begin
		newimage = intarr(ns, nl)
		newimage( p( 0, * ) * ( ns - 1L ), p( 1, * ) * ( nl - 1 ) ) = $
			 wis_bytscl( image, mini, maxi, dual=dualsided, log=logarithmic)

		if n_elements(void_index) gt 0 then $
			if void_index[0] ne -1 then begin
				if n_elements(void_color) eq 0 then void_color = 1
				newimage(p( 0, void_index) * (ns - 1L), p(1, void_index) * (nl-1L) ) = void_color
			endif

	;- extract portion of image which fits within map boundaries
		newimage = temporary( newimage( x(0):x(1), y(0):y(1) ) )
		already = 0
		;magnify
		structuring_element = intarr(3,3) + 1
		if keyword_set(magnify) then begin
			for mm = 1, fix(magnify) do begin
				fill = dilate( newimage, structuring_element, /gray, 1, 1 )
				loc = where( ( fill ge 0 ) and ( newimage eq 0 ), count )
				if count ge 1 then newimage( loc ) = fill( loc )
			endfor
		endif
		;- fill remaining undefined areas of image with the missing value
		loc = where( newimage eq 0, count )
		if ( count ge 1 ) and ( missing gt 0B) then newimage( loc ) = missing
	endif else begin
		 already = 1
		 newimage2 = newimage * 0
		 newimage2( p( 0, * ) * ( ns - 1 )  - x[0], p( 1, * ) * ( nl - 1 ) - y[0] ) = $
	 	 	wis_bytscl( image, mini, maxi, dual=dualsided, log=logarithmic)
	 	 structuring_element = intarr(3,3) + 1
		if keyword_set(magnify) then begin
			for mm = 1, fix(magnify) do begin
				fill = dilate( newimage2, structuring_element, /gray )
				loc = where( ( fill ge 0 ) and ( newimage2 eq 0 ), count )
				if count ge 1 then newimage2( loc ) = fill( loc )
			endfor
		endif
		w = where(newimage2 ne 0)
		newimage[w] = newimage2[w]
	endelse

;- display resampled image

tv, newimage, xoffset, yoffset, xsize = xsize, ysize = ysize
;print,xoffset, yoffset, xsize,ysize
;- draw map borders

if (not keyword_set( noborder )) AND (not already) then begin
;  plots, [ p(0,0), p(0,1) ], [ p(1,0), p(1,0) ], /device
;  plots, [ p(0,1), p(0,1) ], [ p(1,0), p(1,1) ], /device
;  plots, [ p(0,1), p(0,0) ], [ p(1,1), p(1,1) ], /device
;  plots, [ p(0,0), p(0,0) ], [ p(1,1), p(1,0) ], /device
endif

END ; wis_imagemap



PRO wis_image, image, lat, lon, title = title, magnify=magnify, newimage=newimage, $
					xtitle=xtitle, ytitle=ytitle, projection = projection, oplot=oplot, current=current, $
					position = position, mini=mini, maxi=maxi, limit=limit, $
					no_colorbar = no_colorbar, format=format, bartitle=bartitle, $
					minor=minor,  divisions=divisions, missing=missing, $
					labelaxes=labelaxes, fill_color = fill_color, isotropic=isotropic, $
					coasts = coasts, rivers=rivers, countries = countries, usa=usa, $
				  gcolor = gcolor, glinestyle = glinestyle, $
				  glats = glats, glons = glons, gcharsize = gcharsize, tcharsize=tcharsize, $
				  noerase = noerase, bcharsize = bcharsize, bposition = bposition, center=center, $
				  londel=londel, latdel=latdel, no_box=no_box, ctable=ctable, void_index=void_index, $
				  logarithmic = logarithmic, fill_continents=fill_continents, con_thick=con_thick, $
				  no_continents = no_continents, ticknames = ticknames, $
				  dualsided = dualsided, box_axes = box_axes, glabel = glabel, sides=sides, $
				  pos_longitude = pos_longitude, latlabel = latlab, lonlabel=lonlab, $
				  glinethick = glinethick, mean_=mean_, bhorizontal=bhorizontal, std=std, $
				  hires=hires, background=background, gridcolor=gridcolor, gridspacing=gridspacing, $
				  gridlats=gridlats, gridlons=gridlons, gridlinestyle=gridlinestyle, $
		          xoffset=xoffset,yoffset=yoffset,xsize=xsize,ysize=ysize,_EXTRA=_EXTRA,sat_p=sat_p, $
                   xmargin=xmargin,ymargin=ymargin,noborder=noborder,no_grid=no_grid

if n_elements(xtitle) eq 0 then if keyword_set(labelaxes) then xtitle = 'Longitude [degrees]' else xtitle=''
if n_elements(ytitle) eq 0 then if keyword_set(labelaxes) then ytitle = 'Latitude [degrees]' else ytitle=''
if n_elements(title) eq 0 then title = ''
if n_elements(divisions) eq 0 then divisions = 5
if n_elements(minor) eq 0 then minor = 1
if n_elements(fill_color) eq 0 then fill_color = !p.background
if n_elements(tcharsize) eq 0 then tcharsize = !p.charsize + 1
if n_elements(box_axes) eq 0 then box_axes = 1 else if n_elements(glabel) eq 0 then glabel = 1
if n_elements(sides) eq 0 then sides = [0,1,2,3]
if n_elements(hires) eq 0 then hires = 1
if n_elements(position) eq 0 then begin
	if keyword_set(no_colorbar) then begin
			position = [0.1,0.1,0.93,0.9]
	endif else begin
		if keyword_set(bhorizontal) then position = [0.05, 0.18, 0.95, 0.9] $
			else position = [0.23,0.1,0.93,0.9]
	endelse
endif


; Deal with Color Table
;-------------------------------------------------------------
if n_elements(ctable) eq 0 then ctable = 2 ; set the default color table
tvlct, rold, gold, bold, /get ; get current color table
;COMMON colors, rc, gc, bc ; get the colors in the common block "colors"

;ctbl_path=get_source_path(routine='WIS_IMAGE')

if ctable LT 0 then goto, skip_ctables

if ( CTABLE GT 0 AND CTABLE LT 40) then begin


;	if !version.os_family eq 'Windows' then $
;		ctfile = 'p:\odell\idlprogs\aos\wis_image\wis_color_tables.tbl' $
;	else $
;;		ctfile = '~/idlprogs/aos/wis_image/wis_color_tables.tbl'

	ctfile = FILE_WHICH('wis_color_tables.tbl')
	loadct, ctable, file=ctfile, /silent
	
endif	else begin
	;set white, black, and grey (reserved colors)
	i_white = 255 & i_grey=1 & i_black = 0
	r = rold & g = gold & b = bold
	r[i_white] = 255 & r[i_white] = 255 & b[i_white] = 255
	r[i_black] = 0 & r[i_black] = 0 & b[i_black] = 0
	r[i_grey] = 127 & r[i_grey] = 127 & b[i_grey] = 127
	tvlct, r, g, b
endelse

skip_ctables:

if n_elements(bposition) eq 0 then begin
  bposition = position
  if keyword_set(bhorizontal) then begin
	  bposition[0] = 0.2
   	  bposition[2] = 0.8
   	  bposition[1] = 0.07
   	  bposition[3] = 0.1
  endif else begin
  	  bposition[0] = (position[0] - 0.16 * (position[2] - position[0])) > 0
   	  bposition[2] = (position[0] - 0.14  * (position[2] - position[0])) > bposition[0] + 0.01
  endelse
endif

image_ = image

if n_elements(lat) eq 0 then begin
; NO LAT OR LONGITUDE...ASSUME REGULAR GRID
	szi = size(image)
	if szi[0] ne 2 then begin
		print, 'There is no lat or lon entered, and this is required for a 1D image! Quitting.'
		return
	endif else begin
		lat = (findgen(szi[2])+0.5)*180./szi[2] - 90.
		lon = (findgen(szi[1])+0.5)*360./szi[1]
	endelse
endif

if (n_elements(lon) eq 0 AND size(lat, /type) eq 8) then begin
	lat_ = lat.lat
	lon_ = lat.lon
endif else begin
	lat_ = lat
	lon_ = lon
endelse

if keyword_set(pos_longitude) then begin
	; use longitudes from 0 to 360 degrees
	wlon = where(lon_ LT 0.)
	if wlon[0] ne -1 then lon_[wlon] = lon_[wlon] + 360.
endif else begin
	; use longitudes from -180 to 180 degrees
	wlon = where(lon_ GT 180)
	if wlon[0] ne -1 then lon_[wlon] = lon_[wlon] - 360
endelse

; how about 1D lat and lon arrays (for REGULAR GRIDS ONLY)
if (size(image))[0] EQ 2 and (size(lat_))[0] eq 1 then begin
	; IS LON FIRST? - THIS IS ALMOST ALWAYS THE CASE
	if n_elements(lat) eq n_elements(image[*,0]) then begin
	; latitude first case
		lon_ = (fltarr(n_elements(lat)) + 1.) # lon_
		lat_ = lat_ # (fltarr(n_elements(lon))+1.)
	endif else begin
	; longitude first case
		lat_ = (fltarr(n_elements(lon)) + 1.) # lat_
		lon_ = lon_ # (fltarr(n_elements(lat))+1.)
	endelse
endif


if keyword_set(void_index) then begin
	if size(void_index, /type) eq 7 then begin
		; void_index is a string.  Example 'LT 0'.
		; this is interpreted as where the input image is less than zero.
		err = execute('wvoid = where(image ' + void_index + ')')
	endif else wvoid = void_index
	if wvoid[0] ne -1 then begin
    	good_indices = bytarr(n_elements(image)) + 1
	  	good_indices[wvoid] = 0
	  	wgood = where(good_indices)
	  	image_ = image_[wgood]
	  	lat_ = lat_[wgood]
	  	lon_ = lon_[wgood]
	endif
endif

nodata = 0
if keyword_set(limit) then begin
	limit_ = limit

	if keyword_set(pos_longitude) then begin
		wl_ = where(limit[2:3] LT 0)
		if wl_[0] ne -1 then limit_[2+wl_] = limit_[2+wl_] + 360
	endif else begin
		wl_ = where(limit[2:3] GT 180)
		if wl_[0] ne -1 then limit_[2+wl_] = limit_[2+wl_] - 360
	endelse
	w = wherelim(limit_, lat_, lon_)

	if w[0] eq -1 then begin
		print, 'No data in LIMIT range!'
		nodata = 1
		goto, no_data
	endif
	image_ = image_[w]
	lat_ = lat_[w]
	lon_ = lon_[w]

endif



if n_elements(mini) eq 0 then begin
	mini = min(image_)
endif
if n_elements(maxi) eq 0 then begin
	maxi = max(image_)
endif

if keyword_set(projection) then begin
	; user-input map projection
	map_proj_info, proj_names=names
	nn = n_elements(names)
	projname = ''
	for i = 0, nn-1 do if strupcase(names[i]) eq strupcase(projection) then projname = names[i]
	if projname eq '' then begin
		print, 'Projection Name must be one of the following:'
		print, names
		return
	endif
endif else projname = 'Cylindrical'


if mini[0] eq maxi[0] then maxi[0] = mini[0] + 1

wis_imagemap, image_, lat_, lon_, position =position, projection=projname, $
		mini=mini, maxi=maxi, limit=limit, magnify=magnify, missing=missing,$
		isotropic = isotropic, noerase = noerase, center=center, newimage=newimage, $
		current=current, oplot=oplot, log=logarithmic, dual=dualsided, background=background, $
		xoffset=xoffset,yoffset=yoffset,xsize=xsize,ysize=ysize,sat_p=sat_p,xmargin=xmargin,ymargin=ymargin,noborder=noborder

if not keyword_set(oplot) then begin
	xyouts, (position[0]+position[2])/2., position[3] + 0.02*(position[3]-position[1]), title, /norm, align=0.5, charsize = tcharsize
	xyouts, (position[0]+position[2])/2., position[1]/2.- 0.035, xtitle, /norm, align=0.5, charsize= gcharsize
	xyouts, position[2]+0.05, (position[1]+position[3])/2., ytitle, orient=270., align=0.5, /norm, charsize = gcharsize

	if (keyword_set(no_continents) eq 0) then $
		map_continents, /continents, hires=hires, col = FILL_COLOR, coasts = coasts, $
					rivers=rivers, countries=countries, usa = usa, fill_continents=fill_continents, $
					mlinethick=con_thick

	if Projname ne 'Cylindrical' then begin
		if keyword_set(glats) then latnames = num2str(glats,1)
		if keyword_set(glons) then lonnames = num2str(glons,1)
		if keyword_set(glons) AND n_elements(latlab) eq 0 then latlab = total(glons[0:1])/2.
		if keyword_set(glats) AND n_elements(lonlab) eq 0 then lonlab = total(glats[0:1])/2.

;		print, 'Latnames= ', latnames
		if not(keyword_Set(no_grid)) then begin
		   map_grid, lats=glats, lons=glons, charsize=gcharsize, latdel=latdel, londel=londel, $
		   lonnames = lonnames, latnames = latnames, col = gcolor, glinestyle = glinestyle, glinethick = glinethick, $
		   latlab=latlab, lonlab = lonlab, /label
		endif

	endif else begin
        if not(keyword_Set(no_grid)) then begin
		   wis_grid, /horizon, box_axes=box_axes, lats=glats, lons=glons, charsize=gcharsize, $
		   /no_grid, latdel=latdel, londel=londel, $
		   lonnames = lonnames, latnames = latnames, sides=sides
        endif 
	endelse

	if keyword_set(gridspacing) then begin
	        if n_elements(gridspacing) eq 1 then gridspacing = [gridspacing[0],gridspacing[0]]
		if n_elements(gridlinestyle) eq 0 then gridlinestyle = 0
		if n_elements(gridlats) eq 0 then gridlats = 0.0
		if n_elements(gridlons) eq 0 then gridlons = 0.0
		if n_elements(gridcolor) eq 0 then gridcolor = 255
		; lats, lons tells you the offset (if a scalar value) of the drawn lines.
		; londel, latdel tells you the spacing between lines
		    if not(keyword_Set(no_grid)) then begin
              wis_grid, lats=gridlats, lons=gridlons, glinesty=gridlinestyle, col=gridcolor, $
			  latdel=gridspacing[0], londel=gridspacing[1]
            endif
        endif

	if ((keyword_set(no_colorbar) eq 0) AND (nodata eq 0)) then begin

		if n_elements(format) eq 0 then begin
			mm = mean([abs(mini),abs(maxi)])
			if mm GT 100 then format = '(I5)'
			if mm GT 10. AND mm LT 100. then format = '(f5.1)'
			if mm LT 10. then format = '(f6.2)'
			if mm LT 1. then format  = '(f7.3)'
			if mm LT 0.01 then format = '(f8.4)'
 		endif

		if keyword_set(logarithmic) and keyword_set(dualsided) then begin
			; must create TWO colorbars, right next to each other

			bpos1 = bposition
			bpos2 = bposition
			bpos1[3] = (bpos1[1] + bpos1[3])/2.
			bpos2[1] = bpos1[3]

			df_colorbar, /vert, minran=abs(maxi[0]), maxran=abs(mini[0]), pos=bpos1, $
			bot = 2, ncolors=127, div=divisions/2, minor=minor, format=format, $
			charsize = bcharsize, ytitle = ' ', xstyle = 9, /ylog

			df_colorbar, /vert, minran=abs(mini[1]), maxran=abs(maxi[1]), pos=bpos2, $
			bot = 129, ncolors=126, div=divisions/2, minor=minor, format=format, $
			charsize = bcharsize, /ylog, ytitle = ' '

			; must place title now
			if keyword_set(bartitle) then begin
				xyouts, bposition[0] - 0.06, bpos1[3], align=0.5, $
					orient = 90., charsize=bcharsize, bartitle, /norm
			endif
		endif else begin
			if keyword_set(bhorizontal) then begin
				df_colorbar, minrange=mini, maxrange=maxi, position = bposition, $
				bot=2, ncolors=253, div=divisions, minor=minor, format=format, $
				charsize = bcharsize, ylog = keyword_set(logarithmic), ticknames = ticknames
				if keyword_set(bartitle) then xyouts, bposition[2] + 0.02, bposition[1]+0.01, $
					bartitle, chars=bcharsize, /norm, align=0.0
			endif else begin
				df_colorbar, minrange=mini, maxrange=maxi, position = bposition, /vert, tit=bartitle, $
				bot=2, ncolors=253, div=divisions, minor=minor, format=format, $
				charsize = bcharsize, ylog = keyword_set(logarithmic), ticknames = ticknames
			endelse
		endelse
	endif
endif

if keyword_set(mean_) then begin
	Ncos = total(cos(lat_*!dtor))
	mean_ = total(image_ * cos(lat_*!dtor)) / Ncos
	dig = (-1*floor(alog10(abs(mean_))) + 2) > 0 ; # of digits to use.
	smean = strcompress(string(mean_, form = '(f10.' + string(dig, form='(i1)') +')'), /remove)
	xyouts, position[0], 0.03, 'Mean = ' + smean, /norm
endif

if keyword_set(std) then begin
	mean_ = total(image_ * cos(lat_*!dtor)) / total(cos(lat_*!dtor))
   	std = total( (image_ - mean_)^2 * cos(lat_*!dtor) ) / Ncos
	std = sqrt(std)
	dig = (-1*floor(alog10(abs(std))) + 2) > 0 ; # of digits to use.
	sstd = strcompress(string(std, form = '(f10.' + string(dig, form='(i1)') +')'), /remove)
	xyouts, position[0] + 0.2, 0.03, 'Std = ' + sstd, /norm
endif


no_data:
; Restore Old Color Table
tvlct, rold, gold, bold
END
