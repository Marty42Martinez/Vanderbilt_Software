FUNCTION time_series::get_tag,tag,unique=unique
     ; this will return the data entries for the structure field

     valid_fields = TAG_NAMES(CREATE_STRUCT(name=obj_class(self)))
     i            = WHERE(STRUPCASE(tag) EQ STRUPCASE(valid_fields))
	 
	 IF i EQ -1 THEN BEGIN 
	     RETURN,[-1] 
     ENDIF ELSE BEGIN 
	 
	     IF SIZE(self.(i),/TYPE) EQ 10 THEN BEGIN
	        asd = *(self.(i))
	     ENDIF ELSE BEGIN 
	        asd = self.(i)
		 ENDELSE
		 		
     ENDELSE	
	 
	 IF KEYWORD_SET(unique) THEN asd=asd[UNIQ(asd,SORT(asd))]	 
	 
	 RETURN,asd
	 
END
