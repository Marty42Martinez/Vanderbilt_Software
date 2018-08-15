
FUNCTION tvrd_and_invert

a      = TVRD(TRUE=1)
r=a[0,*,*]
g=a[1,*,*]
b=a[2,*,*]
ind0   = WHERE(r EQ   0 AND g EQ   0 AND b EQ   0)
ind255 = WHERE(r EQ 255 AND g EQ 255 AND b EQ 255)
IF ind0  [0] NE -1 THEN BEGIN
    r[ind0]=255B
    g[ind0]=255B
    b[ind0]=255B
ENDIF    
IF ind255[0] NE -1 THEN BEGIN
    r[ind255]=0B
    g[ind255]=0B
    b[ind255]=0B
ENDIF 

a[0,*,*]=r
a[1,*,*]=g
a[2,*,*]=b


RETURN,a

END   
