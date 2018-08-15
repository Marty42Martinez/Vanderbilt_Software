function reorder, map_in, in=in, out= out
;+
; NAME:
;   reorder
;
; PURPOSE:
;   change the ordering of a full sky Healpix map from Nested/Ring to
;   Ring/Nested
; CATEGORY:
;   Healpix pixel toolkit
;
; CALLING SEQUENCE:
;   map_out = reorder(map_in, in=in, out=out)
;
; INPUTS:
;   map_in : a full sky Healpix map, can of any type 
;  (float, integer, double)
;
; OPTIONAL INPUTS:
;   none
;
; KEYWORD PARAMETERS:
;   in- is either 'RING' or 'NESTED'
;   out- is either 'RING' or 'NESTED'
;
; OUTPUTS:
;   map_out : a reordered full sky Healpix map,
;   same size and same type of map_in
;
; OPTIONAL OUTPUTS:
;   none
;
; COMMON BLOCKS:
;   none
;
; SIDE EFFECTS:
;   none
;
; RESTRICTIONS:
;   none
;
; PROCEDURE:
;
; EXAMPLE:
;   map_nest = reorder(map_ring,in='ring',out='nest')
;
; MODIFICATION HISTORY:
;    April 1999, EH, Caltech
;    Jan   2000, EH,  improved documentation header 
;-

 if N_params() ne 1 or undefined(in) or undefined(out) then begin
     print,' map_out = reorder(map_in, In=in, Out=out)'
     return,0
 endif

 kin  = strmid(strupcase(strtrim(in ,2)),0,4)
 kout = strmid(strupcase(strtrim(out,2)),0,4)

 if (kin ne 'RING' and kin ne 'NEST') then begin
     print,' In has to be either ''RING'' or ''NESTED'' '
     print,' map_out = reorder(map_in, In=in, Out=out)'
     return,0
 endif

 if (kout ne 'RING' and kout ne 'NEST') then begin
     print,' Out has to be either ''RING'' or ''NESTED'' '
     print,' map_out = reorder(map_in, In=in, Out=out)'
     return,0
 endif

 if (kin eq kout) then return, map_in

 np = n_elements(map_in)
 nside = npix2nside(np,err=err)

 if (err ne 0) then begin
     print,' map_in should be a full sky Healpix map'
     print,' pixel #  = ',np
     return,0
 endif

 npf = np/12
 map_out = make_array(np, type=datatype(map_in,2))
 if (kin eq 'RING') then begin  ; ring -> nest
     for j=0L, 11 do begin
         ipn = lindgen(npf) + j*npf
         nest2ring, nside, ipn, ipr
         map_out(ipn) = map_in(ipr)
     endfor
 endif
 if (kin eq 'NEST') then begin  ; nest -> ring
     for j=0L, 11 do begin
         ipn = lindgen(npf) + j*npf
         nest2ring, nside, ipn, ipr
         map_out(ipr) = map_in(ipn)
     endfor
 endif


return, map_out
end

