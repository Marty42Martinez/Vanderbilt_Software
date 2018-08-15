;+
;  :Hidden:
;-

@linkedlist__define
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; LIFETIME ROUTINES INIT, CLEANUP, DEFINE, and GET_TAG
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION time_series::init,missing=missing,_EXTRA=_EXTRA, $
                            datafields=datafields,tagnames=tagnames

   KEYWORD_DEFAULT,missing,-999.
   
   self.missing = missing
   
   self->new,datafields,tagnames,_EXTRA=_EXTRA
      
   RETURN,1
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time_series::cleanup
   
    self->delete_all

END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time_series::delete_all
   

   PTR_FREE,self.selected
   PTR_FREE,self.tag
   PTR_FREE,self.jul  

   IF self.nfields GT 0 THEN self->linkedlist::cleanup

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time_series__define

  structure  = {time_series, $
				nfields  : 0L,  $
				missing  : 0.0, $
				selected : PTR_NEW(), $
				tag      : PTR_NEW(), $
				jul      : PTR_NEW(), $
                INHERITS linkedlist   $
               } 

END
