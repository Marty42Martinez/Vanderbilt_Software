
PRO time_series::plot,     XRANGE=XRANGE,XSTYLE=XSTYLE,XTICKV=XTICKV,XTICKS=XTICKS, $
                           YRANGE=YRANGE,YSTYLE=YSTYLE,TITLE=TITLE,OPLOT=OPLOT,COLOR=COLOR,         $
                           mcolor=mcolor,scolor=scolor,mthick=mthick,sthick=sthick,                 $
                           mean_line=mean_line,stdv_line=stdv_line,_EXTRA=_EXTRA,                   $
                           PSYM=PSYM,SYMSIZE=SYMSIZE,normalize=normalize,dat=dat,count=count,sort=sort,anomaly=anomaly

  KEYWORD_DEFAULT, XRANGE, [JULDAY(1,1,1985),JULDAY(12,31,2009)]
  KEYWORD_DEFAULT, XTICKV, JULDAY(1,1,1985+FINDGEN(5)*5)
  KEYWORD_DEFAULT, XTICKS, 4
  KEYWORD_DEFAULT, XSTYLE, 1
  KEYWORD_DEFAULT, YSTYLE, 1

  KEYWORD_DEFAULT, COLOR, 255-!P.BACKGROUND
  KEYWORD_DEFAULT, PSYM    , -1
  KEYWORD_DEFAULT, SYMSIZE , 0.2
  
  KEYWORD_DEFAULT,mcolor,255-!P.BACKGROUND
  KEYWORD_DEFAULT,mthick,1
  KEYWORD_DEFAULT,scolor,255-!P.BACKGROUND
  KEYWORD_DEFAULT,sthick,1
						   
  dat = self->get(count=count,sort=sort,anomaly=anomaly)
  x   = dat.jul
  y   = dat.dat
  dat = { jul : x, dat : y}
  
  ind = WHERE(y GT -900.,cnt)
  IF cnt LT 2 theN BEGIN
   print,'less than 2 points in time series'
   print,'returning'
   RETURN
  END 
  
  IF KEYWORD_SET(normalize) THEN BEGIN
    y[ind] =(y[ind]-MEAN(y[ind]))/STDDEV(y[ind])
  ENDIF

  res=LABEL_DATE(DATE_F='%M/%Z')

  IF NOT(KEYWORD_SET(OPLOT)) THEN BEGIN
	 PLOT,x[ind],y[ind], $
    	  XRANGE=XRANGE,XSTYLE=XSTYLE,XTICKV=XTICKV,XTICKS=XTICKS,XTICKFORMAT='LABEL_DATE', $ 
                                	 YRANGE=YRANGE,YSTYLE=YSTYLE,   $
                                	 /NODATA ,TITLE=TITLE,_EXTRA=_EXTRA
  ENDIF
  
;  PLOTS,x[ind],y[ind],/DATA,PSYM=PSYM,SYMSIZE=SYMSIZE,COLOR=COLOR,CLIP=!P.CLIP,NOCLIP=0
  OPLOT,x[ind],y[ind],PSYM=PSYM,SYMSIZE=SYMSIZE,COLOR=COLOR

  IF KEYWORD_SET(mean_line) THEN HLINE,MEAN(y[ind]),COLOR=mcolor,THICK=MTHICK
  IF KEYWORD_SET(stdv_line) THEN BEGIN
     HLINE,MEAN(y[ind])+STDDEV(y[ind]),COLOR=scolor,THICK=sTHICK
     HLINE,MEAN(y[ind])-STDDEV(y[ind]),COLOR=scolor,THICK=sTHICK
  ENDIF    

END
