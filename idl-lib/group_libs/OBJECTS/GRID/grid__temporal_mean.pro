FUNCTION grid::temporal_mean,nok=nok,data=data
   
   xmn = self->get_tag('lat') * 0.0
   nok = xmn
   
   sel = *self.selected

   FOR i=0L,self->get_count()-1 DO BEGIN
   
      IF sel[i] NE 1 THEN CONTINUE
      
	  dat = self->get_item(i,/deref)
	  	  
	  iok = dat NE self.missing  AND *self.selarea
	  
	  nok = nok + iok
	  xmn = xmn + dat * iok  
	  
   ENDFOR	  
   
   xmn = xmn / (nok>1)
   
   ind = WHERE(nok EQ 0,cnt)
   IF cnt NE 0 THEN xmn[ind]=self.missing 

   IF KEYWORD_SET(data) THEN BEGIN 
      RETURN,xmn
   ENDIF ELSE BEGIN
       out=OBJ_NEW('grid',nlat=self.nlat,nlon=self.nlon,missing=self.missing,latlon=self.latlon)
       out->add,xmn,'MEAN'
       RETURN,out
   ENDELSE
END
