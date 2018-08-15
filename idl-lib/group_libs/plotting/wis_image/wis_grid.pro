; $Id: map_grid.pro,v 1.49 2003/02/03 18:13:20 scottm Exp $
;
; Copyright (c) 1996-2003, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;+
; NAME:
;	MAP_GRID
;
; PURPOSE:
;       The MAP_GRID procedure draws the graticule of parallels and meridians,
; according to the specifications established by MAP_SET. MAP_SET must be called
; before MAP_GRID to establish the projection type, the center of the
; projection, polar rotation and geographical limits.
;
; CATEGORY:
;	Mapping.
;
; CALLING SEQUENCE:
;       MAP_GRID
;
; INPUTS:
;	NONE
;
; OPTIONAL INPUTS:
;	NONE
;
; KEYWORD PARAMETERS:
;

; BOX_AXES: Surround the map window with a "box" style axes with
;	      annotations, outside the box, where the parallels intersect the
;	      sides, and the meridians intersect the bottom and top edges of the
;	      box.  The border of the box is drawn in alternating foreground and
;	      background colors, with color changes at each intersection with
;	      a parallel or meridian.  This keyword determines the thickness of
;	      the box's border, in millimeters.  If LABEL is not explicitly
;	      specified, it defaults to 1 when this keyword is present.  If this
;	      feature is selected, be sure to leave enough room around the map
;	      window for the annotation, usually by specifying the XMARGIN and
;	      YMARGIN keywords to MAP_SET.  See the example below.
;   CHARSIZE: The size of the characters used for the labels. The default is 1.
;      COLOR: The color index for the grid lines.
;FILL_HORIZON: Fills the current map_horizon.
;    HORIZON: Draws the current map horizon.
;  INCREMENT: Determines the spacing between graticle points.
; GLINESTYLE: If set, the line style used to draw the grid of parallels and
;             meridians. See the IDL User's Guide for options. The default is
;             dotted.
; GLINETHICK: The thickness of the grid lines. Default is 1.
;      LABEL: Set this keyword to label the parallels and meridians with their
;             corresponding latitudes and longitudes. Setting this keyword to
;             an integer will cause every LABEL gridline to be labeled (i.e,
;             if LABEL=3 then every third gridline will be labeled). The
;             starting point for determining which gridlines are labeled is the
;             minimum latitude or longitude (-180 to 180), unless the LATS or
;             LONS keyword is set to a single value. In this case, the starting
;             point is the value of LATS or LONS.
;   LATALIGN: This keyword controls the alignment of the text baseline for
;             latitude labels. A value of 0.0 left justifies the label,
;             1.0 right justifies it, and 0.5 centers it.
;     LATDEL: The spacing in degrees between parallels of latitude in the grid.
;             If not set, a suitable value is determined from the current map
;             projection.
;       LATS: The desired latitudes to be drawn (and optionally labeled). If
;             this keyword is omitted, appropriate latitudes will be generated
;             with consideration of the optional LATDEL keyword. If this
;             keyword is set to a single value, drawn (and optionally labeled)
;             latitudes will be automatically generated  as
;             [...,LATS-LATDEL,LATS,LATS+LATDEL,...] over the extent of the
;             map.  The single valued LATS is taken to be the starting point
;             for labelling (See the LABEL keyword).
;     LATLAB: The longitude at which to place latitude labels. The default is
;             the center longitude on the map.
;   LATNAMES: An array specifing the names to be used for the latitude labels.
;             By default, this array is automatically generated in units of
;             degrees. This array can be a string array or numeric, but should
;             not be of mixed type. When LATNAMES is specified, LATS must also
;             be specified, but the number of elments in the two arrays need not
;             be equal. Extra LATNAMES are ignored, while LATNAMES not supplied
;             are automatically reported in degrees. LATNAMES can be used when
;             LATS is set to a single value. It this case, the LATS used will
;             start at the specified latitude and progress northward, wrapping
;             around the globe if appropriate. Caution should be used when
;             using LATNAMES in conjunction with a single LATS, since the
;             number of visible latitude gridlines is dependent on many factors.
;   LONALIGN: This keyword controls the alignment of the text baseline for
;             longitude labels. A value of 0.0 left justifies the label,
;             1.0 right justifies it, and 0.5 centers it.
;     LONDEL: The spacing in degrees between meridians of longitude in the grid.
;             If not set, a suitable value is determined from the current map
;             projection.
;     LONLAB: The latitude at which to place longitude labels. The default is
;             the center latitude on the map.
;       LONS: The desired longitudes to be drawn (and optionally labeled). If
;             this keyword is omitted, appropriate longitudes will be generated
;             with consideration of the optional LONDEL keyword. If this
;             keyword is set to a single value, drawn (and optionally labeled)
;             longitudes will be automatically generated as
;             [...,LONS-LONDEL,LONS,LONS+LONDEL,...] over the extent of the map.
;             The single valued LONS is taken to be the starting point for
;             labeling (See the LABEL keyword).
;   LONNAMES: An array specifing the names to be used for the longitude labels.
;             By default, this array is automatically generated in units of
;             degrees. This array can be a string array or numeric, but should
;             not be of mixed type. When LONNAMES is specified, LATS must also
;             be specified, but the number of elments in the two arrays need not
;             be equal. Extra LONNAMES are ignored, while LATNAMES not supplied
;             are automatically reported in degrees. LONNAMES can be used when
;             LONS is set to a single value. It this case, the LONS used will
;             start at the specified longitude and progress eastward, wrapping
;             around the globe if appropriate. Caution should be used when
;             using LONNAMES in conjunction with a single LONS, since the number
;             of visible longitude gridlines is dependent on many factors.
;
; NO_GRID: Set this keyword if you only want labels but not gridlines.
;
;ORIENTATION: Specifies the clockwise angle in degrees from horizontal
;             of the text baseline that the labels should be rotated. Note,
;             that the rotation used in MAP_SET is also clockwise, but XYOUTS
;             is normally counterclockwise.
;
; T3D: Set this keyword to indicate that the generalized transformation
;      matrix in !P.T is to be used. If not present, the user-supplied
;      coordinates are simply scaled to screen coordinates.
;
; ZVALUE: Sets the Z coordinate, in normalized coordinates in the
;         range of 0 to 1, at which to output the continents.
;
;      Note - This keyword has effect only if keyword T3D is set and the
;         transformation is stored in !P.T
;
;OUTPUTS:
;         Draws gridlines and labels on the current map.
;
; EXAMPLE:
;	  map_set,10,20,23.5,/cont,/ortho,/horizon     ; establish a projection
;         lats=[-65,-52,-35,-20,-2.59,15,27.6,35,45,55,75,89]
;                     ; choose the parallels to draw
;         map_grid,lats=lats,londel=20,lons=-13,label=2,lonlab=-2.5,latlab=7
;                     ;draw the grid
;   Make a map with a grid surrounded by a box style axis:
;	map_set, /STEREO, 40, -90,scale=50e6,/CONTINENTS, XMARGIN=3, YMARGIN=3
;	map_grid, /BOX_AXES, COLOR=3, CHARSIZE=1.5  ;
;
; MODIFICATION HISTORY:
; 	Written by:	SVP, May, 23 1996.
;	DMS, Feb, 1996 Note that this version plots all gridlines
;			unless a 4 element LIMIT was specified to MAP_SET.
;       SVP, Nov 1996   Changed over !map1 (new IDL5 maps)
;	SVP, May 1996	Map_Grid used to live inside of map_set.pro, now
;                       it lives here.
;       SVP, May 1996   Changed LABEL to determine the skip between labelled
;                       gridlines.
;                       Also, added the LATS and LONS keywords to give complete
;                       control over where the labels go.
;       SVP, Sept 1996  Added LATNAMS,LONAMES, and ORIENTATION keywords
;	DMS, Nov, 1996	Rev 2 of maps.
;	DMS, Jul, 1997  Added Box Axes
;-

function map_grid_incr, span
;
; Determine LONDEL or LATDEL if not specified
;
COMPILE_OPT hidden, IDL2

IF span eq 0 THEN return, 45.
ipow = 0
t = abs(span) < 450.
WHILE t lt 5 DO BEGIN t = t * 10 & ipow = ipow +1 & ENDWHILE
increments = [ 1., 2., 4., 5., 10., 15., 30., 45.]
i = 0
WHILE t gt (increments[i] * 10) DO i = i + 1
t = increments[i] / 10^ipow
return, span ge 0 ? t : -t
end


Function MAP_GRID_SOLVE, c0, c1, Icoord, Gwant
; Find the point on the line between points c0 and c1, expressed in
; DEVICE coordinates, where the longitude (Icoord = 0) or latitude
; (Icoord = 1) is equal to Gwant.  If the segment between c0 and c1
; doesn't intersect the given meridan or parallel, or either endpoint
; is not mappable, return NaN.
; Otherwise, return the device coordinate, X if Icoord = 0, or Y if
; Icoord = 1, of the intersection.

COMPILE_OPT hidden, IDL2
Forward_Function MAP_GRID_SOLVE, MAP_POINT_VALID

p0 = (convert_coord(c0, /DEVICE, /TO_DATA))[Icoord]
p1 = (convert_coord(c1, /DEVICE, /TO_DATA))[Icoord]

if finite(p0) eq 0 or finite(p1) eq 0 then return, !values.f_nan
if p1 eq p0 then return, !values.f_nan ;0 interval?
if (Icoord eq 0) and (p0 gt p1) then begin ;Wrap if we cross dateline
    if gwant gt 0 then p1 = p1 + 360. $
    else p0 = p0 - 360.
endif

t = (Gwant - p0) / (p1-p0)

ntry = 16                       ;Try the 16 sub intervals for a crossing
dtry = (c1-c0) / float(ntry)
itry = 0

while t gt 1.0 or t lt 0.0 do begin ;Find interval....
    del = c1 - c0               ;Interval size
    if total(abs(del)) le ntry then return, !values.f_nan
    if itry ne  0 then begin    ;Move interval up
        c0 = c1
        p0 = p1
        if itry ge 16 then return, !values.f_nan ;Didn't find it
    endif

    c1 = c0 + dtry
    p1 = MAP_GRID_SOLVE(c0, c1, Icoord, Gwant)
    if Finite(p1) then return, p1 $ ;Find it?
    else begin
        if finite(p1) eq 0 then return, !values.f_nan
        if p1 eq p0 then return, !values.f_nan
        t = (Gwant - p0) / (p1-p0)
        itry = itry + 1
    endelse
endwhile

low = 0.0
high = 1.0
tol = 1.0e-5
del = c1 - c0
while abs(high-low) gt tol do begin ;Binary chopping method
    t = (low + high) / 2.
    c = c0 + t * del
    p = (CONVERT_COORD(c, /DEVICE, /TO_DATA))[Icoord]
    if finite(p) eq 0 then return, p
    if (Icoord eq 0) then begin ;Check for dateline?
        if p lt p0 then p = p + 360. $ ;Wrap?  P should be in interval p0-p1.
        else if p gt p1 then p = p - 360.
    endif
    if (Gwant-p0) * (Gwant - p) gt 0.0 then begin ;In same interval as p0 : low
        low = t
        p0 = p
    endif else high = t         ;Keep low, and fcn at low = p0.
endwhile
return, c[Icoord]
end


PRO wis_grid, LABEL=label, LATDEL = latdel, NO_GRID=no_grid, $
       LONDEL=londel, GLINESTYLE=glinestyle, GLINETHICK=glinethick, $
       LONLAB=lonlab, LATLAB=latlab, LONALIGN=lonalign, $
       LATALIGN=latalign, LONNAMES=lonnames, LATNAMES=latnames, $
       LATS=lats, LONS=lons, ZVALUE=zvalue, $
       COLOR=color, T3D=t3d, CHARSIZE=charsize, ORIENTATION=orientation, $
       HORIZON=horizon, FILL_HORIZON=fill_horizon, _EXTRA=extra, $
       INCREMENT=increment, CLIP_TEXT=clip_text, BOX_AXES=box_axes, $
       WHOLE_MAP=obsolete_keyword, sides=sides


if (!x.type NE 3) THEN $  ; make sure we have mapping coordinates
   message, 'map_grid---Current ploting device must have mapping coordinates'

resolve_routine, 'MAP_SET', /NO_RECOMPILE ;We need map_set to be compiled
;
; Put a grid on a previously established map projection.
;
; no grid? - in case someone wants just to put labels
no_grid = keyword_set(no_grid)
;
; if Label = n, then Labels are added every n gridlines
;   If box_axes is set, and LABEL isn't explicitly specified, set label.
;
if n_elements(label) ne 0 THEN nlabel=fix(abs(label[0])) $
ELSE nlabel = keyword_set(box_axes)

have_lons =  n_elements(lons) gt 0
have_lats =  n_elements(lats) gt 0

if n_elements(zvalue) eq 0 THEN zvalue = 0

; CLIP_TEXT (default value = 1) = 1 to clip text within the map area,
; 0 to not clip text.
if n_elements(clip_text) eq 0 then noclip = 0 else $
  noclip = 1 - keyword_set(clip_text)

;	Append the graphics keywords:
if n_elements(t3d) then map_struct_append, extra,'T3D',t3d
if n_elements(color) then map_struct_append, extra, 'COLOR',color

if n_elements(glinestyle) eq 0 then glinestyle = 1 ;Default = dotted
map_struct_append, extra, 'LINESTYLE', glinestyle ;Append it

if n_elements(glinethick) then map_struct_append, extra,'THICK',glinethick
if n_elements(charsize) then map_struct_append, extra,'CHARSIZE', charsize

                                ;Orientation is reversed & conflicts w/box_axes
if n_elements(orientation) and (keyword_set(box_axes) eq 0) then $
  map_struct_append, extra,'ORIENTATION', -1 * orientation

if n_elements(sides) eq 0 then sides = [0,1,2,3]


;
; The gridlines can be specified by
;
;  1) an array of lats and/or lons
;  2) a single lats or lons which is taken to be the center
;     or 'for sure' lat or lon with gridlines every latdel or londel from it
;  3) automatically calculated if lats or lons are not specified.
;
;
; Require that LATS be specified when LATNAMES is ALSO SPECIFIED
;
if (n_elements(latnames) gt 0) and n_elements(lats) le 1 then $
  message,'map_grid---The LATNAMES keyword MUST be used in conjuction '+$
  'with the LATS keyword.'
if n_elements(lonnames) gt 0 and have_lons eq 0 then $
  message,'map_grid---The LONNAMES keyword MUST be used in conjuction '+$
  'with the LONS keyword.'

; Get lat/lon ranges from !MAP. Did MAP_SET specify 4 element limit?
if n_elements(lats) gt 1 then latmin = min(lats, max=latmax) $
else if !map.ll_box[0] ne !map.ll_box[2] then begin
    latmin = !map.ll_box[0] & latmax = !map.ll_box[2]
endif else begin
    latmin = -90 & latmax = 90
endelse

if have_lons then begin         ;Lons directly specified?
    lonmin = lons[0] & lonmax = lons[n_elements(lons)-1]
endif else if (!map.ll_box[1] ne !map.ll_box[3]) and $ ;Lon limit specified?
  (latmax lt 90.) and (latmin gt -90.) then begin ; and poles not included
    lonmin = !map.ll_box[1] & lonmax = !map.ll_box[3] ;Copy limits
endif else begin                ;If not, use entire globe
    lonmin = -180 & lonmax = 180
endelse

IF lonmax le lonmin THEN lonmax = lonmax + 360.

			;Default grid spacings...
IF n_elements(latdel) eq 0 THEN begin
    latdel = map_grid_incr(latmax - latmin)
    latd = 1
endif else latd = latdel

IF n_elements(londel) eq 0 THEN begin
    londel = map_grid_incr(lonmax - lonmin)
    lond = 1
endif else lond = londel


; IF the deltas are < 1,
; do not convert the limits into integers
IF abs(latmax - latmin) gt 5. and latd ge 1 THEN BEGIN ;Make range integers
    latmin = float(floor(latmin))
    latmax = ceil(latmax)
ENDIF

IF abs(lonmax - lonmin) gt 5 and lond ge 1 THEN BEGIN ;Integerize long spans
    lonmin = float(floor(lonmin))
    lonmax = ceil(lonmax)
ENDIF

; Where we label things...
IF N_Elements(Latlab) eq 0 THEN Latlab = (lonmin + lonmax)/2
IF N_ELements(LonLab) eq 0 THEN LonLab = (latmin +latmax)/2

IF n_elements(latalign) eq 0 THEN latalign = .5	;Text alignment of lat labels
IF n_elements(lonalign) eq 0 THEN lonalign = .5 ;Text alignment of lon labels
;
map_proj_info, iproj, CYLINDRICAL=is_cyl, /CURRENT ;Is this a cylindrical proj?

if keyword_set(increment) then step = increment $
else step = 4 < (latmax - latmin)/10.

len = long(float((latmax-latmin)) / float(step) + 1.0)

; Clip to avoid roundoff errors which can cause the latitude to exceed
; 90 degs by a very small amount.
lati = (float(latmax-latmin) / (len-1.)) * findgen(len) + latmin > (-90) < 90

; This fudge avoids curved meridians at the poles because of the split planes
if is_cyl and !map.p0lat eq 0 then begin
    del = 2.0e-2
    if lati[0] eq -90 then lati[0] = del - 90.
    if lati[len-1] eq 90 then lati[len-1] = 90. - del
endif


;Compute longit distance between points for latitude lines.
step = 4 < (lonmax - lonmin)/10. ;At most 4 degrees
len = (lonmax-lonmin)/step + 1
loni = findgen(len) * step + lonmin
IF (loni[len-1] NE lonmax) THEN loni = [loni, lonmax]


;
; Determine the number of lons and the lon array
;
if n_elements(lons) eq 0 then begin
    n_lons = 1+fix((lonmax-lonmin) / londel)
    longitudes = lonmin - (lonmin mod londel) + findgen(n_lons) * londel
endif else if n_elements(lons) eq 1 then begin
    i0 = ceil((lonmin - lons[0]) / float(londel)) ;First tick
    i1 = floor((lonmax - lons[0]) / float(londel)) ;Last tick
    n_lons = i1 - i0 + 1 > 1
    longitudes = (findgen(n_lons) + i0) * londel + lons[0]
endif else begin
    n_lons=n_elements(lons)
    longitudes=lons
endelse

;
; Determine the number of lats and the lat array
;
if n_elements(lats) eq 0 then begin
    lat0 = latmin - (latmin mod float(latdel)) ;1st lat for grid
    n_lats = 1 + fix((latmax-lat0)/float(latdel))
    latitudes = lat0 + findgen(n_lats)*latdel
endif else if n_elements(lats) eq 1 then begin
    i0 = ceil((latmin - lats[0]) / float(latdel)) ;First tick
    i1 = floor((latmax - lats[0]) / float(latdel)) ;Last tick
    n_lats = i1 - i0 + 1 > 1
    latitudes = (findgen(n_lats) + i0) * latdel + lats[0]
endif else begin
    n_lats=n_elements(lats)
    latitudes=lats
endelse

;
; Build the Latitude/Longitude Label Flags
;
lon_label = bytarr(n_lons)
lat_label = bytarr(n_lats)
if nlabel ne 0 then begin
    if n_elements(lons) eq 1 then begin ; Ensure center is set and then go out
        index=where(longitudes eq lons[0])
        for i=(index[0] > 0) mod nlabel, n_lons-1, nlabel do lon_label[i] = 1
    endif else begin
        for i=0, n_lons-1, nlabel do lon_label[i] = 1
    endelse

    if n_elements(lats) eq 1 then begin ; Make sure the center one is set
                                ; and go out from there
        index=where(latitudes eq lats[0], count)
        for i=(index[0] > 0) mod nlabel, n_lats-1, nlabel do lat_label[i] = 1
    endif else begin            ; Start with latmin and label each nlabel point
        for i=0, n_lats-1, nlabel do lat_label[i] = 1
    endelse

endif
;
;   Dont repeat 180 labelling if the projection is cylindrical or
;   polar and both 180 and -180 are present. This can be defeated by using
;   LONS=-180
;
if is_cyl or (abs(!map.p0lat) eq 90) then begin
    id_180 = where(longitudes eq 180,count)
    id_m180 = where(longitudes eq -180,mcount)
    if count gt 0 and mcount gt 0 then begin
        if n_elements(lons) eq 1 then begin
            if lons[0] eq -180 then lon_label[id_180]=0
        endif else lon_label[id_m180]=0
    endif
endif

n = n_lons > n_lats             ;
latlontxt = strarr(n, 2)

if keyword_set(box_axes) then begin ;Draw a Box legend?
    box_thick = box_axes * 0.1  ;From mm to Thickness in cm
    dc = !d.y_ch_size           ;Char height to draw
    if n_elements(charsize) then dc = dc * charsize
    xw = !x.window * !d.x_size  ;Window coords in x & y
    yw = !y.window * !d.y_size
; xww and yww = corners of the uv_range that is mappable.  If NOBORDER
; was set for MAP_SET, this is the same as the window coords (xw,yw),
; otherwise, this rectangle is smaller than the window rectangle.
; Fudge factor for window to ensure that the edges are mappable.
    del = [1,-1]* 0.01
    xww = (!map.uv_box[[0,2]] * !x.s[1] + !x.s[0]) * !d.x_size + del
    yww = (!map.uv_box[[1,3]] * !y.s[1] + !y.s[0]) * !d.y_size + del

    bdel = box_thick * !d.y_px_cm ;Thickness of box in device units

    if n_elements(color) eq 0 then bcolor = !p.color $  ;Box color
    else bcolor = color

    xp = xw[0] - [0,bdel, bdel,0] ;X  & Y polygon coords for outer box
    yp = yw[0] - [0,0,bdel,bdel]
                                ;Draw the outline of the box
    plots, xw[[0,1,1,0,0]], yw[[0,0,1,1,0]], /DEVICE, COLOR=bcolor
    plots, xw[[0,1,1,0,0]]+[-bdel, bdel, bdel, -bdel, -bdel], $
      yw[[0,0,1,1,0]]+[-bdel, -bdel, bdel, bdel, -bdel], /DEVICE, COLOR=bcolor

    ychar = [yw[0]-bdel-dc, yw[1]+bdel+dc/4.]
    xchar = [xw[0] - bdel - dc/4., xw[1]+bdel+dc/4.]
    boxpos = replicate(!values.f_nan, n, 2,2)

;Device coordinates for box annotations. Go in to avoid edges of map &
;border which are frought with singularities.  Also to avoid effects
;of MAP_SET,/NOBORDER.  For box axes to be annotated, all the edges of the
;map rectangle must be mappable.
;
endif else box_thick = 0

                                ;  Do the horizon if specified.
if keyword_set(horizon) then map_horizon, _EXTRA=e
if keyword_set(fill_horizon) then map_horizon, _EXTRA=e, /FILL

;
;   ****************** Draw/Label the meridians ******************
;
FOR i=0,n_lons-1 DO BEGIN
    lon=longitudes[i]
    IF (lon lt -180) THEN lon2 = lon + 360  $
    ELSE IF (lon gt 180) THEN lon2 = lon - 360 $
    ELSE lon2 = lon

; This block of code draws longitude lines that are at the center + or
; - 180 degrees, at center + or - (180-eps) to ensure that the grid
;   appears on the correct side.  Its really not necessary if people
;   would use the /HORIZON keyword, but they don't.

    if is_cyl then begin
        del = lon - !map.p0lon
        while del gt 180 do del = del - 360.
        while del lt (-180) do del = del + 360.
        if abs(del) eq 180 then begin
            lon = lon - 1.0e-5 * (2*(del ge 0)-1) ;fudge it (sign(1.0e-5, del))
        endif
    endif

    IF no_grid eq 0 THEN PLOTS, lon, lati, zvalue, NOCLIP=0, _EXTRA=extra

    IF lon2 ne long(lon2) THEN fmt = '(f7.2)' ELSE fmt = '(i4)'

    IF lon_label[i] THEN BEGIN
        IF i lt n_elements(lonnames) then begin ;User specified label?
            IF (reverse(size(lonnames[i])))[1] eq 7 then $ ;String?
              lonname=lonnames[i] else $
              lonname=strtrim(string(lonnames[i], FORMAT=fmt),2)
        endif else lonname=strtrim(string(lon2, format=fmt),2)
        latlontxt[i,0] = lonname
        if (box_thick eq 0) and $
          ((noclip eq 1) or map_point_valid(lon, LonLab)) then $
          XYOUTS, lon, LonLab, lonname, $
          ALIGNMENT=lonalign, NOCLIP=noclip, Z=zvalue, _EXTRA=extra
    ENDIF

    if box_thick ne 0 then begin
        dy = (yw[1] - yw[0]) * 0.01 ;1% of the height
        for j=0,1 do begin      ;Save longitude crossings, try for edge...
            k = 0
; Try to find longitude crossings.  If it doesn't cross exactly at the
; edge, try going in until it crosses and is valid.
            while finite(boxpos[i,j,0]) eq 0 and abs(k) lt 3 do begin
                boxpos[i, j, 0] = map_grid_solve([xww[0], yw[j]+k*dy], $
                                                 [xww[1], yw[j]+k*dy], 0, lon)
                k = k + (j ? -1 : 1)
            endwhile
        endfor
    endif
ENDFOR

;
; Draw/Label the parallels of latitude  ******************
;

FOR i=0,n_lats-1 DO BEGIN
    lat=latitudes[i]
    IF lat ne long(lat) THEN fmt = '(f7.2)' ELSE fmt = '(i4)'
    IF lat_label[i] THEN BEGIN
        IF i lt n_elements(latnames) then begin ;User specified latname?
            IF (reverse(size(latnames[i])))[1] eq 7 then $
              latname=latnames[i] else $
              latname=strtrim(string(latnames[i],format=fmt),2)
        endif else latname=strtrim(string(lat, format=fmt),2)
        latlontxt[i, 1] = latname
        if box_thick eq 0 and $
          ((noclip eq 1) or map_point_valid(latlab, lat)) then $
          XYOUTS, latlab, lat, latname, $
          alignment=latalign, NOCLIP=noclip, Z=zvalue, _EXTRA=extra
    ENDIF

    IF (no_grid eq 0) and (abs(lat) ne 90) THEN PLOTS, loni, lat, zvalue, $
      NOCLIP=0, _EXTRA=extra

    if box_thick ne 0 then for j=0,1 do begin ;Save latitude crossings
; Start at edge and try for an intersection.  If that doesn't work, go
; in some.
        k = 0
        dx = (xw[1] - xw[0]) * 0.01
        while finite(boxpos[i,j,1]) eq 0 and abs(k) lt 3 do begin
            boxpos[i, j, 1] = map_grid_solve([xw[j]+dx*k, yww[0]], $
                                             [xw[j]+dx*k, yww[1]], 1, lat)
            k = k + (j ? -1 : 1)
        endwhile
    endfor
endfor

; ******************************** Do the box axes **************************
if box_thick ne 0 then for iaxis=0,1 do for j=0,1 do begin
    v = boxpos[*,j,iaxis]       ;Values along axes
    good = where(finite(v), count) ;Ignore bad values
    dy = iaxis eq 1
    if (where( (2*iaxis+j) eq sides))[0] eq -1 then thislabel= 0 else thislabel = 1
    if count gt 0 then begin    ;Anything there?
        v = v[good]             ;Remove unmappable elements
        subs = sort(v)          ;Sort the axis crossings
        v = v[subs]             ;Sorted Y values
        vtext = (latlontxt[good,iaxis])[subs]
        v0 = ([xw[0], yw[0]])[iaxis] ;Starting value on axis
        xp0 = xp + j * (xw[1]-xw[0] + bdel) ;Polygon X coords
        yp0 = yp + j * (yw[1]-yw[0] + bdel) ;Y coords
        xychar = [xchar[j], ychar[j]] ;Char position
        for i=0, count-1 do begin ;Draw each item
            z = v[i]            ;Axis crossing value
            if iaxis eq 0 then xp0 = [v0, z, z, v0] $
            else yp0 = [v0, v0, z, z]
            if (i and 1) then polyfill, xp0, yp0, /DEVICE, COLOR=bcolor
            xychar[iaxis] = z
            if strlen(vtext[i]) gt 0 AND thislabel then $
              xyouts, xychar[0], xychar[1], vtext[i], $
              ORIENTATION=dy * (90-180*j), $
              ALIGN=0.5, CLIP=0, Z=zvalue, /DEVICE, _EXTRA=extra
            v0 = z
        endfor
                                ;Fill to the end of the axis
        if iaxis eq 0 then xp0 = [v0, xw[1], xw[1], v0] $
        else yp0 = [v0, v0, yw[1], yw[1]]
        if i and 1 then polyfill, xp0, yp0, /DEVICE, COLOR=bcolor
    endif                       ;if count
endfor                          ;box_thick


end
