PRO grid::image,_EXTRA=_EXTRA,void_index=void_index
   sel = self->get_tag('selected')
   sel=WHERE(sel GT 0)
   IF N_ELEMENTS(sel) GT 1 THEN BEGIN
    PRINT,'returning, More than one field selected'
   ENDIF	
   
   img = self->get_item(sel[0],/deref)
      
   ind_ok = BYTE(img * 0) + 1B
   IF KEYWORD_SET(void_index) THEN  ind_ok[void_index] = 0B
   
   ind=WHERE(img NE self.missing AND *self.selarea NE 0 AND ind_ok EQ 1B)
   
   
   
   IF ind[0] NE -1 THEN BEGIN 
     wis_image,img[ind],(*self.lat)[ind],(*self.lon)[ind],_EXTRA=_EXTRA
   ENDIF	 
END
