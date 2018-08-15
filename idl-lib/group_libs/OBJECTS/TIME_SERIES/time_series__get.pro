FUNCTION get_monthly_anomaly,indata,missing
   
   outdata=indata
   caldat,outdata.jul,m,d,y
   
   FOR i=1,12 DO BEGIN
     ind = WHERE(m EQ i AND indata.dat NE missing,cnt)
     IF cnt EQ 0 THEN CONTINUE
     outdata[ind].dat=outdata[ind].dat - MEAN(indata[ind].dat)
   ENDFOR

   RETURN,outdata
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION time_series::get,count=count,sort=sort,anomaly=anomaly

   
   IF KEYWORD_SET(anomaly) THEN IF STRUPCASE(anomaly) NE 'MONTHLY' THEN STOP

   sel   = *(self.selected)
   jul   = *(self.jul     )
   count = 0
         
   ; now loop through data storage and return selected elements
   FOR i=0,self.nfields-1 DO BEGIN
   
      IF sel[i] EQ 0 THEN CONTINUE
	  
      entry = {   $
		       jul : jul[i], $ 
			   dat : self->get_item(i,/deref) $
		      }  
      IF N_ELEMENTS(out) EQ 0 THEN BEGIN
	      out = entry
      ENDIF ELSE BEGIN
          out = [out,entry]
      ENDELSE
	  count = count + 1
	  
   ENDFOR
   
   ; return missing if nothing was selected
   IF N_ELEMENTS(out) EQ 0 THEN  out = [self.missing]
   
   ; If sort keyword is set, then data is sorted
   IF KEYWORD_SET(sort) AND count NE 0 THEN BEGIN
     isort = SORT(out.jul)
	 out   = out[isort]
   ENDIF
   
   
   IF KEYWORD_SET(anomaly) THEN BEGIN
     IF anomaly EQ 'MONTHLY' THEN out=get_monthly_anomaly(out,self.missing)
   ENDIF
   
   RETURN,out
   
END
