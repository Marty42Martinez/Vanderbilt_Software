PRO flakeroi::get_roi,image,pathinfo,pathxy
     
     ; Select and open the image file and get its size.
     img = image
     dims = SIZE(*self.img, /DIMENSIONS)
          
     oldDevice = !D.NAME
     SET_PLOT,'Z'
     
;     WINDOW, XSIZE = dims[0], YSIZE = dims[1],/PIXMAP,/FREE

     ; Create a mask that identifies pixels larger than 0
     threshImg = (img GE self.descriptors['threshold'])

     ; Get rid of gaps, applying a 3x3 element to the image
     ; using the erosion and dilation morphological
     ; operators.
     strucElem = REPLICATE(1, 3, 3)
     threshImg = ERODE(DILATE(TEMPORARY(threshImg),strucElem), strucElem)

     ; Extract the contours of the thresholded image.
     CONTOUR, threshImg, LEVEL = 0.999,  $
        XMARGIN = [0, 0], YMARGIN = [0, 0], $
        /NOERASE, PATH_INFO = pathInfo, PATH_XY = pathXY, $
        XSTYLE = 5, YSTYLE = 5, /PATH_DATA_COORDS

     
     SET_PLOT,oldDevice
     
 ;    WDELETE,!D.WINDOW 
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION flakeroi::init,image,scale=scale,threshold=threshold,noparams=noparams
   
   KEYWORD_DEFAULT,scale    ,0.03
   KEYWORD_DEFAULT,threshold,6
   
   self.img                      = PTR_NEW(image) 
;   self.descriptors              = DICTIONARY()
   self.descriptors              = HASH()
   self.descriptors['scale']     = scale
   self.descriptors['threshold'] = threshold


   self->get_roi,image,pathinfo,pathxy
   
   line            = [LINDGEN(pathInfo(0).N), 0]
   dum             = self -> IDLanROI::INIT(            $
                     (pathXY(*,pathInfo(0).OFFSET + line))[0, *], $
                     (pathXY(*,pathInfo(0).OFFSET + line))[1, *])

   self.mask                     = PTR_NEW(self->mask())

   IF NOT(KEYWORD_SET(noparams)) THEN BEGIN
      self.descriptors['area']      = self->area()
      self.descriptors['perimeter'] = self->perimeter()
      self.descriptors['laplace2']  = self->laplace2()
      self.descriptors['texture']   = self->texture()
      self.descriptors['mean']      = self->mean()
      self.descriptors['stdev']     = self->stdv()
      self.descriptors['fracdim']   = self->fracdim()
   ENDIF
         
   RETURN,1
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION flakeroi::findmethod,name
  f = FILE_WHICH('flakeroi__'+name+'.pro')
  IF f[0] EQ '' THEN RETURN,0 ELSE RETURN,1
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION flakeroi::get_key_string_idl_82_83_bug
   
  keys = self.descriptors.keys()
  IF SIZE(keys,/TYPE) EQ 11 THEN keys=keys.toarray()
  
  RETURN,keys
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION flakeroi::evaluate,name,_EXTRA=_EXTRA,redo=redo

  IF NOT(KEYWORD_SET(redo)) THEN BEGIN
     keys = self->get_key_string_idl_82_83_bug()
     ind  = WHERE(STRUPCASE(keys) EQ STRUPCASE(name),cnt)
     IF cnt NE 0 THEN RETURN,self.descriptors[name]
  ENDIF 

  IF NOT(Self->findmethod(name)) THEN BEGIN
    result = [-1]
  ENDIF ELSE BEGIN
    IF N_ELEMENTS(_EXTRA) EQ 1 THEN BEGIN
      result = CALL_METHOD(name,self,_EXTRA=_EXTRA)
    ENDIF ELSE BEGIN
      result = CALL_METHOD(name,self)
    ENDELSE
    self.descriptors[name]=result
  ENDELSE
  
  RETURN,result
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO flakeroi::cleanup

   PTR_FREE,self.img
   self->IDLanROI::cleanup

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION flakeroi::tostruct,dereference=dereference

    asd  = {img  : PTR_NEW(), $
            mask : PTR_NEW(), $
            descriptors : self.descriptors.tostruct()  $
           }
    asd = CREATE_STRUCT(asd,{IDLanROI})
    
    tags = TAG_NAMES(asd)
    FOR i=0,N_TAGS(asd)-1 DO BEGIN
         
         IF STRUPCASE(tags[i]) EQ 'DESCRIPTORS' THEN CONTINUE
         
	     IF SIZE(self.(i),/TYPE) EQ 10 THEN BEGIN
            IF PTR_VALID(self.(i)) THEN BEGIN
               IF KEYWORD_SET(dereference) THEN asd.(i) = PTR_NEW(*self.(i)) ELSE asd.(i)=self.(i)
            ENDIF   
	     ENDIF ELSE BEGIN 
	        asd.(i) = self.(i)
            IF FINITE(asd.(i)[0]) EQ 0 THEN BEGIN
              asd.(i) = self->get(tags[i])
           ENDIF   
		 ENDELSE
    ENDFOR 
  
    RETURN,asd

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION flakeroi::get,tag,unique=unique,dereference=dereference,_EXTRA=_EXTRA
     ; this will return the data entries for the structure field

     tags = TAG_NAMES(CREATE_STRUCT(name=obj_class(self)))
     i    = WHERE(STRUPCASE(tag) EQ STRUPCASE(tags))
	 
     ; pass on to dictionary....
	 IF i[0] EQ -1 THEN RETURN,self->evaluate(tag,_EXTRA=_EXTRA) 
          
     ; from here on deal with all other datatypes in flakeroi structure...     
	 IF SIZE(self.(i),/TYPE) EQ 10 AND KEYWORD_SET(dereference) THEN BEGIN
        IF PTR_VALID(self.(i)) THEN  asd = *(self.(i))
	 ENDIF ELSE BEGIN 
	    asd = self.(i)
	 ENDELSE

	 IF KEYWORD_SET(unique) THEN asd=asd[UNIQ(asd,SORT(asd))]	 
	 
	 RETURN,asd
	 
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO flakeroi__define

  structure  = {flakeroi, $
                img          : PTR_NEW(),    $
                mask         : PTR_NEW(),    $
;                descriptors  : DICTIONARY(), $ 
                 descriptors  : HASH(), $ 
               INHERITS IDLanROI            $
               } 

END
