
  PRO profile3d,rf,no=no,xyscale=xyscale,flip=flip,yaxis=yaxis,minx=minx
  
    loadct,39
  
    IF NOT(KEYWORD_SET(xyscale)) THEN xyscale=1
    IF NOT(KEYWORD_SET(minx))    THEN minx=0

    s=SIZE(rf)
    data=FLTARR(s[1]*xyscale,s[2]*xyscale,s[3])
    FOR i=0,s[3]-1 DO data[*,*,i]=REBIN(rf[*,*,i],s[1]*xyscale,s[2]*xyscale,/SAMPLE)    
    s=SIZE(data)
    img=data[*,*,no]
    
    window,1,xsize=300,ysize=200  ,xpos=100,ypos=600,TItLE='VERTICAL PROFILE'
    window,0,xsize=s[1],ysize=s[2],xpos=500,ypos=350,TItLE='IMAGE'
    
    wset,1
    !P.multi=[0,1,1]
    
    wset,0
    tv,BYTSCL(img)
    
    END_OF_TASK=0

    x=256
    y=256
    init=1
    c_step=!d.table_size/10
    c_ind=c_step

    IF NOT(KEYWORD_SET(yaxis)) THEN y_ax=FINDGEN(s[3]) ELSE y_ax=yaxis
    
    WHILE NOT(END_OF_TASK) DO BEGIN
           cursor,x,y,/DEVICE
           IF (!err EQ 4) THEN END_OF_TASK=1
           
            IF ((!err NE 2) AND (x NE -1) AND (Y NE -1)) THEN BEGIN
              wset,1
                   rr=data(x,y,*)
                   IF KEYWORD_SET(flip) THEN BEGIN
                      xxx=y_ax
                      yyy=rr
                   ENDIF ELSE BEGIN
                       xxx=rr
                        yyy=y_Ax
                   ENDELSE
                   plot,xxx,yyy, $ 
                   title='point : ('+strcompress(string(x/xyscale))+'/'+strcompress(string(y/xyscale))+ $
                         ')', $
                   YRANGE=[0,MAX(yyy)], $
                   XRANGE=[MINX,MAX(xxx)],XSTYLE=1,PSYM=-1
               init=0
              wset,0
           ENDIF
           
           IF (!err EQ 2) THEN BEGIN
              c_ind=(c_ind+c_step) MOD !d.table_size
              wset,1
              IF (init EQ 0) THEN BEGIN 
                rr=data(x,y,*)
                   IF KEYWORD_SET(flip) THEN BEGIN
                      xxx=y_ax
                      yyy=rr
                   ENDIF ELSE BEGIN
                       xxx=rr
                        yyy=y_Ax
                   ENDELSE
                 oplot,xxx,yyy,color=c_ind
              ENDIF ELSE BEGIN
                   rr=data(x,y,*)
                   IF KEYWORD_SET(flip) THEN BEGIN
                      xxx=y_ax
                      yyy=rr
                   ENDIF ELSE BEGIN
                       xxx=y_rr
                        yyy=y_Ax
                   ENDELSE
                   plot,xxx,yyy, $ 
                   title='point : ('+strcompress(string(x/xyscale))+'/'+strcompress(string(y/xyscale))+ $
                         ')', $
                   YRANGE=[0,MAX(yyy)], $
                   XRANGE=[MINX,MAX(xxx)],XSTYLE=1

                   c_step=!d.table_size/10
                   c_ind=c_step
               init=0
              ENDELSE
              wset,0
           ENDIF
    ENDWHILE
    
    WDELETE,1,0
    
    RETURN
 END

