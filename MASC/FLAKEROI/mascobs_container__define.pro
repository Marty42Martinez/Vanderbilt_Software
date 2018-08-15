;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs_container::init   

   RETURN,1
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO mascobs_container::cleanup

   n   = self.count()
   dum = self.toarray()
   
   FOR i=0,n-1 DO dum[i]->cleanup
   
   self.remove,/all

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs_container::evaluate,name,_EXTRA=_EXTRA,redo=redo

   doesexist = 0
   dum       = self->get(name,_EXTRA=_EXTRA)
   IF SIZE(dum[0],/TYPE) EQ  8 THEN doesexist = 1
   IF SIZE(dum[0],/TYPE) EQ 10 THEN doesexist = 1
   IF doesexist EQ 0 THEN BEGIN
     IF NOT(MAX(dum) EQ -1 AND MIN(dum) EQ -1) THEN doesexist = 1 
   ENDIF
   
   IF KEYWORD_SET(redo) OR doesexist EQ 0 THEN BEGIN
       n   = self.count()
       dum = self.toarray()
          FOR i=0,n-1 DO BEGIN
             dum2 = dum[i]->evaluate(name,_EXTRA=_EXTRA,redo=redo)
          ENDFOR
       ENDIF
   
   RETURN,self->get(name,_EXTRA=_EXTRA)
   
END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs_container::get_time_string,format=format,human=human
;
; Use C-Format Code for dates and times
;
   julday = self->get('julday')
   hum_FORMAT='(C())'
   
   IF NOT(KEYWORD_SET(format)) THEN format=hum_format

   IF KEYWORD_SET(human) THEN format=hum_format

   c=STRING(FORMAT=format,julday)
    
   RETURN,c

END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO mascobs_container::CALDAT,m,d,y,hh,mm,ss,doy

    julday = self->get('julday')
    CALDAT,julday,m,d,y,hh,mm,ss
    doy  = JULDAY(m,d,y) - JULDAY(12,31,y-1) 
            
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs_container::JULDAY

    RETURN,self->get('julday')
            
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO mascobs_container::SCALDAT,m,d,y,hh,mm,ss,doy
 
    ; nb/c of popular demand....
    self->caldat,m,d,y,hh,mm,ss,doy
    y   = STRING(y  ,FORMAT='(I4.4)')
    m   = STRING(m  ,FORMAT='(I2.2)')
    d   = STRING(d  ,FORMAT='(I2.2)')
    hh  = STRING(hh ,FORMAT='(I2.2)')
    mm  = STRING(mm ,FORMAT='(I2.2)')
    ss  = STRING(ss ,FORMAT='(I2.2)')
    doy = STRING(doy,FORMAT='(I3.3)')
           
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs_container::get,tag,_EXTRA=_EXTRA

   n = self.count()
   IF n EQ 0 THEN RETURN,[-1]

   dum = self.toarray()
   
   asd = dum[0]->get(tag,_EXTRA=_EXTRA)
   out = REPLICATE({x:asd},n)
   
   FOR i=0,n-1 DO out[i].x = dum[i]->get(tag,_EXTRA=_EXTRA)

   RETURN,REFORM(out.x)

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs_container::getelem,index,dereference=dereference


   n = self.count()
   IF n EQ 0 OR MAX(index) GT n-1 OR MIN(index) LT 0 THEN RETURN,[-1]

   obj = (self.toarray())[index]
   ;stop
   IF KEYWORD_SET(dereference) THEN BEGIN
     filename = 'clone_temporary.sav'
     Save, obj, Filename=filename
     obj = 0 ; This is the trick to get the restore to 'clone' what it saved
     Restore, filename,/relax
     File_Delete, filename, /Quiet
   ENDIF
   ;stop

   RETURN,obj

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs_container::subset,indices,dereference=dereference

   nmax = self.count()

   IF nmax EQ 0 OR MAX(indices) GT nmax-1 OR MIN(indices) LT 0 THEN RETURN,[-1]
   
   out = OBJ_NEW('mascobs_container')
   
   obj = self->getelem(indices,dereference=dereference)
   
   FOR i=0,N_ELEMENTS(indices)-1 DO out.add, obj[i]

   RETURN,out

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION mascobs_container::tostruct,dereference=dereference

   n = self.count()
   IF n EQ 0 THEN RETURN,[-1]
   
   dum = self.toarray()
   asd = dum[0]->tostruct(dereference=dereference)
   asd = REPLICATE(asd,n)

   FOR i=1,n-1 DO asd[i]=dum[i]->tostruct(dereference=dereference)
   
   RETURN,asd

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO mascobs_container__define

  structure  = {mascobs_container, $
                INHERITS LIST  $
               } 

END
