

PRO multi_plot,nx,ny,pos=pos,scale=scale,margin=margin

IF  N_ELEMENTS(scale) EQ 0 THEN scale = 0.95

nplots = nx * ny

dx     = 1.0/FLOAT(nx)
dy     = 1.0/FLOAT(ny)

IF N_ELEMENTS(margin) EQ 0THEN BEGIN
    rel_margin = [dx,dy,dx,dy] * (1.0 - scale) / 2.0
ENDIF ELSE BEGIN
    rel_margin = [dx,dy,dx,dy] * margin
ENDELSE

; get x0, y0, x1,y0 outer bounds for each plot area.....
x0 = FINDGEN(nx)    # (FLTARR(ny)+1) * dx
y0 = (FLTARR(nx)+1) #  FINDGEN(ny)   * dy
x1 = x0 + dx 
y1 = y0 + dy 

; NOW switch y0 and y1 so that output is ordered the 
; same way as !P.multi plots...i.e. upper left plot is index 0
dum = y0
y0  = 1.0 - y1
y1  = 1.0 - dum

; now substract margins that were specified above. 
x0 = x0 + rel_margin[0]
y0 = y0 + rel_margin[1]
x1 = x1 - rel_margin[2]
y1 = y1 - rel_margin[3]


; ASSIGN THE POSITION OF PLOTS TO OUTPUT VECTOR pos
pos      = FLTARR(4,nplots)
pos[0,*] = REFORM(x0,nx*ny)
pos[1,*] = REFORM(y0,nx*ny)
pos[2,*] = REFORM(x1,nx*ny)
pos[3,*] = REFORM(y1,nx*ny)


END
