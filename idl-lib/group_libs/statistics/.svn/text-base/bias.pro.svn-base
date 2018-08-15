FUNCTION bias,x,y
 b=0.0
 i=0L
 WHILE (i LT n_elements(x)) DO BEGIN
   b=b+float(x(i)-y(i))
   i=i+1L
 ENDWHILE
 b=b/float(N_ELEMENTS(x)) 
 return,b
END
