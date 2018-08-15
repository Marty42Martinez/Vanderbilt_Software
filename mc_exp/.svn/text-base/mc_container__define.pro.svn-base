;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_container::init,num_flakes=num_flakes, nofill=nofill,aspectratio=aspecratio
  KEYWORD_DEFAULT,num_flakes,      500 
  KEYWORD_DEFAULT, aspectratio,    0.48

  ;to call nofill....test = obj_new('mc_container',/nofill)

  ;self.descriptors                       = HASH()
  ;self.descriptors['initial_count']      = num  
  
  ;for i = 0,999 do self.flakes[i] = OBJ_NEW('MC_flake') 
  if NOT(KEYWORD_SET(nofill)) then begin
    hold = self -> fill_container(num=num_flakes,aspectratio=aspectratio)
  endif
  ;hold = self -> fill_container(num=num_flakes)
  RETURN,1
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_container::clone, Object=object
   IF( NOT Keyword_Set(object) ) THEN object = self
   obj = object
   filename = 'clone3.sav'
   Save, obj, Filename=filename
   obj = 0 ; This is the trick to get the restore to 'clone' what it saved
   Restore, filename
   File_Delete, filename, /Quiet
   RETURN, obj
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_container::evaluate,name,_EXTRA=_EXTRA,redo=redo

   n   = self.count()
   dum = self.toarray()
   IF KEYWORD_SET(redo) THEN BEGIN
      FOR i=0,n-1 DO BEGIN
         dum2 = dum[i]->evaluate(name,_EXTRA=_EXTRA,redo=redo)
      ENDFOR
   ENDIF
   
   RETURN,self->get(name)
   
END 

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_container::get,tag

   n = self.count()
   IF n EQ 0 THEN RETURN,[-1]

   dum = self.toarray()
   
   asd = dum[0]->get(tag)
   out = REPLICATE({x:asd},n)
   
   FOR i=0,n-1 DO out[i].x = dum[i]->get(tag)

   RETURN,REFORM(out.x)

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_container::tostruct,dereference=dereference

   ;stop
   ;n = self.count()
   dum = self.toarray()
   sz = size(dum)
   n = sz[2]
   IF n EQ 0 THEN RETURN,[-1]
   
   
   asd = dum[0]->tostruct()
   asd = REPLICATE(asd,n)
   ;stop

   FOR i=1,n-1 DO begin
     d=dum[i]->tostruct()
	 asd[i] = d
   ENDFOR
   
   RETURN,asd

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_container::subset,indices,dereference=dereference

   nmax = self.count()

   IF nmax EQ 0 OR MAX(indices) GT nmax-1 OR MIN(indices) LT 0 THEN RETURN,[-1]
   
   out = OBJ_NEW('mc_container',/nofill)
   
   obj = self->getelem(indices,dereference=dereference)
   
   FOR i=0,N_ELEMENTS(indices)-1 DO out.add, obj[i]

   RETURN,out

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mc_container::getelem,index,dereference=dereference


   n = self.count()
   IF n EQ 0 OR MAX(index) GT n-1 OR MIN(index) LT 0 THEN RETURN,[-1]

   obj = (self.toarray())[index]
   
   IF KEYWORD_SET(dereference) THEN BEGIN
     filename = 'clone_temporary.sav'
     Save, obj, Filename=filename
     obj = 0 ; This is the trick to get the restore to 'clone' what it saved
     Restore, filename
     File_Delete, filename, /Quiet
   ENDIF

   RETURN,obj

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO mc_container__define

;HELP FROM JOHN;
;look in svn_repos for */johnra/DTV/
;He uses a different method than ralf



;PROBLEM;
;Have to define how many snowflakes this will hold in the source code
;try to use init to overwrite this and see how it works

;BEST SOLUTION SO FAR;
;after creating mc_container use the -> tostruct command to make the data more accessable


  structure  = {mc_container, $
                 ;flakes    : OBJARR(1000) $
				 scalefactor : 0.0, $
				 INHERITS LIST $
				 }
;Want to create a given number of mc_flake objects
;what is the best way to fill these? for-loop? Can you vectorize object creation?


end
