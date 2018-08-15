; docformat = 'rst'

;+
;
; :history:
;     Last changed: 2012-02-28
;-
  
;+
;
; :description:
;     This method adds one or more element to a time_series. 
;     There are various ways how the associated time information can be provided.
;     Those are governed by keywords.
;
; :params:   
;      DATAFIELD : in,required
;          The actualdata that is to be added. This needs to be a 
;          one-dimensional array. It can be anything 
;   
;      TAGNAME: in, required
;          The tagnames under which the data can be addressed once it is stored n the object  
;
; :keywords:
;    JUL_IN: in, optional, type=DOUBLE
;       Set this keyword to the julian dates associated with the time series
;    
;    YEAR: in, optional, type=INTEGER
;       Set to the years associated with the time series
;        
;    MONTH: in, optional, type=INTEGER
;       Set to the months associated with the time series
;    DAY: in, optional, type=INTEGER
;       Set to the days associated with the time series
;    HOUR: in, optional, type=INTEGER
;       Set to the hours associated with the time series
;    MINUTE: in, optional, type=INTEGER
;       Set to the minutes associated INTEGER the time series
;    SECOND: in, optional, type=FLOAT
;       Set to the seconds associated with the time series
;
;
;  :examples:  
;       obj->add,fltarr(360,180),'my_map_of_nothing', jul_ins=JULDAY(12,5,2007)
;    
;-
PRO time_series::add,datafield,tagname,jul_in=jul_in, $
                               year=year,month =month ,day  =day   , $
							   hour=hour,minute=minute,second=second, $
							   _EXTRA=_EXTRA

   ; Attn: this adds one element to a time series.
   ; to create a full all-new time series see time_series->new
   
   IF OBJ_CLASS(self) EQ 'TIME_SERIES' THEN BEGIN
     ; currently a set of fields can only be added for time_Series objects...
     ; and not e.g. for grid objects...
     nfields =N_ELEMENTS(datafield)
   ENDIF ELSE BEGIN
     nfields = 1
   ENDELSE    
    
   IF N_ELEMENTS(tagname) EQ 1 THEN BEGIN
       tag = STRARR(nfields) + tagname
   ENDIF ELSE BEGIN
       tag = tagname   
   ENDELSE
   sel = 1 + INTARR(nfields)
   
   IF N_ELEMENTS(jul_in) EQ 0 THEN BEGIN 
      KEYWORD_DEFAULT,year  ,2000
      KEYWORD_DEFAULT,month ,   1
      KEYWORD_DEFAULT,day   ,   1 
      KEYWORD_DEFAULT,hour  ,  12
      KEYWORD_DEFAULT,minute,   0
      KEYWORD_DEFAULT,second,   0
	  jul = JULDAY(month,day,year,hour,minute,second)
   ENDIF ELSE BEGIN
       jul = jul_in
   ENDELSE	   
   
   IF N_ELEMENTS(tag) NE nfields THEN BEGIN
    PRINT,'number of tags inconsistent w/ datafields'
    STOP
   ENDIF
   
   IF N_ELEMENTS(jul) NE nfields THEN BEGIN
    PRINT,'number of dates inconsistent w/ datafields'
    STOP
   ENDIF
   
   IF self.nfields GT 0 THEN BEGIN
	  sel = [*self.selected, sel]
	  tag = [*self.tag     , tag]
	  jul = [*self.jul     , jul]
        
      PTR_FREE,self.selected
      PTR_FREE,self.tag
      PTR_FREE,self.jul  
   ENDIF
   
   self.tag      = PTR_NEW(tag)
   self.jul      = PTR_NEW(jul)
   self.selected = PTR_NEW(sel)
    
   self.nfields  = self.nfields + nfields
   	 
   IF OBJ_CLASS(self) EQ 'TIME_SERIES' THEN BEGIN
     ; currently a set of fields can only be added for time_Series objects...
     ; and not e.g. for grid objects...
     FOR i=0,nfields-1 DO self->linkedlist::add,datafield[i]
   ENDIF ELSE BEGIN
     self->linkedlist::add,datafield
   ENDELSE    
   
END
