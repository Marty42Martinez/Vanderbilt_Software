PRO time_series::deselect, years=years,months=months,days=days, $
                         hours=hours,minutes=minutes,seconds=seconds, $
                         all=all,select=select, $
                         tags=tags,count=count,ind_selected=ind_selected,period=period
;
; this allows to deselect fields within the object
;
;  e.g g->select,months=[6] selects all fields 
;   for the month of June of any year 
;
    ; THIS SELECTS ALL OBJECTS
    IF KEYWORD_SET(all) THEN BEGIN
	  (*self.selected)=(*self.selected)*0.0
	  RETURN
	ENDIF

	
	; THIS ALLOWS TO PASS A MASK WITH OBJECTS TO BE SELECTED
    IF KEYWORD_SET(select) THEN BEGIN
	  IF N_ELEMENTS(select) NE self.nfields THEN BEGIN  
	    PRINT,'wrong number of elements in selected'
	    PRINT,'selection criteria not set'
		STOP
		RETURN
	  ENDIF
	  (*self.selected)[0:N_ELEMENTS(select)-1]=1-select
	  RETURN
	ENDIF
		
	; Set default values for selection 
    KEYWORD_DEFAULT,years  , FINDGEN(70)+1950
    KEYWORD_DEFAULT,months , FINDGEN(12)+1
    KEYWORD_DEFAULT,days   , FINDGEN(31)
    KEYWORD_DEFAULT,hours  , FINDGEN(24)
    KEYWORD_DEFAULT,minutes, FINDGEN(60)
    KEYWORD_DEFAULT,seconds, FINDGEN(60)
    KEYWORD_DEFAULT,tags   , self->get_tag('tag',/unique)
	 
	select=(*self.selected)
	; this for time and tag
	
	CALDAT,(*self.jul),month,day,year,hour,minute,second
	second = FIX(second)
	
    FOR i=0L,self->get_count()-1 DO BEGIN
	  dum = WHERE(day   [i] EQ [-1,days    ] ,c0)
	  dum = WHERE(month [i] EQ [-1,months  ] ,c1)
	  dum = WHERE(year  [i] EQ [-1,years   ] ,c2)
	  dum = WHERE(hour  [i] EQ [-1,hours   ] ,c3)
	  dum = WHERE(minute[i] EQ [-1,minutes ] ,c4)
	  dum = WHERE(second[i] EQ [-1,seconds ] ,c5)
	  dum = WHERE(STRUPCASE((*self.tag)[i]) EQ STRUPCASE(tags)  ,c6)
  	  IF c0+c1+c2+c3+c4+c5+c6 EQ 7 THEN select[i] = 0 ; ELSE select[i] = 1	 
	  
	ENDFOR
    
    ; now period...
    IF KEYWORD_SET(period) THEN BEGIN
	  select=(*self.selected)
	  jul = self->get_tag('jul')	
	  tag = self->get_tag('tag')	
      FOR i=0L,self->get_count()-1 DO BEGIN
	    dum = WHERE(STRUPCASE((*self.tag)[i]) EQ STRUPCASE(tags)  ,c1)
        IF c1 GT 0 AND jul[i] GE period[0] AND jul[i] LE period[1] THEN select[i]=0
      ENDFOR
    ENDIF
    		
	*self.selected = select
	    
	ind_selected=WHERE(select GT 0,count)
	            
END  
