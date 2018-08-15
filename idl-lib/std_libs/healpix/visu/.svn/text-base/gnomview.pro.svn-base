PRO gnomview, file_in, select_in, $
COLT = colt, COORD = coord, CROP = crop, FITS = fits, GIF = gif, $
GRATICULE=graticule, HIST_EQUAL = hist_equal, HXSIZE = hxsize, LOG = log, $
MAX = max_set, MIN = min_set, NESTED = nested_online, $
NOBAR = nobar, NOLABELS = nolabels, ONLINE = online, PREVIEW = preview, $
PS = ps, PXSIZE = pxsize, PYSIZE = pysize, QUADCUBE = quadcube, $
RESO_ARCMIN = reso_arcmin, ROT = rot, SAVE = save, $
SUBTITLE = subtitle, TITLEPLOT = titleplot, $
UNITS = units, XPOS = xpos, YPOS = ypos
;+
; NAME:
; 	GNOMVIEW
;
; PURPOSE:
; 	tool to view a Gnomonic projection of maps binned
;	in Healpix or COBE Quad-Cube pixelisation
;
; CALLING SEQUENCE:
; 	GNOMVIEW, File, [Select, ]
;                       [COLT=, COORD=, FITS=, GIF=, 
; 	                GRATICULE=, HIST_EQUAL=, HXSIZE=,  LOG=, 
;                       MAX=, MIN=, NESTED=,
; 	                NOBAR=, NOLABELS=, ONLINE=, PREVIEW=, 
;                       PS=, PXSIZE=, PYSIZE=, QUADCUBE= ,
;                       RESO_ARCMIN= , ROT=, SAVE=, 
;                       SUBTITLE=, TITLEPLOT=, 
; 	                UNITS=, XPOS=, YPOS=]
;                        
; INPUTS:
; 	File = 
;          by default,           name of a FITS file containing 
;               the healpix map in an extension or in the image field
;          if Online is set :    name of a variable containing
;               the healpix map
;          if Save is set   :    name of an IDL saveset file containing
;               the healpix map stored under the variable  data
;
; OPTIONAL INPUTS:
;       Select =  if the file read is a multi column BIN table, Select indicates
;                 which column is to be plotted (the default is to plot the first one)
;               can be either a name : value given in TTYPEi of the FITS file
;                        NOT case sensitive and
;                        can be truncated, 
;               or an integer        : number i of the column
;                            containing the data, starting with 1
;                   the default value is 1
;               (see the Examples below)
;
; OPTIONAL INPUT KEYWORDS:
; 	COLT : color table number, in [0,40]
;        	if unset the color table will be 33 (Blue-Red)
;
;       COORD : vector with 1 or 2 elements describing the coordinate system of the map 
;                either 'C' or 'Q' : Celestial2000 = eQuatorial,
;                       'E'        : Ecliptic,
;                       'G'        : Galactic 
;               if coord = ['x','y'] the map is rotated from system 'x' to system 'y'
;               if coord = ['y'] the map is rotated to coordinate system 'y' (with the
;               original system assumed to be Galactic unless indicated otherwise in the file)
;                  see also : Rot
;
;       CROP : if set the GIF file only contains the mollweide map and
;               not the title, color bar, ...
;               (see also : GIF)
;
;       FITS : string containing the name of an output fits file with
;       the rectangular map in the primary image
;	      if set to 0 or not set : no .FITS done
;	      if set to 1            : output the plot in plot_gnomic.fits
;	      if set to a file name  : output the plot in that file 
;
;	GIF : string containing the name of a .GIF output
;	      if set to 0 or not set : no .GIF done
;	      if set to 1            : output the plot in plot_gnomic.gif
;	      if set to a file name  : output the plot in that file 
;             (see also : PS and PREVIEW)
;
; 	GRATICULE : if set, puts a graticule with delta_long = delta_lat = 5 degrees
;         if graticule is set to a scalar real > 0 delta_long = delta_lat = graticule
;         if set to [x,y] with x,y > 0 then delta_long = x and delta_let = y
;
;	HIST_EQUAL : if not set, uses linear color mapping and 
;                     		puts the level 0 in the middle
;                     		of the color scale (ie, green for Blue-Red)
;				unless MIN and MAX are not symmetric
;	       	      if set,     uses a histogram equalized color mapping
;			(useful for non gaussian data field)
;                     (see also : LOG)
;
; 	HXSIZE: horizontal dimension (in cm) of the Hardcopy plot : Only for postscript printout
;    		default = 15 cm 
;    		(useful for large color printer)
;               (see also : PXSIZE)
;
; 	LOG: display the log of map (see also : HIST)
;
; 	MAX : max value plotted, 
;		every data point larger than MAX takes the same color as MAX
;
; 	MIN : min value plotted, 
;		every data point smaller than MIN takes the same color as MIN
;
;	NESTED: specify that the online file is ordered in the nested scheme
;
; 	NOBAR : if set, no color bar is present
;
;	NOLABELS : if set, no color bar label (min and max) is present
;
; 	ONLINE: if set, you can put directly A HEALPIX VECTOR on File (and
;    		without header): useful when the vector is already
;    		available on line, and avoid to have to write it on disk
;    		just to be read by mollview
;		N.B. : the content of file_in is NOT altered in the
;		process, **  can not be used with /SAVE  **
;
;	PREVIEW : if set, there is a 'ghostview' preview of the
;	        postscript file (see : PS)
;                    or a 'xv' preview of the gif file 
;                (see also : GIF)
;
;	PS :  if set to 0 or not set : output to screen
;	      if set to 1            : output the plot in plot_mollweide.ps
;	      if set to a file name  : output the plot in that file 
;               (see also : GIF and PREVIEW)
;
; 	PXSIZE: number of horizontal screen_pixels or postscript_color_dots of the plot
;    		default = 500 
;    		(useful for high definition color printer)
;
; 	PYSIZE: number of vertical screen_pixels or postscript_color_dots of the plot
;    		default = PXSIZE
;    		(useful for high definition color printer)
;
;       RESO_ARCMIN: resolution of the Mollweide map in arcmin
;       (default=1.5)
;
; 	ROT :   vector with 1, 2 or 3 elements specifing the rotation angles in DEGREE
;               to apply to the map in the 'output' coordinate system (see coord)
;             = ( lon0, [lat0, rot0]) 
;               lon0 : longitude of the point to be put at the center of the plot
;		       the longitude increases Eastward, ie to the left of the plot
; 		      =0 by default
;               lat0 : latitude of the point to be put at the center of the plot
; 		      =0 by default
;               rot0 : anti clockwise rotation to apply to the sky around the
;                     center (lon0, lat0) before projecting
;                     =0 by default
;
; 	SAVE: if set, tells that the file is in IDL saveset format, 
;    		the variable saved should be DATA 
;                 ** can not be used with /ONLINE **
;
; 	SUBTITLE : String containing the subtitle to the plot (see TITLEPLOT)
;
; 	TITLEPLOT : String containing the title of the plot, 
;     		if not set the title will be File (see SUBTITLE)
;
;	UNITS : character string containing the units, to be put on the right
;		side of the color bar (see : NOBAR)
;
;	XPOS : The X position on the screen of the lower left corner
;	        of the window, in device coordinate
;
;	YPOS : The Y position on the screen of the lower left corner 
;               of the window, in device coordinate
;
; NOTES
; 	this routine doesn't use the IDL map_set because it is precisely bugged for 
; 	the mollweide projection (at least in IDL 4.0)
;
; SIDE EFFECTS
; 	this routine uses ghostview when PS is selected and nopreview is not
;	or xv when GIF is selected and nopreview is not
;
; EXAMPLES
;
; COMMONS USED : 
;
; PROCEDURES USED: 
;       in the Healpix package :
;	  index_word, read_fits_sb, vec2pix_ring, vec2pix_nest, euler_matrix
;         see  http://www.tac.dk/~healpix
;       it also requires the IDL astro library
;         http://idlastro.gsfc.nasa.gov/homepage.html
;       and the COBE analysis software
;         http://www.gsfc.nasa.gov/astro/cobe/cgis.html
;
; MODIFICATION HISTORY:
;       ?? 1998, Eric Hivon, TAC
;       March-April 99, E.H. Caltech
;-

@gnomcom ; define common

loadsky                         ; cgis package routine, define rotation matrices

routine = 'gnomview'
IF (N_PARAMS() LT 1 OR N_PARAMS() GT 2) THEN BEGIN
    PRINT, 'Wrong number of arguments in'+routine
    DOC_LIBRARY,routine
    RETURN
ENDIF
IF (undefined(file_in)) then begin
    print,routine+': Undefined variable as 1st argument'
    return
endif
file_in1   = file_in
if defined(select_in) then select_in1 = select_in else select_in1=1
if defined(save)      then save1 = save           else save1=0
if defined(online)    then online1 = online       else online1=0

if (!D.n_colors lt 4) then stop,' : Sorry ... not enough colors available'

loaddata, $
  file_in, select_in,$
  data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, title_display, sunits, $
  SAVE=save,ONLINE=online,NESTED=nested_online,UNITS=units,COORD=coord,$
  ROT=rot,QUADCUBE=quadcube,LOG=log,ERROR=error
if error NE 0 then return


data2gnom, $
  data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, $
  planmap, Tmax, Tmin, color_bar, dx, $
  PXSIZE=pxsize, PYSIZE=pysize, ROT=rot, LOG=log, HIST_EQUAL=hist_equal, MAX=max_set, MIN=min_set, $
  RESO_ARCMIN = reso_arcmin, FITS = fits


gnom2out, $
  planmap, Tmax, Tmin, color_bar, dx, title_display, sunits, coord_out, do_rot, eul_mat, $
  COLT=colt, CROP=crop, GIF = gif, GRATICULE = graticule, HXSIZE = hxsize, $
  NOBAR = nobar, NOLABELS = nolabels, PREVIEW = preview, PS = ps, $
  PXSIZE=pxsize, PYSIZE=pysize, ROT = rot, SUBTITLE = subtitle, $
  TITLEPLOT = titleplot, XPOS = xpos, YPOS = ypos



RETURN
END

