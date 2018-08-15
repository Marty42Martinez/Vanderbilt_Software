pro gnom2pix, xpos, ypos, id_pix, lon_deg, lat_deg
;+
; convert a uv position on a Gnomic map into a pixel number and
; (long, lat)
; only for scalar input
;
;-

@gnomcom ; define common

id_pix  = -1
lon_deg = -1000.
lat_deg = -1000.

if (xpos ge !x.crange(0) and xpos le !x.crange(1) and ypos ge !y.crange(0) and ypos le !y.crange(1)) then begin
vector = [1., -xpos, ypos] ; minus sign = astro convention
if (do_rot) then vector = vector # eul_mat
vector1 = vector
vec2ang, vector1, lat_deg, lon_deg, /astro
if (do_conv) then vector = SKYCONV(vector, inco = coord_out, outco =  coord_in)
          ; we go from the final Gnomonic map (system coord_out) to
          ; the original one (system coord_in)
    ; -------------------------------------------------------------
    ; converts the position on the sphere into pixel number
    ; and project the corresponding data value on the map
    ; -------------------------------------------------------------
case pix_type of
    'R' : VEC2PIX_RING, pix_param, vector, id_pix ; Healpix ring
    'N' : VEC2PIX_NEST, pix_param, vector, id_pix ; Healpix nest
    'Q' : id_pix = UV2PIX(vector, pix_param) ; QuadCube (COBE cgis software)
    else : print,'error on pix_type'
endcase
if (n_elements(xpos) eq 1) then id_pix = id_pix(0)
endif


return
end

