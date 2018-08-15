function sub_ud_grade, map_in, nside_in, nside_out, bad_data=bad_data

npix_in  = nside2npix(nside_in)
npix_out = nside2npix(nside_out)

if undefined(bad_data) then bad_data = -1.6375e30
bad = where(map_in eq bad_data, nbad)
if nbad gt 0 then map_in[bad] = !values.f_nan

if nside_out gt nside_in then begin
    rat2 = npix_out/npix_in
    map_out = reform(replicate(1,rat2)#map_in[*],npix_out)
endif else begin
    rat2 = npix_in/npix_out
    map_out = total(reform(map_in,rat2,npix_out),1)/rat2
endelse

bad = where(map_out eq !values.f_nan, nbad)
if nbad gt 0 then map_out[bad] = bad_data

return,map_out
end
;_____________________________________________________________________
;
pro ud_grade, map_in, map_out, nside_out=nside_out, order_in=order_in, order_out=order_out, bad_data = bad_data
;+
; NAME:
;  ud_grade
;
; PURPOSE:
;  upgrade or degrade a full sky Healpix map
;  the data in the map is supposed to be intensive 
;  (doesn't scale with pixel area) just like temperature
;
; CATEGORY:
;  Healpix toolkit
;
; CALLING SEQUENCE:
;  ud_grade, map_in, map_out, [nside_out=, order_in=, order_out=, bad_data=]
;
; INPUTS:
;  map_in : either a fits file or a memory vector containing a Healpix
;           full sky map
;  map_out : reordered map
;        - if map_in is a FITS file, map_out should be a string containing the
;          name of the output file
;        - if map_in is a vector, map_out should be a variable
;
; KEYWORD PARAMETERS:
;   nside_out : output resolution parameter (can be larger or smaller than the
;        input one)
;        default : same as input (map unchanged)
;
;   order_in : input map ordering (either 'RING' or 'NESTED')
;        default : if map_in is a Healpix FITS file, use information in header
;                  if map_in is a vector, order_in has to be defined
;
;   order_out : output map ordering (either 'RING' or 'NESTED')
;        default : same as order_in
;
;   bad_data : flag value of missing pixel
;        default : -1.6375e30
;
; OUTPUTS:
;   none
;
; OPTIONAL OUTPUTS:
;   none
;
; COMMON BLOCKS:
;   none
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
;
; PROCEDURE:
;   reorder to NEST before up/degrading
;
; EXAMPLE:
;
;
;
; MODIFICATION HISTORY:
;    2000-01-08, Eric Hivon, Caltech
;
;-

if n_params() ne 2 then begin
    print,'syntax : ud_grade, map_in, map_out, '
    print,'  [nside_out=, order_in=, order_out=, bad_data=]'
    print
    return
endif

type_in  = datatype(map_in)
type_out = datatype(map_out)

if (type_in eq 'STR' and not (type_out eq 'STR' or type_out eq 'UND')) then begin
    print,'inconsistent type for map_in and map_out in ud_grade'
    print,'******** ABORT *********'
    return
endif

if (type_in ne 'STR' and type_out eq 'STR') then begin
    print,'inconsistent type for map_in and map_out in ud_grade'
    return
endif

if (type_in ne 'STR' and undefined(order_in)) then begin
    print,'the input ordering has to be defined for online input map'
    print,'******** ABORT *********'
    return
endif


;----------------
; file to file
;----------------
if type_in eq 'STR' then begin
    read_fits_s, map_in, prim, xten

    ncol = n_tags(xten)
    xhdr = xten.(0)
    map = xten.(1)
    xnames = tag_names(xten)

    order_in = sxpar(xhdr,'ORDERING')
    if undefined(order_out) then order_out = order_in
    ord_in  = strupcase(strmid(order_in,0,4))
    ord_out = strupcase(strmid(order_out,0,4))

    ; ----- full sky -----
    npix_in = n_elements(xten.(1))
    nside_in = npix2nside(npix_in,err=error)

    ; udgrade
    map = reorder(map,in=ord_in,out='NEST')
    map = sub_ud_grade(map, nside_in, nside_out, bad_data=bad_data)
    map = reorder(map,in='NEST',out=ord_out)

    ; update header
    sxaddpar,          xhdr,'NSIDE',nside_out
    add_ordering_fits, xhdr, ordering=order_out
    sxaddpar,          xhdr,'HISTORY','    PROCESSED BY UD_GRADE '
    if (nside_out ne nside_in) then sxaddpar,          xhdr,'HISTORY', $
      string('       NSIDE: ',nside_in,' -> ',nside_out,form='(a,i5,a,i5)')
    if (order_in ne order_out) then sxaddpar,          xhdr,'HISTORY', $
           '    ORDERING: '+strtrim(order_in,2)+' -> '+strtrim(order_out,2)

    ; write file
    xten=create_struct(xnames[0],xhdr,xnames[1],map)
    write_fits_sb, map_out, prim, xten


;------------------
; vector to vector
;------------------
endif else begin
    ; no output resolution : do nothing
    if undefined(nside_out) then begin
        map_out = map_in
        return
    endif
    ; find input resolution
    npix = n_elements(map_in)
    nside_in = npix2nside(npix,err=error)
    if (error eq 1) then begin
        print,'ud_grade : the input map is not a Healpix full sky map'
        print,npix,nside_in
        print,'******** ABORT *********'
        return
    endif

    if undefined(order_out) then order_out = order_in
    ord_in  = strupcase(strmid(order_in,0,4))
    ord_out = strupcase(strmid(order_out,0,4))

    map_out = reorder(map_in,in=ord_in,out='NEST')
    map_out = sub_ud_grade(map_out, nside_in, nside_out, bad_data=bad_data)
    map_out = reorder(map_out,in='NEST',out=ord_out)

endelse

return
end

