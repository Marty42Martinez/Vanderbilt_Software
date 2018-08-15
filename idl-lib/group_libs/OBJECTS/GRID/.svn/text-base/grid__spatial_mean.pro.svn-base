FUNCTION grid::spatial_mean,return_time_series=return_time_series,_EXTRA=_EXTRA
   

   sel  = *self.selected
   lat  = self->get_tag('lat')
   clat = COSD(lat)
   
   ; find out how many valid entries we have
   iok = WHERE(sel EQ 1,cnt_ok)
   IF cnt_ok EQ 0 THEN RETURN,-1
   
   xmn =FLTARR(cnt_ok) - self.missing
   nok = xmn
   jul = DOUBLE(nok)

   FOR i=0L,cnt_ok-1 DO BEGIN
         
	  dat    = self->get_item(iok[i],/deref)
	  okarea = (*self.selarea) NE 0 AND dat NE self.missing
	  nok[i] = TOTAL(okarea * clat)
	  xmn[i] = TOTAL(dat * okarea * clat)  
	  jul[i] = (*self.jul)[iok[i]] 
	              
      INd = WHERE(okarea EQ 1 and dat LT -300,cnt)
      IF Cnt NE 0 THEN STOP
      
   ENDFOR	
   
   xmn = xmn / (nok > 1)
   ind = WHERE(nok EQ 0,cnt)
   IF cnt NE 0 THEN xmn[ind]=self.missing
   
   ts = OBJ_NEW('time_series')
   ts->new,xmn,'ts',jul=jul
   ts->select,/all
   ts2=ts->get(_EXTRA=_EXTRA) ; tis in case anomalies are to be calculated or other oerations on TS are to be performed
   OBJ_DESTROY,ts
   
   IF NOT(KEYWORD_SET(return_time_series)) THEN BEGIN
       RETURN,{ dat : ts2.dat, jul : ts2.jul} 
   ENDIF ELSE BEGIN 
       ts = OBJ_NEW('time_series')
       ts->new,ts2.dat,'ts',jul=ts2.jul
       ts->select,/all

       RETURN,ts
   ENDELSE  

END
