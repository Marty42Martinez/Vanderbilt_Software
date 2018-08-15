pro mollview, file_in, select_in, $
COLT = colt, COORD = coord, CROP = crop, FLIP=flip, GAL_CUT=gal_cut, $
GIF = gif, GRATICULE = graticule, $
HIST_EQUAL = hist_equal, HXSIZE = hxsize, LOG = log, $
MAX = max_set, MIN = min_set, NESTED = nested_online, $
NOBAR = nobar, NOLABELS = nolabels, ONLINE = online, PREVIEW = preview, $
PS = ps, PXSIZE = pxsize, QUADCUBE = quadcube, NO_DIPOLE=no_dipole, NO_MONOPOLE=no_monopole, ROT = rot, SAVE = save, $
SUBTITLE = subtitle, TITLEPLOT = titleplot, $
UNITS = units, XPOS = xpos, YPOS = ypos, uK=uK

;+
; NAME:
;	MOLLVIEW
;
; PURPOSE:
; 	tool to view a Mollweide projection of maps binned
;	in Healpix or COBE Quad-Cube pixelisation
;
; CALLING SEQUENCE:
; 	MOLLVIEW, File, [Select, ] $
;                       [COLT=, COORD=, CROP= FLIP=, GAL_CUT=, GIF=, GRATICULE=, $
; 	                HIST_EQUAL=, HXSIZE=,  LOG=, $
;                       MAX=, MIN=, NESTED=,$
; 	                NOBAR=, NOLABELS=,  ONLINE=, PREVIEW=,$
;                       PS=, PXSIZE=, QUADCUBE= , NO_DIPOLE=, NO_MONOPOLE=,ROT=, SAVE=, $
;                       SUBTITLE=, TITLEPLOT=, $
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
;                        (only letters, digits and underscore are valid)
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
;       FLIP : if set the longitude increase to the right, whereas by
;               default (astro convention) it increases towards the left
;
;       GAL_CUT: (positive float) specifies the symmetric galactic cut in degree
;             outside of which the the monopole and/or dipole fitting is done
;             (see also: NO_DIPOLE, NO_MONOPOLE)
;
;	GIF : string containing the name of a .GIF output
;	      if set to 0 or not set : no .GIF done
;	      if set to 1            : output the plot in plot_mollweide.gif
;	      if set to a file name  : output the plot in that file
;             (see also : CROP, PS and PREVIEW)
;
; 	GRATICULE : if set, puts a graticule with delta_long = delta_lat = 45 degrees
;         if graticule is set to a scalar > 10 delta_long = delta_lat = graticule
;         if set to [x,y] with x,y > 10 then delta_long = x and delta_let = y
;
;	HIST_EQUAL : if not set, uses linear color mapping and
;                     		puts the level 0 in the middle
;                     		of the color scale (ie, green for Blue-Red)
;				unless MIN and MAX are not symmetric
;	       	      if set,     uses a histogram equalized color mapping
;			(useful for non gaussian data field)
;                     (see also : LOG)
;
; 	HXSIZE: horizontal dimension (in cm) of the Hardware plot :
;                Only for postscript printout
;    		default = 26 cm ~ 10 in
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
;		process
;               **  can not be used with /SAVE  **
;
;	PREVIEW : if set, there is a 'ghostview' preview of the
;	        postscript file (see : PS)
;                    or a 'xv' preview of the gif file (see : GIF)
;
;	PS :  if set to 0 or not set : output to screen
;	      if set to 1            : output the plot in plot_mollweide.ps
;	      if set to a file name  : output the plot in that file
;               (see : PREVIEW)
;
; 	PXSIZE: number of horizontal screen_pixels / postscript_color_dots of the plot
;    		default = 800
;    		(useful for high definition color printer)
;
;       NO_DIPOLE: if set to 1 (and GAL_CUT is not set)
;                the best fit monopole *and* dipole over all valid pixels are removed
;                * if GAL_CUT is set to b>0, the best monopole and dipole fit is done on all valid
;                pixels with |galactic latitude|>b (in deg) and is removed from all
;                pixels
;             can not be used together with NO_MONOPOLE
;             (see: GAL_CUT, NO_MONOPOLE)
;
;       NO_MONOPOLE: if set to 1 (and GAL_CUT is not set)
;                the best fit monopole over all valid pixels is removed
;                * if GAL_CUT is set to b>0, the best monopole fit is done on all valid
;                pixels with |galactic latitude|>b (in deg) and is removed from all
;                pixels
;             can not be used together with NO_DIPOLE
;             (see: GAL_CUT, NO_DIPOLE)
;
; 	ROT :   vector with 1, 2 or 3 elements specifing the rotation angles in DEGREE
;               to apply to the map in the 'output' coordinate system (see coord)
;             = ( lon0, [lat0, rat0])
;               lon0 : longitude of the point to be put at the center of the plot
;		       the longitude increases Eastward, ie to the left of the plot
;                      (unless flip is set)
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
;	uK   : Puts the units in microKelvin instead of Kelvin (added, CWO, 4/2002)

;
; NOTES
; 	this routine doesn't use the IDL map_set because it is precisely bugged for
; 	the mollweide projection (at least in IDL 4.0)
;
; SIDE EFFECTS
; 	this routine uses ghostview when PS and PREVIEW are selected
;	or xv when GIF and PREVIEW are selected
;
; EXAMPLES
;       ;to plot the signal of the COBE-DMR 4 year map at 53 GHz
;       read_fits_sb, 'dmr_skymap_53a_4yr.fits', dmr53a, /merge  ; read it only one time
;       mollview, dmr53a, /online, 'Sig', /quad
;
;       ;to plot it in Galactic coordinate instead of Ecliptic
;       mollview, drm53a, /online, 'Sig', /quad, coord='g'
;
; COMMONS USED : mollview_data
;
; PROCEDURES USED:
;       in the Healpix package :
;	  index_word, read_fits_sb, vec2pix_ring, vec2pix_nest
;         see  http://www.tac.dk/~healpix
;       it also requires the IDL astro library
;         http://idlastro.gsfc.nasa.gov/homepage.html
;       and the COBE analysis software
;         http://www.gsfc.nasa.gov/astro/cobe/cgis.html
;
; MODIFICATION HISTORY:
; 	October 1997, Eric Hivon, TAC
; 	Nov, 5, 1997,  correction of some bugs for postscript output
; 	13-Nov-97, H. Dole, IAS: save and log keywords
;  	4-Dec-97, H. Dole, IAS: online keyword
; 	16-Dec-97, E.H, TAC: added pxsize, hxsize, subtitle, nobar
;	17-Dec-97, split the loop for projection, added nolabels
;	March-98, E.H. added UNITS keyword
;	April-May-98 E.H. added NESTED_ONLINE, XPOS, YPOS, NOPREVIEW
;       March-99     E.H. Caltech, improved the GIF output
;              modified to deal with structures
;              added Select, COORD, ROT, QUADCUBE  suppressed LON0
;       April-99     E.H. Caltech, improved graticule
;       Nov-99         added flip
;       Feb-00   added rmmonopole and dipole, changed common
;       March-00   changed to no_monopole and no_dipole, changed common
;-

@mollcom ; define common

loadsky                         ; cgis package routine, define rotation matrices

routine = 'mollview'
IF (N_PARAMS() LT 1 OR N_PARAMS() GT 2) THEN BEGIN
    PRINT, 'Wrong number of arguments in'+routine
    DOC_LIBRARY,routine
    RETURN
ENDIF
IF (undefined(file_in)) then begin
    print,routine+': Undefined variable as 1st argument'
    return
endif
;;;file_in1   = file_in
if defined(select_in) then select_in1 = select_in else select_in1=1
if defined(save)      then save1 = save           else save1=0
if defined(online)    then online1 = online       else online1=0
do_flip = keyword_set(flip)

if (!D.n_colors lt 4) then stop,' : Sorry ... not enough colors available'

if (keyword_set(no_monopole) and keyword_set(no_dipole)) then begin
    print,routine+': choose either NO_MONOPOLE or NO_DIPOLE'
    print,'    (removal of best fit monopole only or best fit monopole+dipole)'
    return
endif

loaddata, $
  file_in, select_in,$
  data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, title_display, sunits, $
  SAVE=save, ONLINE=online, NESTED=nested_online, UNITS=units, COORD=coord, $
  ROT=rot, QUADCUBE=quadcube, LOG=log, ERROR=error
if error NE 0 then return

if keyword_set(uK) then data = data * 1e6

data2moll, $
  data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat,$
  planmap, Tmax, Tmin, color_bar,$
  PXSIZE=pxsize, LOG=log, HIST_EQUAL=hist_equal, MAX=max_set, MIN=min_set, FLIP=flip,  $
  NO_DIPOLE=no_dipole, NO_MONOPOLE=no_monopole, UNITS=sunits, DATA_plot = data_plot, GAL_CUT=gal_cut

moll2out, $
  planmap, Tmax, Tmin, color_bar, title_display, sunits, $
  COLT=colt, CROP=crop, GIF = gif, GRATICULE = graticule, $
  HXSIZE=hxsize, NOBAR = nobar, NOLABELS = nolabels, PREVIEW = preview, PS=ps, PXSIZE=pxsize, $
  SUBTITLE = subtitle, TITLEPLOT = titleplot, XPOS = xpos, YPOS = ypos

end

