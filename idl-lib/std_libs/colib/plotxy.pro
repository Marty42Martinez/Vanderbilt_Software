PRO plotxy, x1,y1,x2,y2, _extra=_extra

n1 = n_elements(x1)
y2out = y1
for i=0,n1-1 do y2out[i] = y2[findclosest(x1[i],x2)]
plot, y1, y2out, _extra=_extra

END