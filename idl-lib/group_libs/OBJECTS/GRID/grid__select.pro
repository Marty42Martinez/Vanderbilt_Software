PRO grid::select,years=years,months=months,days=days,hours=hours,all=all,select=select,none=none, $
                 tags=tags,count=count,latlon=latlon,areamask=areamask,ind_selected=ind_selected,period=period
;
; this allows to select fields within the
;
;  e.g g->select,months=[6] selects all fields 
;   for the month of June of any year 
;

    self->time_series::select,years=years,days=days,months=months,hours=hours,all=all, $
	                          select=select,none=none,tags=tags,count=count,ind_selected=ind_selected,period=period
	
	; now add the areal selection criteria,
	IF N_ELEMENTS(latlon) EQ 4 THEN BEGIN
	   *self.selarea = (*self.selarea) * 0.0
       IF latlon[2] LT latlon[3] THEN BEGIN
           ; this is the case if longitude DOES cross the +-180 deg
	       ind = WHERE( *self.lat GE latlon[0] AND $ 
                        *self.lat LE latlon[1] AND $ 	
                        *self.lon GE latlon[2] AND $ 	
                        *self.lon LE latlon[3],cnt)
	       IF cnt NE 0 THEN (*self.selarea)[ind]=1				
	   ENDIF ELSE BEGIN
           ; this is the case if longitude DOES cross the +-180 deg
           ; e.g [-90,-90,150,-85] longitude range from 150E to 85 W !!
	       ind = WHERE( *self.lat GE latlon[0] AND $ 
                        *self.lat LE latlon[1] AND $ 	
                        (*self.lon GE latlon[2] OR *self.lon LE latlon[3]), $
                        cnt)
	       IF cnt NE 0 THEN (*self.selarea)[ind]=1				
       ENDELSE
       				 	
	ENDIF
	
    ; if all is set, then also reset the latlon selection....
    IF KEYWORD_SET(all) THEN *self.selarea = (*self.selarea) * 0 + 1
        
	IF N_ELEMENTS(areamask) EQ (self.nlat*self.nlon) THEN (*self.selarea) = *self.selarea AND areamask
		
END  
