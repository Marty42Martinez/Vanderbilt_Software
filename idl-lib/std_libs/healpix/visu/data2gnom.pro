pro data2gnom, data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, $
               color, Tmax, Tmin, color_bar, dx, $
               PXSIZE=pxsize, PYSIZE=pysize, ROT=rot_ang, LOG=log, HIST_EQUAL=hist_equal, $
               MAX=max_set, MIN=min_set, $
               RESO_ARCMIN=reso_arcmin, FITS = fits
;+
;==============================================================================================
;     DATA2GNOM
;
;     turns a Healpix or Quad-cube map into in Gnomonic rectangular map
;
;     DATA2GNOM,  data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat
;          color, Tmax, Tmin, color_bar
;          pxsize=, pysize=, rot=, log=, hist_equal=, max=, min=,
;          reso_arcmin=, fits=
;
; IN :
;      data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat
; OUT :
;      color, Tmax, Tmin, color_bar, dx
; KEYWORDS
;      Pxsize, Pysize, Rot, Log, Hist_equal, Max, Min, Reso_arcmin, Fits
;
;  called by gnomview
;==============================================================================================
;-

proj_small = 'gnomic'
du_dv = 1.    ; aspect ratio
fudge = 1.00  ; 

!P.BACKGROUND = 1               ; white background
!P.COLOR = 0                    ; black foreground

mode_col = keyword_set(hist_equal)
mode_col = mode_col + 2*keyword_set(log)

npix = N_ELEMENTS(data)

bad_data= -1.63750000e+30

; -------------------------------------------------------------
; create the rectangular window
; -------------------------------------------------------------
if defined(pxsize) then xsize = pxsize*1L else xsize = 500L
if defined(pysize) then ysize = pysize*1L else ysize = xsize
if defined(reso_arcmin) then resgrid = reso_arcmin/60. else resgrid = 1.5/60.
dx      = resgrid * !DtoR
N_uv = xsize*ysize

print,'Input map  :  ',3600.*6./sqrt(!pi*npix),' arcmin / pixel ',form='(a,f8.3,a)'
print,'gnomonic map :',resgrid*60.,' arcmin / pixel ',xsize,'*',ysize,form='(a,f8.3,a,i4,a,i4)'

grid = FLTARR(xsize,ysize)
; -------------------------------------------------------------
; makes the projection around the chosen contact point
; -------------------------------------------------------------
; position on the planar grid  (1,u,v)
x0 = +1.
xll= 0 & xur =  xsize-1
yll= 0 & yur =  ysize-1
xc = 0.5*(xll+xur) & deltax = (xur - xc)
yc = 0.5*(yll+yur) & deltay = (yur - yc)

yband = LONG(5.e5 / FLOAT(xsize))
for ystart = 0, ysize - 1, yband do begin 
    yend   = (ystart + yband - 1) < (ysize - 1)
    nband = yend - ystart + 1
    npb = xsize * nband
    u = - (FINDGEN(xsize) - xc)# REPLICATE(dx,nband)   ; minus sign = astro convention
    v =    REPLICATE(dx,xsize) # (FINDGEN(nband) + ystart - yc)
    x = replicate(x0, npb)
    vector = [[x],[reform(u,npb,/over)],[reform(v,npb,/over)]] 
    ; non normalised vector
    if (do_rot) then vector = vector # eul_mat
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
    grid(ystart*xsize) = data(id_pix)
endfor
u = 0 & v = 0 & x = 0 & vector = 0

; -------------------------------------------------------------
; Test for unobserved pixels
; -------------------------------------------------------------
mindata = MIN(grid,MAX=maxdata)
IF( mindata LE (bad_data*.9) ) THEN BEGIN
    Obs    = WHERE( grid GT (bad_data*.9), N_Obs )
    if (N_Obs gt 0) then mindata = MIN(grid(Obs))
ENDIF ELSE begin 
    if (keyword_set(log) or keyword_set(hist_equal)) then Obs = LINDGEN(N_uv)
ENDELSE

;-----------------------------------
; export in fits the original gnomic map before alteration
;-----------------------------------

if keyword_set(fits) then begin 
    if (rot_ang(2) NE 0.) then begin 
        print,'can NOT export gnomic FITS file'
        print,'set Rot = [lon0, lat0, 0.0]'
        goto,skip_fits
    endif
    if (DATATYPE(fits) ne 'STR') then file_fits = 'plot_'+proj_small+'.fits' else file_fits = fits
    gnom2fits, grid, file_fits, rot = rot_ang, coord=coord_out, reso = resgrid*60., unit = sunits, min=mindata, max = maxdata
    print,'FITS file is in '+file_fits
    skip_fits:
endif

; -------------------------------------------------------------
; set min and max and computes the color scaling
; -------------------------------------------------------------
color = COLOR_MAP(grid, mindata, maxdata, Obs, $
         color_bar = color_bar, mode=mode_col, minset = min_set, maxset = max_set )
Obs = 0
grid = 0
Tmin = mindata & Tmax = maxdata

return
end

