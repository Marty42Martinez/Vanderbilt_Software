pro gnom2out, planmap, Tmax, Tmin, color_bar, dx, title_display, sunits, coord_out, do_rot, eul_mat, $
              COLT=colt, CROP=crop, GIF = gif, GRATICULE = graticule, HXSIZE = hxsize, $
              NOBAR = nobar, NOLABELS = nolabels, PREVIEW = preview, PS = ps, $
              PXSIZE=pxsize, PYSIZE=pysize, ROT=rot_ang, SUBTITLE = subtitle, $
              TITLEPLOT = titleplot, XPOS = xpos, YPOS = ypos
;===============================================================================
;+
;  GNOM2OUT
;  ouputs on X-screen or PS file or GIF file a gnomonic map
;
;  IN:
;    planmap, Tmax, Tmin, color_bar, title_display, sunits, coord_out
;
;  KEYWORDS:
;     COLT=colt, GIF = gif, GRATICULE = graticule, HXSIZE = hxsize, do_rot, eul_mat, $
;              NOBAR = nobar, NOLABELS = nolabels, PREVIEW = preview, PS = ps, $
;              PXSIZE=pxsize, PYSIZE=pysize, ROT = rot_ang, SUBTITLE = subtitle, $
;              TITLEPLOT = titleplot, XPOS = xpos, YPOS = ypos
;
;   for more information, see Gnomview.pro
;
;   March 1999, EH
;-
;===============================================================================
xsize = (size(planmap))(1)
ysize = (size(planmap))(2)

;  ---- Gnomonic specific definitions for the plot ----
routine    = 'GNOMVIEW'
proj_small = 'gnomic'
proj_big   = 'Gnomic'

du_dv = 1.    ; aspect ratio
fudge = 1.00  ; 
; position of the rectangle in the final window
w_xll = 0.00 & w_xur = 1.00 & w_dx = w_xur - w_xll
w_yll = 0.10 & w_yur = 0.90 & w_dy = w_yur - w_yll
w_dx_dy = w_dx / w_dy ; 1.4
; color bar, position, dimension
cbar_dx = 1./3.
cbar_dy = 1./70.
cbar_xll = (1. - cbar_dx)/2.
cbar_xur = (1. + cbar_dx)/2.
cbar_yur = w_yll - cbar_dy
cbar_yll = cbar_yur - cbar_dy
; location of astro. coordinate
x_aspos = 0.5
y_aspos = 0.04
; location of title and subtitle
x_title = 0.5 & y_title = 0.95
x_subtl = 0.5 & y_subtl = 0.915

if defined(colt) then ct=colt else ct = 33

; -----------------------
; alter the color table
; -----------------------
print,'... computing the color table ...'
common colors, r,g,b,r_curr,g_curr,b_curr
LOADCT, ct , /SILENT
; set up some specific definitions
r(0) = 0   & g(0) = 0   & b(0) = 0 ; reserve for black
r(1) = 255 & g(1) = 255 & b(1) = 255 ; reserve for white
r(2) = 175 & g(2) = 175 & b(2) = 175 ; reserve for neutral grey
TVLCT,r,g,b


; ---------------------
; open the device
; ---------------------
print,'... here it is.'
titlewindow = proj_big+' projection : ' + title_display
back      = REPLICATE(BYTE(!P.BACKGROUND),xsize,ysize*cbar_dy*w_dx_dy)
if (keyword_set(ps)) then begin
    if DEFINED(hxsize) then hxsize = (hxsize > 3) < 200 else hxsize = 15
    if ((size(ps))(1) ne 7) then file_ps = 'plot_'+proj_small+'.ps' else file_ps = ps
    SET_plot,'ps'
    DEVICE, FILE=file_ps, /COLOR, BITS = 8 ; opens the file that will receive the PostScript plot
    DEVICE, /PORTRAIT, XSIZE=hxsize, YSIZE=hxsize/du_dv*w_dx_dy, XOFFSET=4, YOFFSET=2
    TVLCT,r,g,b
endif else begin
    DEVICE, PSEUDO = 8
    to_patch = ((!d.n_colors GT 256) and keyword_set(gif) and not keyword_set(crop))
    if (to_patch) then device, decomp = 1 else device, decomp = 0
    if (UNDEFINED(xpos) or UNDEFINED(ypos)) then $
      WINDOW, /FREE, XSIZE = xsize, YSIZE = ysize*w_dx_dy, TITLE = titlewindow $
    else $
      WINDOW, /FREE, XSIZE = xsize, YSIZE = ysize*w_dx_dy, TITLE = titlewindow, XP=xpos, YP=ypos
    TVLCT,r,g,b
endelse

; -------------------------------------------------------------
; make the plot
; -------------------------------------------------------------

;plot,/nodata,[-1,1]*du_dv*fudge,[-1,1]*fudge,pos=[w_xll,w_yll,w_xur,w_yur],XSTYLE=5,YSTYLE=5
xc = (xsize-1)/2.
yc = (ysize-1)/2.
xrange=dx*[-xc,xc] & yrange=dx*[-yc,yc]
plot,/nodata,xrange*fudge,yrange*fudge,pos=[w_xll,w_yll,w_xur,w_yur],XSTYLE=5,YSTYLE=5

; ---------- projection independent ------------------
; map itself
TV, planmap,w_xll,w_yll,/normal,xsize=1.

;  the color bar
if (not keyword_set(nobar)) then begin
    color_bar = BYTE(CONGRID(color_bar,xsize*cbar_dx)) # REPLICATE(1.,ysize*cbar_dy*w_dx_dy)
    back(xsize*cbar_xll,0) = color_bar
    TV, back,0,cbar_yll,/normal,xsize = 1.
endif

;  the color bar labels
if (not keyword_set(nobar) and not keyword_set(nolabels)) then begin
    format = '(e10.2)'
    if ((Tmax - Tmin) ge 50 and MAX(ABS([Tmax,Tmin])) le 1.e5) then format='(i8)'
    if ((Tmax - Tmin) ge 5  and MAX(ABS([Tmax,Tmin])) le 1.e2) then format='(f5.1)'
    strmin = STRING(Tmin,format=format)
    strmax = STRING(Tmax,format=format)
    XYOUTS, cbar_xll, cbar_yll,'!6'+STRTRIM(strmin,2)+' ',ALIGN=1.,/normal, chars=1.3 ; 1.0
    XYOUTS, cbar_xur, cbar_yll,'!6 '+STRTRIM(strmax,2)+' '+sunits,ALIGN=0.,/normal, chars=1.3
endif

;  the title
if (not keyword_set(titleplot)) then title= '!6'+title_display else title='!6'+titleplot
XYOUTS, x_title, y_title ,title, align=0.5, /normal, chars=1.6

;  the subtitle
if (keyword_set(subtitle)) then begin
    XYOUTS, x_subtl, y_subtl ,'!6 '+subtitle, align=0.5, /normal, chars=.84
endif

; ---------- projection dependent ------------------

;  astronomical position of central point
if (not keyword_set(nopos)) then begin
    if (undefined(rot_ang)) then rot_ang = [0.,0.,0.] else rot_ang = ([rot_ang,0,0])(0:2)
    rot_0 = STRTRIM(STRING(rot_ang(0),form='(f6.1)'),2)
    rot_1 = STRTRIM(STRING(rot_ang(1),form='(f6.1)'),2)
    XYOUTS,x_aspos,y_aspos,'('+rot_0+', '+rot_1+') '+decode_coord(coord_out),/normal,align=0.5
endif

;  the graticule
if (KEYWORD_SET(graticule)) then begin
    dlong = 5.                  ; degree
    dlat  = 5.                  ; degree
    if (n_elements(graticule) eq 2 and min(graticule) gt 0.) then begin
            dlong=graticule(0) & dlat = graticule(1)
    endif else begin
        if (datatype(graticule(0)) eq 'FLO' and graticule(0) gt 0.) then begin 
            dlong=graticule(0) & dlat=dlong
        endif
    endelse
    nmerid = fix(181./dlong)
    nparal = fix(90./dlat)-1
    vector = FINDGEN(181)/180.
    FOR i=-nmerid,nmerid-1 DO begin
        ang2vec, vector*!pi, replicate(i*dlong*!DtoR,n_elements(vector)), vv
        if (do_rot) then vv = vv # transpose(eul_mat)
        k = where(vv(*,0) gt 0, nk)
        if (nk gt 0) then begin
            u = -vv(k,1)/vv(k,0)
            v = vv(k,2)/vv(k,0)
            OPLOT,u,v,COLOR = !P.COLOR  ; meridians
        endif
    endfor
    FOR i=-nparal,nparal DO begin
        ang2vec, replicate((90.-i*dlat)*!DtoR,n_elements(vector)), vector*2*!pi, vv
        if (do_rot) then vv = vv # transpose(eul_mat)
        k = where(vv(*,0) gt 0, nk)
        if (nk gt 0) then begin
            u = -vv(k,1)/vv(k,0)
            v = vv(k,2)/vv(k,0)
            OPLOT,u,v,COLOR = !P.COLOR  ; parallels
        endif
    endfor
endif 

; -----------------------------------------------
;       output the PS/GIF
; -----------------------------------------------

;  gif output
if keyword_set(gif) then begin 
    if (DATATYPE(gif) ne 'STR') then file_gif = 'plot_'+proj_small+'.gif' else file_gif = gif
    if keyword_set(crop) then begin
        write_gif,file_gif,planmap,r,g,b
    endif else begin
        write_gif,file_gif,tvrd(),r,g,b
        if (to_patch) then begin 
            device,decomp=0 ; put back colors on X window
            tv,tvrd()
        endif
    endelse
    print,'GIF file is in '+file_gif
    if (keyword_set(preview)) then spawn, 'xv '+file_gif+' & '
endif

if (keyword_set(ps)) then begin
    device,/close
    set_plot,'x'
    print,'PS file is in '+file_ps
    if (keyword_set(preview)) then spawn, 'ghostview '+file_ps+' & '
endif

return
end
