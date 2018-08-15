pro add_ordering_fits,info_header, nested=nested, ring=ring, ordering=ordering,error=error
;+
; add_ordering_fits
;
; add_ordering_fits,info_header, nested=, ring=, ordering=,error=
;
;  adds the ORDERING keyword defined by 'nested' or 'ring' or 'ordering' in
;  the fits header 'info_header'
;  it also adds the card PIXTYPE = 'HEALPIX'
;
;  EH April 1999
;-

error=0
; info_header present and not empty
header_flag = 0
if (n_params() eq 1) then begin
    if info_header(0) ne ' ' then header_flag=1
endif
; ordering given in the header
order_flag = 0
if (header_flag) then order_fits = strtrim(sxpar(info_header,'ORDERING',count=order_flag),2)
; user defined ordering
ring_set = keyword_set(ring)
nest_set = keyword_set(nested)
if defined(ordering) then begin
    case strmid(strupcase(strtrim(ordering,2)),0,4) of
        'RING' : ring_set = 1
        'NEST' : nest_set = 1
        else : begin
            print,'ordering has to be either ''RING'' or ''NESTED'' '
            error = 1
            return
        end
    endcase
endif
; conflict
if (ring_set*nest_set eq 1 or (order_flag+ring_set+nest_set) eq 0) then begin
    print,' Choose either RING or NESTED in write_fits_map'
    print,' ******* File not written ********'
    error=1
    return
endif

if (ring_set) then ordering='RING'
if (nest_set) then ordering='NESTED'
if (header_flag eq 0) then info_header = strarr(1) ; no header, open one

sxaddpar,info_header,'PIXTYPE','HEALPIX ',' HEALPIX pixelisation '
if (order_flag eq 0) then begin ; no Ordering in the header, define it
    sxaddpar,info_header,'ORDERING',ordering,' Pixel ordering scheme, either RING or NESTED'
endif else begin ; one ordering in the header, change it if necessary
    if undefined(ordering) then ordering = order_fits
    if (order_fits ne ordering) then begin
        print,' value of ORDERING changed from '+order_fits+' to '+ordering
        sxaddpar,info_header,'ORDERING',ordering
    endif
endelse


return
end

;--------------------------------
