pro data2moll, data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, $
               planmap, Tmax, Tmin, color_bar, $
               PXSIZE=pxsize, LOG=log, HIST_EQUAL=hist_equal, MAX=max_set, MIN=min_set, FLIP=flip,$
               NO_DIPOLE=no_dipole, NO_MONOPOLE=no_monopole, UNITS = units, DATA_PLOT = data_plot, $
               GAL_CUT=gal_cut
;+
;==============================================================================================
;     DATA2MOLL
;
;     turns a Healpix or Quad-cube map into in Mollweide egg
;
;     DATA2MOLL,  data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat
;          planmap, Tmax, Tmin, color_bar
;          pxsize=, log=, hist_equal=, max=, min=
;
; IN :
;      data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat
; OUT :
;      planmap, Tmax, Tmin, color_bar
; KEYWORDS
;      pxsize, log, hist_equal, max, min, flip, no_dipole, units
;
;  called by mollview
;==============================================================================================
;-

du_dv = 2.    ; aspect ratio
fudge = 1.02  ; spare some space around the Mollweide egg
if keyword_set(flip) then flipconv=1 else flipconv = -1  ; longitude increase leftward by default (astro convention)


!P.BACKGROUND = 1               ; white background
!P.COLOR = 0                    ; black foreground

mode_col = keyword_set(hist_equal)
mode_col = mode_col + 2*keyword_set(log)

npix = N_ELEMENTS(data)

bad_data= -1.63750000e+30

;-----------------------------------
; mask out some data
;-----------------------------------
;--------------------------------------
; remove monopole and/or dipole
;----------------------------------------
if undefined(gal_cut) then bcut = 0. else bcut = abs(gal_cut)
if keyword_set(no_dipole) then remove_dipole, data, $
 nside=pix_param, ordering=pix_type, units=units, coord_in = coord_in, coord_out=coord_out, bad_data=bad_data, gal_cut=bcut
if keyword_set(no_monopole) then remove_dipole, data, $
 nside=pix_param, ordering=pix_type, units=units, coord_in = coord_in, coord_out=coord_out, bad_data=bad_data, gal_cut=bcut,/only
; -------------------------------------------------------------
; create the rectangular window
; -------------------------------------------------------------
if DEFINED(pxsize) then xsize= LONG(pxsize>200) else xsize = 800L
ysize = xsize/2L
n_uv = xsize*ysize
small_file = (n_uv GT npix)

if (small_file) then begin
    ; file smaller than final map, make costly operation on the file
    ; initial data is destroyed and replaced by color
    mindata = MIN(data,MAX=maxdata)
    IF( mindata LE (bad_data*.9) ) THEN BEGIN
        Obs    = WHERE( data GT (bad_data*.9), N_Obs )
        mindata = MIN(data(Obs))
    ENDIF ELSE begin 
        if (keyword_set(log) or keyword_set(hist_equal)) then Obs = LINDGEN(NPix)
    ENDELSE
    data_plot = data
    data = COLOR_MAP(data, mindata, maxdata, Obs, $
        color_bar = color_bar, mode=mode_col, minset = min_set, maxset = max_set )
    Obs = 0
    Tmin = mindata & Tmax = maxdata
    planmap = MAKE_ARRAY(/BYTE,xsize,ysize, Value = !P.BACKGROUND) ; white
endif else begin
    planmap = MAKE_ARRAY(/FLOAT,xsize,ysize, Value = bad_data) 
    plan_off = 0L
endelse

; -------------------------------------------------
; make the projection
;  we split the projection to avoid dealing with to big an array
; -------------------------------------------------
print,'... making the projection ...'
; -------------------------------------------------
; generate the (u,v) position on the mollweide map
; -------------------------------------------------
xll= 0 & xur =  xsize-1
yll= 0 & yur =  ysize-1
xc = 0.5*(xll+xur) & dx = (xur - xc)
yc = 0.5*(yll+yur) & dy = (yur - yc)

yband = LONG(5.e5 / FLOAT(xsize))
for ystart = 0, ysize - 1, yband do begin 
    yend   = (ystart + yband - 1) < (ysize - 1)
    nband = yend - ystart + 1
    u = FINDGEN(xsize)     # REPLICATE(1,nband)
    v = REPLICATE(1,xsize) # (FINDGEN(nband) + ystart)
    u =  du_dv*(u - xc)/(dx/fudge)   ; in [-2,2]*fudge
    v =        (v - yc)/(dy/fudge)   ; in [-1,1] * fudge

    ; -------------------------------------------------------------
    ; for each point on the mollweide map 
    ; looks for the corresponding position vector on the sphere
    ; -------------------------------------------------------------
    ellipse  = WHERE( (u^2/4. + v^2) LE 1. , nellipse)
    if (NOT small_file) then begin
        off_ellipse = WHERE( (u^2/4. + v^2) GT 1. , noff_ell)
        if (noff_ell NE 0) then plan_off = [plan_off, ystart*xsize+off_ellipse]
    endif
    if (nellipse gt 0) then begin
        u1 =  u(ellipse)
        v1 =  v(ellipse)
        u = 0 & v = 0
        s1 =  SQRT( (1-v1)*(1+v1) )
        a1 =  ASIN(v1)

        z = 2./!PI * ( a1 + v1*s1)
        phi = (flipconv *!Pi/2.) * u1/s1 ; lon in [-pi,pi], the minus sign is here to fit astro convention
        sz = SQRT( (1. - z)*(1. + z) )
        vector = [[sz * COS(phi)], [sz * SIN(phi)], [z]]
        u1 = 0 & v1 = 0 & s1 = 0 & a1 = 0 & z = 0 & phi = 0 & sz = 0
        ; ---------
        ; rotation
        ; ---------
        if (do_rot) then vector = vector # eul_mat
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
        planmap(ystart*xsize+ellipse) = data(id_pix)
    endif
    ellipse = 0 & id_pix = 0
endfor

if (small_file) then begin
    data = 0
endif else begin
; file larger than final map, make
; costly operation on the Mollweide map
    data_plot = temporary(data)
    Obs    = WHERE(planmap GT (bad_data*.9), N_Obs )
    mindata = MIN(planmap(Obs),MAX=maxdata)
    planmap = COLOR_MAP(planmap, mindata, maxdata, Obs, $
            color_bar = color_bar, mode=mode_col, minset = min_set, maxset = max_set )
    planmap(plan_off) = !P.BACKGROUND ; white
    Obs = 0 & plan_off = 0
    Tmin = mindata & Tmax = maxdata
endelse


return
end

