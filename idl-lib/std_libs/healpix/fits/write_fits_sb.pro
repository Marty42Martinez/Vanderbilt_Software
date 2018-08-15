pro write_fits_sb, filename, prim_st, exten_st, Coordsys=coordsys, Nested=nested, Ring=ring, Ordering=ordering, Partial=Partial_usr, Nside=nside_usr
;+
; writes a FITS file with data contained in a BINTABLE extension
;
; CALLING SEQUENCE:
;    WRITE_FITS_SB, filename, prim_st, exten_st, [Coordsys=, Ring=, Nested=,
;    Ordering=, Partial=]
;
; INPUTS:
;    filename = name of the output file 
;
;    prim_st  = structure containing the primary unit
;    with prim_st.hdr = prim_st.(0) : primary header to be added to the 
;       minimal header
;    with prim_st.(1) = primary image (if any)
;
;    ** note ** the healpix standard is to write all the information in the extension units,
;  leaving the primary unit empty. To do so, simply put prim_st = 0, and put the
;  information in exten_st (see example below)
;
;   the data is assumed to represent a full sky data set with 
;   the number of data points npix = 12*nside^2
;   unless   1) Partial is set OR the input fits header contains OBJECT =
;                  'PARTIAL'
;          AND 
;            2) the Nside is given a valid value OR the fits header contains
;                    a NSIDE
;
; OPTIONAL INPUT
;    exten_st = structure containing the extension unit if any
;    with exten_st.hdr = exten_st.(0) = extension header to be added to the
;        minimal header
;    with exten_st.(1)   = 1st column of the BINTABLE
;    with exten_st.(2)   = 2nd column of the BINTABLE if any
;    ...
;     
; KEYWORD
;    Ring- if set, add 'ORDERING= RING' to the extension fits header
;    Nested- if set, add 'ORDERING= NESTED' to the extension fits header
;    Ordering- if set to the string 'nested' or 'ring', set the
;              keyword 'ORDERING' to the respective value
;
;    one of them has to be present unless the ordering information is already
;    present in the fits header.
;
;    Nside- only useful if the data is not full sky and Partial is set,
;      by default Nside = sqrt(npix/12) where npix is the number of data point
;
; OPTIONAL KEYWORD
;   Coord = if set to either 'C', 'E' or 'G' specifies that the
;   Healpix coordinate system is respectively Celestial=equatorial, Ecliptic or Galactic
;
; EXAMPLES
;  to write out in 'map.fits' the RING-ordered Healpix maps 
;      signal (real) and n_obs (int) in Galactic coordinates,
;      NB: signal and n_obs should have the same size
;
;  e = create_struct('HDR',' ',  'SIGNAL',signal, 'N_OBS',n_obs) 
;                ; empty header, 1st column = signal, 2nd column = n_obs
;  write_fits_sb, 'map.fits', 0, e, order='ring', coord='g'
;                ; fits file with empty primary unit and binary extension
;
; Note
; ----
; for consistency with Healpix format the user should 
; give missing pixels
; the value -1.6375e30 in the array data
;
; MODIFICATION HISTORY:
;    written by Eric Hivon, IAP, Nov 11 1997
;    * writes 1024 entries per row and column (Healpix format)
;      this is much faster anyway                              EH Jan-98
;    March 2 1999, Eric Hivon, Caltech
;       solved problems with file unit numbers
;       added the structure interface
;  Feb 2000, EH, added test on pixel number, 
;    and healpix information (nside) in file header,
;    replace today() by today_fits()
;
;-


defsysv, '!DEBUG', EXISTS = i  ; check if astrolib variables have been set-up
if (i ne 1) then astrolib       ; if not, run astrolib to do so

;-------------------------------------------------------------------------------

hdr = fltarr(1)
image = 0
IF (N_TAGS(prim_st) GE 1) THEN hdr   = prim_st.(0)
IF (N_TAGS(prim_st) GE 2) THEN begin
    image = prim_st.(1)
    if (n_elements(image) gt 1) then begin
        print,'WARNING : writting data in the primary unit is NOT Healpix standard'
        print,'write_fits_sb, filename, prim_st, exten_st, [order=]'
    endif
endif
IF (N_TAGS(prim_st) GE 3) THEN begin
    print,'ERROR : multi column data should be written in the Extension, not the primary units'
    print,'write_fits_sb, filename, prim_st, exten_st, [order=]'
    print,'*** file not written ***'
    return
endif


; minimal header for this image
WRITEFITS, filename, 0
h0 = HEADFITS(filename)
CHECK_FITS, image, h0, /UPDATE, /FITS

; update date to Y2K
fdate = today_fits()
SXADDPAR,h0,'DATE',fdate,' Creation date (CCYY-MM-DD) of FITS header'

; add header information given by user
sxdelpar,hdr,['BITPIX','NAXIS','NAXIS1','NAXIS2','DATE','SIMPLE','EXTEND'] ; remove redundant information
iend = WHERE( STRUPCASE(STRMID(h0,0,8)) EQ 'END     ', nend)
if (STRMID(hdr(0),0,1) NE ' ') then h1 = [h0(0:iend(0)-1), hdr] else h1 = h0

; opens the file, write the header and the image if any, and close it
WRITEFITS, filename, image, h1
image = 0 & hdr = '' & h0=0 & h1=0
;-------------------------------------------------------------------------------
;------------------------------
; write the extension if any
;------------------------------
IF (N_ELEMENTS(exten_st) EQ 0) THEN RETURN ; undefined
IF (N_TAGS(exten_st)     EQ 0) THEN RETURN ; not a structure
xhdr = exten_st.(0)
number = n_tags(exten_st)

nside_fits = sxpar(xhdr,'NSIDE',count=c_nside)
object_fits = STRTRIM(STRING(sxpar(xhdr,'OBJECT',count=c_object)),2)

fullsky = 1
if undefined(nside_usr) then nside_usr = 0
junk1 = nside2npix(nside_fits,err=err1)
junk2 = nside2npix(nside_usr,err=err2)
if ((err1 eq 0 or err2 eq 0) and (object_fits eq 'PARTIAL' or keyword_set(partial_usr))) then begin
    if err2 eq 0 then nside = nside_usr else nside = nside_fits
    fullsky = 0
endif

if (fullsky) then begin
    npix = n_elements(exten_st.(1))
    nside = npix2nside(npix,err=errpix)
    if errpix ne 0 then begin
        print,'write_fits_sb: Non-Healpix data set'
        print,' npix = ',npix,' nside = ',nside
        print,' *** file NOT written !! ***'
        return
    endif
endif

; add ordering information according to user supplied value
add_ordering_fits,xhdr, nested=nested, ring=ring, ordering=ordering,error=error
if error ne 0 then begin
    print,' *** file NOT written '
    return
endif

; add coordsys information to user supplied extension header
if defined(coordsys) then add_coordsys_fits, xhdr, coordsys=coordsys

; add NSIDE information
add_nside_fits, xhdr, nside=nside, partial = 1-fullsky

; remove reserved keywords that will be added automatically later on
sxdelpar,xhdr,['XTENSION','BITPIX','NAXIS','NAXIS1','NAXIS2','PCOUNT','GCOUNT','TFIELDS']
sxdelpar,xhdr,'TFORM'+strtrim(string(indgen(number)+1,form='(i2)'),2)

nentry_healpix = 1024L
if (npix MOD nentry_healpix) EQ 0 then begin
    nrows = npix / nentry_healpix 
    nentry = nentry_healpix
endif else begin
    nrows = npix
    nentry = 1
endelse

; create the minimal extension header
FXBHMAKE,xthdr,nrows

for i=1, number-1 do begin
    data = REFORM(exten_st.(i),npix)

    ; update the header for 1 column with TFORMi = ' 1024x'
    FXBADDCOL,col,xthdr,REPLICATE(data(0),nentry)
endfor

; add the user defined header 
if (xhdr(0) ne ' ') then begin
    iend = WHERE( STRUPCASE(STRMID(xthdr,0,8)) EQ 'END     ', nend)
    if (nend eq 1) then begin
        iend = iend(0)
        xthdr = [xthdr(0:iend-1), xhdr]
    endif
endif

; reopens the file, goes to the extension and puts the  header there
FXBCREATE, unit, filename, xthdr

for i=1, number-1 do begin
    col = i
    data = REFORM(exten_st.(i),npix)
    
    ; writes data in the table
    for row = 1L, nrows do begin
        ir = row - 1L
	ifirst = ir * nentry
	ilast  = row * nentry - 1
	FXBWRITE,unit, data(ifirst:ilast), col, row
    endfor
endfor

; closes the file
FXBFINISH,unit

return
end


