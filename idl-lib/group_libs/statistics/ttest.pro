FUNCTION ttest,x,y,yfit,slope,exvar=exvar

  n   = FLOAT(N_ELEMENTS(x))
  sse = TOTAL((y-yfit)^2.0)
  xxx = TOTAL((x-MEAN(x))^2.0)
  
  tscore = slope*SQRT(n-2)/SQRT(sse/xxx)
  tscore = tscore[0]
  
  t = FINDGEN(100)*0.01
  p = t
  FOR i=0,99 DO p[i]=t_cvf(t[i]/2.0,n-2)
  
  ind=MAX(WHERE(p GT ABS(tscore)))
  
  exvar = 100.0-TOTAL((y-yfit)^2.)/TOTAL((y-MEAN(y))^2.0)*100.

  RETURN,[tscore,1-t[ind],exvar]
  
END
