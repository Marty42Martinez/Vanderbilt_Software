FUNCTION time::init,_EXTRA=_EXTRA
;   
   
   IF N_ELEMENTS(_EXTRA) NE 0 THEN self->set_date,_EXTRA=_EXTRA

  RETURN,1
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION time::get_time_string,format=format,human=human
;
; Use C-Format Code for dates and times
;
   hum_FORMAT='(C())'
   
   IF NOT(KEYWORD_SET(format)) THEN format=hum_format

   IF KEYWORD_SET(human) THEN format=hum_format

   c=STRING(FORMAT=format,self.julday)
    
   RETURN,c

END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time::set_date,year=year,month=month,day=day, $
                   hour=hour,minute=minute,second=second, $
                   doy=doy,             $
                   julday=julday
                   
                   
    IF N_ELEMENTS(hour)   EQ 0 THEN hour   = 0.0               
    IF N_ELEMENTS(minute) EQ 0 THEN minute = 0.0               
    IF N_ELEMENTS(second) EQ 0 THEN second = 0.0               
                   
    IF NOT(KEYWORD_SET(julday)) THEN BEGIN    
           
       ; get date   
       IF NOT(KEYWORD_SET(year)) THEN BEGIN
         PRINT,'no year specified. time object cannot be initialized correctly'
       ENDIF ELSE BEGIN
         IF NOT(KEYWORD_SET(doy)) THEN BEGIN
         
            IF NOT(KEYWORD_SET(month)) OR NOT(KEYWORD_SET(day)) THEN BEGIN
                PRINT,'no month or day specified. time object cannot be initialized correctly'
                PRINT,'returning w/o setting date....'
                RETURN
              ENDIF ELSE BEGIN
                julday = julday(month,day,year,hour,minute,second)
             ENDELSE
         
         ENDIF ELSE BEGIN
             julday = JULDAY(12,31,y-1,hour,minute,second) + doy
         ENDELSE
       
       ENDELSE
    
    ENDIF        
    
    self->set_julday,julday
    
;    PRINT,'time set to : ',self->get_time_String(/human)
                   
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time::set_julday,julday

    self.julday =julday
            
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION time::julday

    RETURN,self.julday
            
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time::CALDAT,m,d,y,hh,mm,ss,doy

    CALDAT,self.julday,m,d,y,hh,mm,ss
    doy  = JULDAY(m,d,y) - JULDAY(12,31,y-1) 
            
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time::SCALDAT,m,d,y,hh,mm,ss,doy
 
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
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time::init,_EXTRA=_EXTRA
            
      self->set_date,_EXTRA=_EXTRA

END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION time::get_property,tag
     
     time__define,struct
     tags=TAG_NAMES(struct)
     i = WHERE(tags eq STRUPCASE(tag))
     IF i[0] NE -1 THEN BEGIN    
      RETURN,self.(i)
     ENDIF ELSE BEGIN
      RETURN,-1.0
     ENDELSE 
     
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO time__define,struct

    struct = { time,  $
               julday     : 0D      $
              }  
END
