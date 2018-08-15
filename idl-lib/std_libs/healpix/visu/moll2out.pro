pro moll2out, planmap, Tmax, Tmin, color_bar, title_display, sunits, $
              COLT=colt, CROP=crop, GIF = gif, GRATICULE = graticule, $
              HXSIZE=hxsize, NOBAR = nobar, NOLABELS = nolabels, PREVIEW = preview, $
              PS=ps, PXSIZE=pxsize, SUBTITLE = subtitle, $
              TITLEPLOT = titleplot, XPOS = xpos, YPOS = ypos
;===============================================================================
;+
;  MOLL2OUT
;  ouputs on X-screen or PS file or GIF file a mollweide map
;
;  IN:
;    planmap, Tmax, Tmin, color_bar, title_display, sunits
;
;  KEYWORDS:
;     COLT=colt, CROP=crop, GIF = gif, GRATICULE = graticule, HXSIZE = hxsize, $
;              NOBAR = nobar, NOLABELS = nolabels, PREVIEW = preview, PS = ps, $
;              PXSIZE=pxsize, PYSIZE=pysize, SUBTITLE = subtitle, $
;              TITLEPLOT = titleplot, XPOS = xpos, YPOS = ypos
;
;   for more information, see Gnomview.pro
;
;   March 1999, EH
;-
;===============================================================================
; offset along the long axis of the page
;yoffset = 2  ; Europe (A4)
yoffset = 1  ; US (letter)

;-------------------------------------------------

xsize = (size(planmap))(1)
ysize = (size(planmap))(2)

;  ---- Mollweide specific definitions for the plot ----
proj_big = 'Mollweide'
proj_small = 'mollweide'

du_dv = 2.    ; aspect ratio
fudge = 1.02  ; spare some space around the Mollweide egg
; position of the egg in the final window
w_xll = 0.0 & w_xur = 1.0 & w_dx = w_xur - w_xll
w_yll = 0.1 & w_yur = 0.9 & w_dy = w_yur - w_yll
w_dx_dy = w_dx / w_dy ; 1./.8
; color bar, position, dimension
cbar_dx = 1./3.
cbar_dy = 1./70.
cbar_xll = (1. - cbar_dx)/2.
cbar_xur = (1. + cbar_dx)/2.
cbar_yur = w_yll - cbar_dy
cbar_yll = cbar_yur - cbar_dy
; location of title and subtitle
x_title = 0.5 & y_title = 0.95
x_subtl = 0.5 & y_subtl = 0.905

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
    if DEFINED(hxsize) then hxsize = (hxsize > 3) < 200 else hxsize = 26
    if ((size(ps))(1) ne 7) then file_ps = 'plot_'+proj_small+'.ps' else file_ps = ps
    SET_plot,'ps'
    DEVICE, FILE=file_ps, /COLOR, BITS = 8 ; opens the file that will receive the PostScript plot
    DEVICE, /LANDSCAPE, XSIZE=hxsize, YSIZE=hxsize/du_dv*w_dx_dy, XOFFSET=4, YOFFSET=hxsize+yoffset
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
; makes the plot
; -------------------------------------------------------------

; ---------- projection independent ------------------
plot,/nodata,[-1,1]*du_dv*fudge,[-1,1]*fudge,pos=[w_xll,w_yll,w_xur,w_yur],XSTYLE=5,YSTYLE=5

;  the map itself
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
    XYOUTS, cbar_xll, cbar_yll,'!6'+STRTRIM(strmin,2)+' ',ALIGN=1.,/normal, chars=1.3
    XYOUTS, cbar_xur, cbar_yll,'!6 '+STRTRIM(strmax,2)+' '+sunits,ALIGN=0.,/normal, chars=1.3
endif

;  the title
if (not keyword_set(titleplot)) then title= '!6 '+title_display else title='!6 '+titleplot
XYOUTS, x_title, y_title ,title, align=0.5, /normal, chars=1.6

;  the subtitle
if (keyword_set(subtitle)) then begin
    XYOUTS, x_subtl, y_subtl ,'!6 '+subtitle, align=0.5, /normal, chars=.84
endif

; ---------- projection dependent ------------------

;  the graticule
if (KEYWORD_SET(graticule)) then begin
    dlong = 45.                  ; degree
    dlat  = 45.                  ; degree
    if (n_elements(graticule) eq 2 ) then begin
        if (graticule(0) gt 10 and graticule(1) gt 10) then begin
            dlong=float(graticule(0)) & dlat = float(graticule(1))
        endif
    endif else begin
        if (graticule(0) gt 10) then begin
            dlong=float(graticule(0)) & dlat=dlong
        endif
    endelse
    nmerid = fix(181./dlong)
    nparal = fix(90./dlat)-1
    vector = FINDGEN(181)/180.
    v = vector*2. - 1.
    u = SQRT(1.-v*v)
    bb = ASIN( 2./ !PI * (ASIN(vector) + vector*SQRT(1.-vector^2)) ) * !RaDeg ; degree
    v1 = (INTERPOL(vector,bb,findgen(nparal+1)*dlat))
    FOR i=-nmerid,nmerid DO PLOTS,u*(i*dlong/90.),v,COLOR = !P.COLOR ; meridians
    FOR i=-nparal,nparal DO begin
        v1i = v1(abs(i))
        if (i lt 0) then v1i = -abs(v1i)
        PLOTS,(vector*4.-2.)*SQRT(1.-v1i^2),replicate(v1i,n_elements(vector)),COLOR = !P.COLOR ; parallels
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
    set_plot,'win'
    print,'PS file is in '+file_ps
    if (keyword_set(preview)) then spawn, 'ghostview '+file_ps+' & '
endif

RETURN
END









