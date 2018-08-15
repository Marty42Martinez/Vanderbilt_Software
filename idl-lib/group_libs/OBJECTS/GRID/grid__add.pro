PRO grid::add,datafield_in,tagname,check=check,_EXTRA=_EXTRA,congridit=congridit

   datafield=datafield_in
   
   s =SIZE(datafield)
   
   IF s[0] NE 2 OR s[1] NE self.nlon OR s[2] NE self.nlat THEN BEGIN
   
      IF KEYWORD_SET(congridit) THEN BEGIN 
      
        ; grid the datafield to desired resolution
        ; make sure missing is treated correctly.....
        outfield = FLTARR(self.nlon,self.nlat)-self.missing 
        isok     = FLOAT(datafield NE self.missing) 
        datafield= CONGRID(datafield*isok,self.nlon,self.nlat,/INTERP)
        misok    = CONGRID(          isok,self.nlon,self.nlat,/INTERP)
        ind      = WHERE(misok GT 0.,cnt)
        IF cnt NE 0 THEN outfield[ind]  = datafield[ind] / misok[ind]
        datafield=outfield     
          
      ENDIF ELSE BEGIN
        PRINT,'WRONG Dimension of dataset to be added....'
	    PRINT,' This objeect has dimensions : '
	    PRINT,'  NLON : ',self.nlon
	    PRINT,'  NLAT : ',self.nlat
	    STOP
	    RETURN
      ENDELSE
      
   ENDIF
   
   IF KEYWORD_SET(check) THEN BEGIN
     WIS_IMAGE,datafield,*self.lat,*self.lon,_EXTRA=_EXTRA
     PRINT,'DATE : ',year,month,day,hour
     PRINT,'TAG  : ',tagname
	 PRINT,'Does this look OK ? (y/n)'
	 ok = GET_KBRD()
	 IF ok NE 'y' THEN BEGIN
    	PRINT,'... NOT OK, RETURNING, NOTHING ADDED'
		RETURN
	 ENDIF ELSE BEGIN
    	PRINT,'... OK, DATA WILL BE ADDED, TAG : ',tagname
	 ENDELSE
   ENDIF
    
   self->time_series::add,datafield,tagname,_EXTRA=_EXTRA
   
END
