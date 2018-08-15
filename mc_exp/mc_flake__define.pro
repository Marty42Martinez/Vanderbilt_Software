;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_flake::init,mass=mass,Dmax=Dmax,aspectratio=aspectratio,noparams=noparams,seed=seed
   
                       ;Updated 12/07/2015;
  ;Now snowflakes are define dy Dmax, mass, and aspect ratio
   asd = RANDOMU(xseed)
   KEYWORD_DEFAULT,mass,          6.55e-9 ;kg
   KEYWORD_DEFAULT,Dmax,          1e-4    ;m [0.1 mm]
   KEYWORD_DEFAULT,aspectratio,   0.48    
   KEYWORD_DEFAULT,seed,          xseed
   
   ;2/10/16
   ;Seed is defined like this in order to preserve true randomness
   ;IMPORTANT FOR COMPARING RESULTS
   ;We may need to create a situation where a particle uses the same seed value
   ;in this case we MUST specify the value for seed during particle creation
   
   mass_arr                     = fltarr(5)
   ;Each position of mass_arr defined below;
   ;[0]:  current particle mass
   ;[1]:  total mass added by diffusional growth
   ;[2]:  total mass added by riming
   ;[3]:  total mass added by aggregation
   ;[4]:  initial particle mass
   
   
   
   
   mass_arr[0]                   = mass
   mass_arr[4]                   = mass
   
   self.mass_arr                 = mass_arr
   self.Dmax                     = Dmax
   self.aspectratio              = aspectratio

   self.seed                     = PTR_NEW(seed)
   
   

   IF NOT(KEYWORD_SET(noparams)) THEN BEGIN	  
	  ;self.volume                  = self -> volume()
	  ;self.phys_d                  = self -> phys_d()
	  ;self.fallspeed               = self -> fallspeed()
	  self.num_aggregate           = 0.
	  
	  self.free_path               = -alog(randomu(*self.seed,1))

	  ;self.num_splinter            = 0
   ENDIF
         
   RETURN,1
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_flake::clone, Object=object,keep_seed=keep_seed,seed=seed
   KEYWORD_DEFAULT, seed, LONG(systime(1))
   IF( NOT Keyword_set(object) ) THEN object = self
   obj = object
   filename = 'clone4.sav'
   ;stop
   Save, obj, Filename=filename
   obj = 0 ; This is the trick to get the restore to 'clone' what it saved
   Restore, filename
   if NOT( Keyword_set(keep_seed)) then obj -> change_seed,seed=seed
   File_Delete, filename, /Quiet
   RETURN, obj
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO mc_flake::change_seed,seed=seed
  asd = RANDOMU(xseed)
  KEYWORD_DEFAULT, seed, xseed
  self.seed = ptr_new(LONG(seed))
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_flake::get,tag,unique=unique,dereference=dereference,_EXTRA=_EXTRA
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
FUNCTION mc_flake::findmethod,name
  f = FILE_WHICH('mc_flake__'+name+'.pro')
  IF f[0] EQ '' THEN RETURN,0 ELSE RETURN,1
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_flake::get_key_string_idl_82_83_bug
   
  keys = self.descriptors.keys()
  IF SIZE(keys,/TYPE) EQ 11 THEN keys=keys.toarray()
  
  RETURN,keys
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_flake::evaluate,name,_EXTRA=_EXTRA,redo=redo

  ;IF NOT(KEYWORD_SET(redo)) THEN BEGIN
  ;   keys = self->get_key_string_idl_82_83_bug()
  ;   ind  = WHERE(STRUPCASE(keys) EQ STRUPCASE(name),cnt)
  ;   IF cnt NE 0 THEN RETURN,self.descriptors[name]
  ;ENDIF 

  IF NOT(Self->findmethod(name)) THEN BEGIN
    result = [-1]
  ENDIF ELSE BEGIN
    IF ARG_PRESENT(_EXTRA) THEN BEGIN
      result = CALL_METHOD(name,self,_EXTRA=_EXTRA)
    ENDIF ELSE BEGIN
      result = CALL_METHOD(name,self)
    ENDELSE
    ;self.descriptors[name]=result
  ENDELSE
  
  RETURN,result
  
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO flakeroi::cleanup

   PTR_FREE,self.seed


END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_flake::tostruct,dereference=dereference
    ;stop
	;Do I need to have a tostruct function??;
    asd  = {     mass_arr        : self.mass_arr, $
	             Dmax            : self.Dmax, $			 
				 aspectratio     : self.aspectratio,$
				 num_aggregate   : self.num_aggregate $
				 ;num_splinter    : self.num_splinter $  
           }
    ;asd = CREATE_STRUCT(asd)
    
    ;tags = TAG_NAMES(asd)
;    FOR i=0,N_TAGS(asd)-1 DO BEGIN
;      asd.(i) = self.(i)
;	  IF FINITE(asd.(i)[0]) EQ 0 THEN BEGIN
;        asd.(i) = self->get(tags[i])
;      ENDIF 
;         
;         IF STRUPCASE(tags[i]) EQ 'DESCRIPTORS' THEN CONTINUE
;         
;	     IF SIZE(self.(i),/TYPE) EQ 10 THEN BEGIN
;            IF PTR_VALID(self.(i)) THEN BEGIN
;               IF KEYWORD_SET(dereference) THEN asd.(i) = PTR_NEW(*self.(i)) ELSE asd.(i)=self.(i)
;            ENDIF   
;	     ENDIF ELSE BEGIN 
;	        asd.(i) = self.(i)
;            IF FINITE(asd.(i)[0]) EQ 0 THEN BEGIN
;              asd.(i) = self->get(tags[i])
;           ENDIF   
;		 ENDELSE
    ;ENDFOR 
  
    RETURN,asd

END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


PRO mc_flake__define




  structure  = {mc_flake, $ 
                 ;descriptors  : HASH() $ 
				 Dmax          : 0.0, $
				 mass_arr      : fltarr(5), $
				 aspectratio   : 0.0,$
				 free_path       : 0.0,$
				 num_aggregate   : 0, $
				 seed            : PTR_NEW() $
				 ;num_splinter   : 0 $
               } 

end
