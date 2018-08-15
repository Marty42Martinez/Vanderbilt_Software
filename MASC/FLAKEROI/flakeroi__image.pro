FUNCTION flakeroi::image,ellipse_keyword=ellipse_keyword,_EXTRA=_EXTRA,HISTEQ=histeq,scale=scale,blue=blue, $
                   mmthick=mmthick, notext=notext,thickbar=thickbar

    IF KEYWORD_SET(blue) THEN rgb_table=COLORTABLE(49,/REVERSE)
    KEYWORD_DEFAULT,mmthick,3
    
    dat = *self.img
        
    IF KEYWORD_SET(histeq) THEN dat=HIST_EQUAL(dat)
    
    img=IMAGE(dat,_EXTRA=_EXTRA,rgb_table=rgb_table)
    
    IF KEYWORD_SET(ellipse_keyword) THEN BEGIN 
      x=self->ellipse()
      e=ellipse(x.x0,x.y0,target=img,major=x.major/2,minor=x.minor/2,theta=x.angle,/data, $
                FILL_BACKGROUND=0,color='red',THICK=2)
                
    ENDIF
    
    IF KEYWORD_SET(scale) THEN BEGIN
      scale      = self->evaluate('scale')
      pixpermm   = 1.0/ (scale*10.)
      s          = SIZE(dat)
      x0         = s[1]/2-0.5*pixpermm
      x1         = s[1]/2+0.5*pixpermm
      asd       = ARROW([x0,x1],[2,2],COLOR='yellow',head_angle=0,/DATA,HEAD_SIZE=0.1,CLIP=0,THICK=mmthick)
      IF KEYWORD_SET(thickbar) THEN BEGIN
	    asd2      = ARROW([x0,x1],[2.3,2.3],COLOR='yellow',/DATA,HEAD_SIZE=0.1,CLIP=0,THICK=mmthick)
	    asd3      = ARROW([x0,x1],[2.6,2.6],COLOR='yellow',/DATA,HEAD_SIZE=0.1,CLIP=0,THICK=mmthick)
	    asd4      = ARROW([x0,x1],[2.9,2.9],COLOR='yellow',/DATA,HEAD_SIZE=0.1,CLIP=0,THICK=mmthick)
	  ENDIF
	  IF NOT(KEYWORD_SET(notext)) THEN txt      = TEXT (s[1]/2,-20,' 1 mm',/DATA,CLIP=0,ALIGNMENT=0.5,COLOR='red') 
     ENDIF

    RETURN,img
END
