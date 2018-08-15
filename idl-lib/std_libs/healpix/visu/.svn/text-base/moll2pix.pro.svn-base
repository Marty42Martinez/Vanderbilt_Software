pro moll2pix, xpos, ypos, id_pix, lon_deg, lat_deg
;+
; convert a uv position on a Mollweide map into a pixel number and
; (long, lat)
; only for scalar input
;
;-

@mollcom ; define common

if (do_flip) then flipconv = +1 else flipconv = -1 ; longitude increase leftward by default (astro convention)
id_pix  = -1
lon_deg = -1000.
lat_deg = -1000.
if (xpos^2 / 4. + ypos^2 le 1.) then begin

    nested = keyword_set(nest)
    v1 = ypos
    u1 = xpos
    s1 = SQRT((1.d0 - v1)*(1.d0 + v1))
    a1 = ASIN( v1 )

        z = 2./!PI * ( a1 + v1*s1)
        phi = (flipconv*!Pi/2.) * u1/s1 ; lon in [-pi,pi], the minus sign is here to fit astro convention
        sz = SQRT( (1. - z)*(1. + z) )
        vector = [[sz * COS(phi)], [sz * SIN(phi)], [z]]
        ; ---------
        ; rotation
        ; ---------
        if (do_rot) then vector = vector # eul_mat
        vector1 = vector
        vec2ang, vector1, lat_deg, lon_deg, /astro
        if (do_conv) then vector = SKYCONV(vector, inco = coord_out, outco =  coord_in)
                                ; we go from the final Mollweide map (system coord_out) to
                                ; the original one (system coord_in)
        ; -------------------------------------------------------------
        ; converts the position on the sphere into pixel number
        ; and project the corresponding data value on the map
        ; -------------------------------------------------------------
        case pix_type of
            'R' : VEC2PIX_RING, pix_param, vector, id_pix ; Healpix ring
            'N' : VEC2PIX_NEST, pix_param, vector, id_pix ; Healpix nest
            'Q' : id_pix = UV2PIX(vector, pix_param)    ; QuadCube (COBE cgis software)
            else : print,'error on pix_type'
        endcase
    if (n_elements(xpos) eq 1) then id_pix = id_pix(0)
endif

return
end
