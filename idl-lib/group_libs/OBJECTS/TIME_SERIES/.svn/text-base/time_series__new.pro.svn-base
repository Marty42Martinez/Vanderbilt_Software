; docformat = 'rst'

;+
;
; :history:
;     Last changed: 2010-05-11
;-
  
;+
;
; :description:
;     Creates a new time series. 
;     There are various ways how the associated time information can be provided.
;     Those are governed by keywords.
;     Note: This function creates a whole new time series. Any old data in the object is deleted. 
;     To just add one element to a time_series use time_series::add instead
;
; :params:   
;      DATAFIELDS : in,required
;          The actual time series of data that is to be added. This needs to be a 
;          one-dimensional array. It can be a one-dimensional array of structures though. 
;   
;      TAGNAMES: in, required
;          The tagnames under which the time series can be addressed once it is stored n the object  
;
; :keywords:
;    JUL_INS: in, optional, type=DOUBLE
;       Set this keyword to the julian dates associated with the time series
;    
;    YEARS: in, optional, type=INTEGER
;       Set to the years associated with the time series
;        
;    MONTHS: in, optional, type=INTEGER
;       Set to the months associated with the time series
;    DAYS: in, optional, type=INTEGER
;       Set to the days associated with the time series
;    HOURS: in, optional, type=INTEGER
;       Set to the hours associated with the time series
;    MINUTES: in, optional, type=INTEGER
;       Set to the minutes associated INTEGER the time series
;    SECONDS: in, optional, type=FLOAT
;       Set to the seconds associated with the time series
;
;
;  :examples:  
;       obj->new,findgen(365),'my_time_series', jul_ins=JULDAY(1,1,2000)+FINDGEN(365)
;    
;-
PRO time_series::new,datafields,tagnames,jul_ins=jul_ins, $
                               years=years,months =months ,days  =days   , $
							   hours=hours,minutes=minutes,seconds=seconds, $
							   _EXTRA=_EXTRA

   ; Attn: this creates a full new time series
   ; to add only one element, see time_series->add
   
   
   IF N_ELEMENTS(datafields) EQ 0 OR N_ELEMENTS(tagnames) EQ 0 THEN RETURN
   
   IF N_ELEMENTS(tagnames) EQ 1 THEN BEGIN
      tags = STRARR(N_ELEMENTS(datafields))+tagnames
   ENDIF ELSE BEGIN
      tags =tagnames
   ENDELSE	
   
   IF N_ELEMENTS(jul_ins) EQ 0 THEN BEGIN 
      KEYWORD_DEFAULT,years  ,2000
      KEYWORD_DEFAULT,months ,   1
      KEYWORD_DEFAULT,days   ,   1 
      KEYWORD_DEFAULT,hours  ,  12
      KEYWORD_DEFAULT,minutes,   0
      KEYWORD_DEFAULT,seconds,   0
	  juls = JULDAY(months,days,years,hours,minutes,seconds)
   ENDIF ELSE BEGIN
       juls = jul_ins
   ENDELSE	
   
   IF N_ELEMENTS(juls) NE N_ELEMENTS(datafields) OR $
      N_ELEMENTS(tags) NE N_ELEMENTS(datafields) THEN BEGIN	  
		 PRINT,'Something wrong with dimensions'
		 PRINT,'cannot create time_series'
		 RETURN
  ENDIF	  
  
  self->delete_all  
  
  self.nfields  = N_ELEMENTS(tags)
  self.tag      = PTR_NEW(tags)
  self.jul      = PTR_NEW(juls)
  self.selected = PTR_NEW(FLTARR(self.nfields)+1)
    
  FOR i=0,self.nfields-1 DO self->linkedlist::add,datafields[i]
   
END
