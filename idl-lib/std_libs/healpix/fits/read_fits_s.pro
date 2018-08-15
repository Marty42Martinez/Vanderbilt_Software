pro read_fits_s, filename, prim_stc, xten_stc, merge=merge
;+
; NAME:
;       READ_FITS_S
;
; PURPOSE:
; 	reads a multi column binary or ascii table extension (eg temperature
; 	and polarisation or polarisation power spectrum) of FITS file filename
; 	if doesn't find an extension, look in the image part
;
; CALLING SEQUENCE:
; 	READ_FITS_S, Filename, Prim_Stc [, Xten_Stc, Merge=]
; 
; INPUTS:
;	filename = String containing the name of the file to be read.
;
; OUTPUTS:
;	Prim_Stc = structure containing
;                  - the primary header, tag : 0, tag name : HDR
;                  - the primary image (if any) as an array,
;                    tag : 1, tag name : IMG, 
;
;       if MERGE is set Prim_Stc contains
;                  - the concatenated primary and extension header : HDR
;                  - the primary image if any, tag name : IMG
;                  - the data column, tag name : name given in TTYPEi (with all
;                    spaces removed and only letters, digits and underscore)
;       and xten_stc is 0
;                    
; OPTIONAL OUTPUTS:
;       if MERGE is not set
;	xten_stc = structure containing
;                  - the extension header, tag 0, tag name HDR
;                  - the data column
;                    tag : i, tag name : name given in TTYPEi (with all
;                    spaces removed and only letters, digits and underscore)
;
; OPTIONAL INPUT KEYWORDS:
;      merge = if set, the content of the primary and secondary units
;      are merged
;
; PROCEDURES USED:
;	mrdfits (astron library)
;
; TIPS:
;    to plot column 5 vs. column 1 of 'file' irrespective of their name
;        read_fits_sb, 'file', prims, exts
;        x = exts.(1)
;        y = exts.(5)
;        plot,x,y
;
;    to plot the column SIGNAL versus the column NOISE without knowing
;    their position
;        read_fits_sb, 'file', prims, exts
;        x = exts.signal
;        y = exts.noise
;        plot,x,y
;
; MODIFICATION HISTORY:
;  March 1999, EH, version 1.0
;  March 21, modified to deal with large files
;
; requires the THE IDL ASTRONOMY USER'S LIBRARY 
; that can be found at http://idlastro.gsfc.nasa.gov/homepage.html
;
;-

if N_params() LT 1 or N_params() GT 3 then begin
    print,'read_fits_s, prim_stc, xten_stc, [merge=]
    prim_stc = 0 & xten_stc = 0
    return
endif

; run astrolib routine to set up non-standard system variables
defsysv, '!DEBUG', EXISTS = i  ; check if astrolib variables have been set-up
if (i ne 1) then astrolib       ; if not, run astrolib to do so

merge = keyword_set(merge)

; ------ primary unit : header and extension ------

image = MRDFITS(filename,0,hdr)
prim_stc = CREATE_STRUCT('HDR',hdr)
if ((size(image))(0) NE 0) then prim_stc = CREATE_STRUCT(prim_stc,'IMG',image)

xten_stc = 0
fits_info,filename, /silent, n_ext=n_ext
if (n_ext eq 0) then return


; ----- if there is an extension ------
xtn = 1
table = MRDFITS(filename,xtn,xthdr,range=1)  ; first row
tags = TAG_NAMES(table)
n_tag = N_TAGS(table)
bitpix  = ABS(ROUND(SXPAR(xthdr,'BITPIX'))) ; bits per 'word'
n_wpr   =     ROUND(SXPAR(xthdr,'NAXIS1')) ; 'word' per row
n_rows  =     ROUND(SXPAR(xthdr,'NAXIS2')) ; number of rows
byt_row = bitpix * n_wpr / 8 ; bytes per row
stride = (1024L^2 * 10L) / byt_row ; strides of 10MB
ishift = 0
n_entry = intarr(n_tag)

; start building the structure with the header
case (merge) of
    0 : xten_stc = CREATE_STRUCT('HDR',xthdr)
    1 : begin
        prim_stc = CREATE_STRUCT('HDR',[hdr,xthdr])
        if (image NE 0) then begin
            prim_stc = CREATE_STRUCT(prim_stc,'IMG',image)
            ishift = 1
        endif
    end
endcase

; build up the final structure according to data
for i=0L, n_tag-1 do begin      
    type = datatype(table.(i),2)
    n_entry(i) = n_elements(table.(i))
    n_el = n_entry(i)*n_rows
    case (merge) of
    0 : xten_stc = CREATE_STRUCT(xten_stc, tags(i), MAKE_ARRAY(n_el,TYPE=type))
    1 : prim_stc = CREATE_STRUCT(prim_stc, tags(i), MAKE_ARRAY(n_el,TYPE=type))
    endcase
endfor

; read the data by piece to avoid overloading memory and fill in the structure
r_start = 0L
while (r_start LE (n_rows-1) ) do begin
    r_end = (r_start + stride - 1L) < (n_rows-1)
    table = MRDFITS(filename,xtn,range=[r_start,r_end],/SILENT)
    for i=0L, n_tag-1 do begin
        nn = n_elements(table.(i))
        ni = n_entry(i)
        ;;help,prim_stc.(i+ishift+1)(r_start*ni:r_end*ni+ni-1),reform(table.(i),nn)
        case (merge) of
        0 : xten_stc.(i+ishift+1)(r_start*ni:r_end*ni+ni-1) = (reform(table.(i),nn))(*)
        1 : prim_stc.(i+ishift+1)(r_start*ni:r_end*ni+ni-1) = (reform(table.(i),nn))(*)
        endcase
    endfor
    r_start = r_end + 1L
endwhile




return
end

