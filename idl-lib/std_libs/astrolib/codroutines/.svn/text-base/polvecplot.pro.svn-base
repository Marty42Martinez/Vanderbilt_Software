;+
; NAME:
;      POLVECPLOT
;
; PURPOSE:
;	Plot the polarisation "vectors" of a field, given a set of field locations.
;
; EXPLANATION:
;       This procedure plots the polarisation vectors of a field (at the
;       specified positions of the field).
;
; CATEGORY:
;       Plotting, Two-dimensional.
;
; CALLING SEQUENCE:
;       POLVECPLOT, X, Y, ANGLE [LENGTHS, LENGTH=, /OPLOT, /NODATA, _EXTRA = _EXTRA]
;
; INPUTS:
;       X	:  An array of any dimension, containing the x-components
;              of the field positions.
;       Y	:  An array of the same dimension as x, containing the
;              y-components of the field positions.
;       ANGLE:  An array of the same dimension as x, containing the
;              angles of the field polarisation at each position.
;
;
; OPTIONAL INPUT KEYWORD PARAMETERS:
;       LENGTH:     The maximum vectorlength relative to the plot data
;                   window.   Default = 0.08
;
;		OPLOT:		Set this keyword to Overplot over the last plot.
;
;       _EXTRA:     All other keywords available to PLOT, PLOTS are also used
;          			by this procedure (including XRANGE and YRANGE).
;
;		Note: the default for this procedure is to NOT CLIP (as for PLOTS).
;		If you want to clip the plot (no vectors plotted outside the box), set NOCLIP=0.
;
; MODIFICATION HISTORY
;	Nominally based on PARTVELVEC routine in the astrolib, but highly modified.
;		Chris O'Dell, June 2002.
;

PRO polvecplot, x, y, angle, lengths, length=length, xrange=xrange, yrange=yrange, $
				nodata = nodata, _extra = _extra, oplot=oplot, offset=offset

; Plots field of polarization vectors
; (x,y) center of line
; angle = angle of line [degrees]
; lengths (optional) : array of vectors lengths.
; offset : an optional offset for the data to get

a = angle * !pi/180 ; angles in radians
if n_elements(offset) eq 0 then offset = {x:0., y:0.}
xspan = max(x) - min(x)
yspan = max(y) - min(y)
if n_elements(xrange) eq 0 then xrange = [min(x)-0.05*xspan,max(x)+0.05*xspan]
if n_elements(yrange) eq 0 then yrange = [min(y)-.05*yspan,max(x)+.05*yspan]
if keyword_set(oplot) then begin
	xrange = !x.crange
	yrange = !y.crange
endif
xspan = xrange[1] - xrange[0]
yspan = yrange[1] - yrange[0]

if n_elements(length) eq 0 then length = 0.05
lx = length * xspan
ly = length * yspan

if n_elements(lengths) ne 0 then begin
	lx = lx * lengths
	ly = ly * lengths
endif
; Compute beginnings and endings of all lines to be plotted

x1 = x - 0.5 * lx * cos(a)
x2 = x + 0.5 * lx * cos(a)
y1 = y - 0.5 * ly * sin(a)
y2 = y + 0.5 * ly * sin(a)

; if necessary, lay down initial plot
if not keyword_set(oplot) then plot, xrange, yrange, /nodata, xran=xrange, yran=yrange, _extra=_extra

; plot polarisation vectors
if not keyword_set(nodata) then $
	for i = 0, n_elements(x)-1 do plots, [x1[i],x2[i]] + offset.x, [y1[i],y2[i]] + offset.y, _extra = _extra

END  ; End of procedure POLVECPLOT
