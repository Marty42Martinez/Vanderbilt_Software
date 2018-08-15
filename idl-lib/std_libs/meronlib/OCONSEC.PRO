Function OConsec, npo, size = siz, center = cnt, radius = rad, $
    outside= out, count = con, new = new

;+
; NAME:
;	CONSEC
; VERSION:
;	3.3
; PURPOSE:
;	Selects the inside (and, optionally, outside) of a circular or annular 
;	region of an array.
; CATEGORY:
;	Array processing.
; CALLING SEQUENCE:
;	Result = SPHEREG([NPO] [,DIM] [SIZE = SIZ], RADIUS = RAD [,keywords])
; INPUTS:
;    NPO
;	Scalar or vector.  Not needed if SIZ is provided, mandatory otherwise.
;	If NPO is a scalar and DIM (see below) is not provided then SPHEREG 
;	assumes a square NPOxNPO array.  If DIM is provided then an array with
;	DIM dimensions and NPO points along each dimension is assumed.  Finally
;	if NPO is a vector then a NPO[0]xNPO[1]x... array is assumed and DIM 
;	(if provided) is ignored.
; OPTIONAL INPUT PARAMETERS:
;    DIM
;	Number of dimensions in the array.  Matters only if NPO is scalar and 
;	SIZE is not provided.
; KEYWORD PARAMETERS:
;    SIZE
;	Accepts input in the form of the output of the IDL SIZE command and 
;	uses it to form the array.  Mandatory, unless NPO is provided.  If both
;	SIZE and NPO are provided, NPO is ignored.
;    CENTER
;	Optional.  Location of the center of the selection sphere.  If given
;	must be a vector with one entry for each dimension of the array.  If
;	not provided, defaults to the middle of each dimension.
;    RADIUS
;	Mandatory.  The radius of the selection sphere.  may be given as scalar 
;	or as a 2D vector.  In the second case the annular region between
;	RADIUS_min and RADIUS_max is selected.
;    OUTSIDE
;	Optional output, see below.
;    COUNT
;	Optional output, see below.
; OUTPUTS:
;	Returns the indices of the array locations which fulfill the 
;	appropriate "inside" condition.  If no such indices exist, returns -1.
; OPTIONAL OUTPUT PARAMETERS:
;    OUTSIDE
;	The name of the variable to receive to complement of the indices set
;	returned by the function (i.e. indices corresponding to the outside of
;	the spherical or annular region).
;    COUNT
;	The name of the variable to receive the number of points fulfilling the
;	"inside" condition.  Same as the keyword COUNT in the WHERE function.
; COMMON BLOCKS:
;	None.
; SIDE EFFECTS:
;	None.
; RESTRICTIONS:
;	None.
; PROCEDURE:
;	Straightforward.  Generates an array of same dimension as the original,
;	containing the sums of the squares of the coordinates (relative to the
;	center) and compares with the provided radius (radii).  Calls DEFAULT
;	and MAKE_GRID from MIDL.
; MODIFICATION HISTORY:
;	Created 4-OCT-1999 by Mati Meron.
;-

    common old_barbarian, nfl, wdim, wcnt, xarr, yarr, sqv

    on_error, 1
    nfl = (n_elements(nfl) eq 0) or byte(keyword_set(new))

    if n_elements(siz) gt 0 then begin
	if siz[0] eq 2 then dim = siz[1:2] else $
	message, 'Only two dimensions allowed!'
    endif else begin
	ntem = n_elements(npo)
	case ntem of
	    0	:    message, 'Missing size information!'
	    1	:    dim = Cast([npo,npo],3,3)
	    2	:    dim = Cast(npo,3,3)
	    else:    message, 'Only two dimensions allowed!'
	endcase
    endelse

    if nfl then begin
	wdim = dim
	wcnt = Default(cnt,0.5*(dim-1),/dtyp)
	cntfl = nfl
    endif else begin
	if Arreq(dim,wdim) then begin
	    tcnt = Default(cnt,wcnt)
	    cntfl = not Arreq(tcnt,wcnt)
	    wcnt = tcnt
	endif else begin
	    wdim = dim
	    wcnt = Default(cnt,0.5*(dim-1),/dtyp)
	    nfl = not nfl
	    cntfl = nfl
	endelse
    endelse

    if nfl then begin
	xarr = findgen(dim[0],dim[1]) mod dim[0]
	yarr = transpose(findgen(dim[1],dim[0])) mod dim[1]
    endif
    if cntfl then sqv = (xarr - wcnt[0])^2 + (yarr - wcnt[1])^2

    rsq = [min(([rad,0.])[0:1]^2,max=max),max]
    bin = sqv ge rsq[0] and sqv le rsq[1]
    out = where(bin - 1b)

    return, where(bin, con)
end
