 ; Procedure WIS_IMAGE
;
; PURPOSE:
;		To plot an image of satellite data on a lat-lon map projection, and produce a colorbar to its left.
;
;	BASIS:
;		Uses MAP_CONTINENTS to overplot boundaries of continents, countries, coasts, rivers, and/or U.S. states.
;		Uses a modified form of IMAGEMAP (by Liam Gumley) to produce the image.
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
;		GFSGRID			:		Draw grid lines at a 1-deg by 1-deg resolution (the GFS grid), using color GCOLOR
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


pro imagemap_true, r, g, b, lat, lon, limit=limit, center=center, isotropic=isotropic, $
	noerase = noerase, projection = projection, title = title, missing = missing, $
	position = position, magnify = magnify,xmargin=xmargin,ymargin=ymargin,noborder=noborder

;loadct, 0

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

if n_elements(center) eq 0 then center = [0.,0.] ; [lat, lon] of map center
if not keyword_set( isotropic ) then isotropic = 0
if not keyword_set( noerase ) then noerase = 0
if n_elements(projection) eq 0 then projection = 'Cylindrical'

if n_elements( title ) eq 0 then title = ' '
if n_elements( missing ) eq 0 then missing = [0,0,0]


;- create map projection if necessary after checking position keyword

if n_elements(position) eq 0 then position = [0.02,0.02,0.98, 0.98]

map_set,  limit = [ latmin, lonmin, latmax, lonmax ], $
  title = title, isotropic = isotropic, position = position, /noborder, $
  noerase = noerase, name = projection, center[0], center[1],xmargin=xmargin,ymargin=ymargin

	p = convert_coord( lon, lat, /data, /to_normal )
	ns = !d.x_size
	nl = !d.y_size
	x = !x.window * ns
	y = !y.window * nl

	;- compute image offset and size (device coordinates)
	p2 = convert_coord( [ x(0), x(1) ] / float( ns ), [ y(0), y(1) ] / float( nl ),  /normal, /to_device )
	xoffset = p2(0,0)
	yoffset = p2(1,0)
	xsize = p2(0,1) - p2(0,0)
	ysize = p2(1,1) - p2(1,0)

	; now I must bytscl the rgb data.

	min_d = min([r, g, b], max = max_d)
	max_d = max_d + (max_d - min_d)  * 1e-6

	sz = size(r)
	r_image = bytarr(ns, nl)
	g_image = r_image
	b_image = r_image
	loc_image = r_image
	xout = reform(fix(p(0,*) * (ns-1L)))
	yout = reform(fix(p(1,*) * (nl-1L)))
	index = different(xout + yout * ns, /index)
	xout = xout[index]
	yout = yout[index]
	; bytscl
	r_image( xout, yout) = (r[index] - min_d) / (max_d - min_d) * 256
	g_image( xout, yout) = (g[index] - min_d) / (max_d - min_d) * 256
	b_image( xout, yout) = (b[index] - min_d) / (max_d - min_d) * 256
	loc_image( xout, yout ) = 1


	;- extract portion of image which fits within map boundaries - IS THIS NECESSARY????
		r_image = temporary( r_image( x(0):x(1), y(0):y(1) ) )
		g_image = temporary( g_image( x(0):x(1), y(0):y(1) ) )
		b_image=  temporary( b_image( x(0):x(1), y(0):y(1) ) )
		loc_image=  temporary( loc_image( x(0):x(1), y(0):y(1) ) )

		;magnify
		structuring_element = intarr(3,3) + 1
		if keyword_set(magnify) then begin
			for mm = 1, fix(magnify) do begin
				l_fill = dilate( loc_image, structuring_element, /gray, 1, 1 )
				loc = where( l_fill GT 0 AND loc_image eq 0, count)
				if count GT 0 then begin
					r_fill = dilate( r_image, structuring_element, /gray, 1, 1 )
					g_fill = dilate( g_image, structuring_element, /gray, 1, 1 )
					b_fill = dilate( b_image, structuring_element, /gray, 1, 1 )
					r_image(loc) = r_fill(loc)
					g_image(loc) = g_fill(loc)
					b_image(loc) = b_fill(loc)
					loc_image(loc) = l_fill(loc)
				endif
			endfor
		endif



	;- fill remaining undefined areas of image with the missing value
	loc = where( loc_image eq 0, count )
	if ( count ge 1 ) and ( total(missing) gt 0) then begin
		r_image( loc ) = missing[0]
		g_image( loc ) = missing[1]
		b_image( loc ) = missing[2]
	endif

	tv, [ [[r_image]], [[g_image]], [[b_image]] ], xoffset, yoffset, $
		xsize = xsize, ysize = ysize, TRUE = 3

	if not keyword_set( noborder ) then begin
	  plots, [ p(0,0), p(0,1) ], [ p(1,0), p(1,0) ], /device
	  plots, [ p(0,1), p(0,1) ], [ p(1,0), p(1,1) ], /device
	  plots, [ p(0,1), p(0,0) ], [ p(1,1), p(1,1) ], /device
	  plots, [ p(0,0), p(0,0) ], [ p(1,1), p(1,0) ], /device
	endif

END



PRO wis_image_true, r, g, b, lat, lon, title = title, magnify=magnify, newimage=newimage, $
					xtitle=xtitle, ytitle=ytitle, projection = projection, oplot=oplot, current=current, $
					position = position, limit=limit, $
					labelaxes=labelaxes, fill_color = fill_color, isotropic=isotropic, $
					coasts = coasts, rivers=rivers, countries = countries, usa=usa, $
				  gfsgrid = gfsgrid, gfscolor = gfscolor, gfslinestyle = gfslinestyle, $
				  gcolor = gcolor, glinestyle = glinestyle, grid=grid, $
				  glats = glats, glons = glons, gcharsize = gcharsize, tcharsize=tcharsize, $
				  noerase = noerase,  center=center, missing = missing, $
				  londel=londel, latdel=latdel, no_box=no_box, void_index=void_index, $
				  fill_continents=fill_continents, con_thick=con_thick, $
				  no_continents = no_continents, box_axes = box_axes, glabel = glabel, sides=sides, $
				  pos_longitude = pos_longitude, latlabel = latlab, lonlabel=lonlab, $
				  glinethick = glinethick,xmargin=xmargin,ymargin=ymargin,noborder=noborder

if n_elements(xtitle) eq 0 then if keyword_set(labelaxes) then xtitle = 'Longitude [degrees]' else xtitle=''
if n_elements(ytitle) eq 0 then if keyword_set(labelaxes) then ytitle = 'Latitude [degrees]' else ytitle=''
if n_elements(title) eq 0 then title = ''
if n_elements(fill_color) eq 0 then fill_color = !p.background
if n_elements(tcharsize) eq 0 then tcharsize = !p.charsize + 1
if n_elements(box_axes) eq 0 then box_axes = 1 else if n_elements(glabel) eq 0 then glabel = 1
if n_elements(sides) eq 0 then sides = [0,1,2,3]
if n_elements(position) eq 0 then 	position = [0.1,0.1,0.93,0.9]



; Deal with Color Table
;-------------------------------------------------------------

tvlct, rold, gold, bold, /get ; get current color table
;COMMON colors, rc, gc, bc ; get the colors in the common block "colors"
loadct, 0


r_ = r
g_ = g
b_ = b
lat_ = lat
lon_ = lon

if keyword_set(pos_longitude) then begin
	; use longitudes from 0 to 360 degrees
	wlon = where(lon_ LT 0.)
	if wlon[0] ne -1 then lon_[wlon] = lon_[wlon] + 360.
endif else begin
	; use longitudes from -180 to 180 degrees
	wlon = where(lon_ GT 180)
	if wlon[0] ne -1 then lon_[wlon] = lon_[wlon] - 360
endelse

if keyword_set(void_index) then begin
	if void_index[0] ne -1 then begin
    	good_indices = bytarr(n_elements(r)) + 1
	  	good_indices[void_index] = 0
	  	wgood = where(good_indices)
	  	r_ = r_[wgood]
	  	g_ = g_[wgood]
	  	b_ = b_[wgood]
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
	w = where( (lat_ GE limit_[0]) AND (lat_ LE limit_[1]) $
				AND  (lon_ GE limit_[2]) AND (lon_ LE limit_[3] ) )

	if w[0] eq -1 then begin
		print, 'No data in LIMIT range!'
		nodata = 1
		goto, no_data
	endif

	r_ = r_[w]
	g_ = g_[w]
	b_ = b_[w]
	lat_ = lat_[w]
	lon_ = lon_[w]

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


imagemap_true, r_, g_, b_, lat_, lon_, limit=limit, center=center, isotropic=isotropic, $
	noerase = noerase, projection = projection, title = title, missing = missing, $
	 position = position, magnify = magnify,noborder=noborder,xmargin=xmargin,ymargin=ymargin

no_data:
if not keyword_set(oplot) then begin
	xyouts, (position[0]+position[2])/2., position[3] + 0.07*(position[3]-position[1]), title, /norm, align=0.5, charsize = tcharsize
	xyouts, (position[0]+position[2])/2., position[1]/2.- 0.035, xtitle, /norm, align=0.5, charsize= gcharsize
	xyouts, position[2]+0.05, (position[1]+position[3])/2., ytitle, orient=270., align=0.5, /norm, charsize = gcharsize

	if (keyword_set(no_continents) eq 0) then $
		map_continents, /continents, /hires, col = FILL_COLOR, coasts = coasts, $
					rivers=rivers, countries=countries, usa = usa, fill_continents=fill_continents, $
					mlinethick=con_thick

	if keyword_set(grid) then begin
		wis_grid, /horizon, /box_axes, lats=glats, lons=glons, glinesty=glinestyle, color=gcolor, $
			latdel=latdel, londel=londel
		; this next thing is necessary to get the labels to show up on the white background.
		if n_elements(gcolor) eq 0 then begin
			wis_grid, /no_grid, /box_axes, /horizon, latdel=latdel, londel=londel, lats=glats, lons=glons, charsize=gcharsize
		endif
	endif else begin
			wis_grid, /horizon, box_axes=box_axes, lats=glats, lons=glons, charsize=gcharsize, /no_grid, latdel=latdel, londel=londel, $
			lonnames = lonnames, latnames = latnames, sides=sides
	endelse

	if keyword_set(GFSGRID) then begin
		if n_elements(GFSCOLOR) eq 0 then GFSCOLOR = 255
		if n_elements(GFSLINESTYLE) eq 0 then GFSLINESTYLE = 0
		wis_grid, latdel=1, londel = 1, col = GFSCOLOR, glinesty = GFSLINESTYLE, lats = 0.5, lons=0.5
	endif

endif


; Restore Old Color Table
tvlct, rold, gold, bold

END
