;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs::init,julday,fallspeed,xyz,img1,img2,img3,m0,m1,m2,if0,if1,if2,nmulti, $
                       directory,flakenumber    

   self.softwareversion = '1.1' ; RB 9/7/2015

   self.fallspeed   = fallspeed
   self.directory   = directory
   self.flakenumber = flakenumber
   
   self.camera[0] = OBJ_NEW('flakeroi',img1,scale=m0)
   self.camera[1] = OBJ_NEW('flakeroi',img2,scale=m1)
   self.camera[2] = OBJ_NEW('flakeroi',img3,scale=m2)
   self->time::init,julday=julday 
      
   (self.camera[0].descriptors)['x']=xyz[0]
   (self.camera[1].descriptors)['x']=xyz[0]
   (self.camera[2].descriptors)['x']=xyz[0]
 
   (self.camera[0].descriptors)['y']=xyz[1]
   (self.camera[1].descriptors)['y']=xyz[1]
   (self.camera[2].descriptors)['y']=xyz[1]
   
   (self.camera[0].descriptors)['z']=xyz[2]
   (self.camera[1].descriptors)['z']=xyz[2]
   (self.camera[2].descriptors)['z']=xyz[2]
    
   (self.camera[0].descriptors)['infocus']=if0
   (self.camera[1].descriptors)['infocus']=if1
   (self.camera[2].descriptors)['infocus']=if2

   (self.camera[0].descriptors)['multiflake']=nmulti
   (self.camera[1].descriptors)['multiflake']=nmulti
   (self.camera[2].descriptors)['multiflake']=nmulti

   RETURN,1
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO mascobs::cleanup

   self.camera[0]->cleanup
   self.camera[1]->cleanup
   self.camera[2]->cleanup
   
END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs::findmethod,name
  f = FILE_WHICH('mascobs__'+name+'.pro')
  IF f[0] EQ '' THEN RETURN,0 ELSE RETURN,1
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs::evaluate,name,_EXTRA=_EXTRA

  IF NOT(Self->findmethod(name)) THEN BEGIN
     dum = self.camera[0]->evaluate(name,_EXTRA=_EXTRA,redo=redo)
     dum = self.camera[1]->evaluate(name,_EXTRA=_EXTRA,redo=redo)
     dum = self.camera[2]->evaluate(name,_EXTRA=_EXTRA,redo=redo)
  ENDIF ELSE BEGIN
    IF N_ELEMENTS(_EXTRA) EQ 1 THEN BEGIN
      result = CALL_METHOD(name,self,_EXTRA=_EXTRA)
    ENDIF ELSE BEGIN
      result = CALL_METHOD(name,self)
    ENDELSE
    (self.camera[0].descriptors)[name]=result
    (self.camera[1].descriptors)[name]=result
    (self.camera[2].descriptors)[name]=result
	return, self -> get(name)
  ENDELSE
   RETURN,self->get(name,_EXTRA=_EXTRA)
   
END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs::get,tag,_EXTRA=_EXTRA
     ; this will return the data entries for the structure field

     valid_fields = TAG_NAMES(CREATE_STRUCT(name=obj_class(self)))
     i            = WHERE(STRUPCASE(tag) EQ STRUPCASE(valid_fields))
	 
	 IF i EQ -1 THEN BEGIN 
     
       ; see if this is a tag associated with each image...
       asd = self.camera[0]->get(tag,_EXTRA=_EXTRA)
       bsd = self.camera[1]->get(tag,_EXTRA=_EXTRA)
       csd = self.camera[2]->get(tag,_EXTRA=_EXTRA)
       
       IF N_ELEMENTS(asd) EQ 1 THEN BEGIN
          x = [asd,bsd,csd]
		  IF SIZE(asd,/TYPE) EQ  2 THEN BEGIN
		    x = self -> evaluate(tag,_EXTRA=_EXTRA)
			;stop
		  ENDIF
       ENDIF ELSE BEGIN   
          x={cam0 : asd, cam1 : bsd, cam2 : csd}
       ENDELSE
	      
       RETURN,REFORM(x)
     
     ENDIF ELSE BEGIN      
	     RETURN,REFORM(self.(i))
     ENDELSE	
	 
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs::tostruct,dereference=dereference

   asd = { $
           camera   : [ $
                        self.camera[0]->tostruct(dereference=dereference), $
                        self.camera[1]->tostruct(dereference=dereference), $
                        self.camera[2]->tostruct(dereference=dereference) $
                        ], $
           fallspeed : self.fallspeed, $
           julday    : self.julday()   $
          } 
   RETURN,asd

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO mascobs__define

  structure  = {mascobs, $
                 camera           : OBJARR(3) , $
                 softwareversion  : ''        , $
                 directory        : ''        , $
                 flakenumber      : ''        , $
                 fallspeed        : 0.0       , $
                 INHERITS  time            $
              } 

END
