PRO dline,slope=slope,offset=offset,_EXTRA=_EXTRA

IF NOT(KEYWORD_SET(slope )) THEN slope  = 1.0
IF NOT(KEYWORD_SET(offset)) THEN offset = 0.0

xr=!x.crange
yr=!y.crange

; linear axes
x0=MIN([xr[0],yr[0]])
x1=MAX([xr[1],yr[1]])
x = [x0,x1]

; one or both axes logarithmic
IF !x.type EQ 1 or !Y.type EQ 1 THEN BEGIN
   IF !x.type EQ 1 THEN xr = 10^xr
   IF !y.type EQ 1 THEN yr = 10^yr
   x0=MIN([xr[0],yr[0]])
   x1=MAX([xr[1],yr[1]])
   x = rp_vector(x0,x1,100)
ENDIF

oplot,x,offset + slope * x,_EXTRA=_EXTRA

END
