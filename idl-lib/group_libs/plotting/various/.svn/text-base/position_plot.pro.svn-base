PRO position_plot,position=position, $
				  scale=scale, $
				  margin=margin
  
curbox,x0,x1,y0,y1

IF NOT(KEYWORD_SET(scale)) THEN scale = 0.95

dx = x1 - x0
dy = y1 - y0

IF NOT(KEYWORD_SET(margin)) THEN BEGIN
    rel_margin = [dx,dy,dx,dy] * (1.0 - scale) / 2.0
ENDIF ELSE BEGIN
    rel_margin = [dx,dy,dx,dy] * margin
ENDELSE

; now substract margins that were specified above. 
x0 = x0 + rel_margin[0]
y0 = y0 + rel_margin[1]
x1 = x1 - rel_margin[2]
y1 = y1 - rel_margin[3]

position=[x0,y0,x1,y1]

END
