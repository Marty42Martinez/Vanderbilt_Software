PRO grid::ohelp, plot_tag = plot_tag

;AUTHOR:  John Rausch
;DATE:    10 MAY 2010

;ohelp prints the names, data type, columns, rows and number of entries for data
;in a grid object.  Functionality should ideally be similar to shelp.pro
;USAGE:   object_name -> ohelp
;         object_name -> ohelp, plot_tag = 'your_tag_here'  ;Plots the dates with entries

;Modified 4 NOVEMBER 2010 - jdr
;Adding support for information on range data in the object

	type = ["UNDEFINED"	     $ ;0
		   ,"BYTE"		     $ ;1
		   ,"INTEGER" 	     $ ;2
		   ,"LONG"		     $ ;3
		   ,"FLOAT"		     $ ;4
		   ,"DOUBLE"  	     $ ;5
		   ,"COMPLEX" 	     $ ;6
		   ,"STRING"  	     $ ;7
		   ,"STRUCTURE"	     $ ;8
		   ,"DOUBLE COMPLEX" $ ;9
		   ,"POINTER" 	     $ ;10
		   ,"OBJECT"  	     $ ;11
		   ,"U INTEGER"	     $ ;12
		   ,"U LONG"  	     $ ;13
		   ,"BIT64 INTEGER"  $ ;14
		   ,"U BIT64 INTEGER"] ;15


    valid_tags = TAG_NAMES({grid})
    
	i = WHERE(STRUPCASE('tag') EQ STRUPCASE(valid_tags))
	
	IF N_ELEMENTS(*(self.(i))) EQ 0 THEN BEGIN
	     PRINT, 'NO DATA IN THIS OBJECT'
	     RETURN
    ENDIF ELSE BEGIN
	
	
	subtag   = *(self.(i))
	uniq_tag = subtag[UNIQ(subtag, SORT(subtag))] ;Alphabetic list of tags in object
	index    = UNIQ(subtag, SORT(subtag))
			
		FOR j=0, N_ELEMENTS(uniq_tag)-1 DO BEGIN
			
			self -> SELECT, tags = uniq_tag[j]
			nentries  = STR(FIX(TOTAL(*self.selected)))
			data_size = SIZE(self -> GET_ITEM(index[j], /deref))
			;STOP
			;This part still needs work, cosmetically (formatting) and 
			;to also better handle non-gridded entries
			
			PRINT, '(' + STR(j) + ')    ' +uniq_tag[j]        $
				 + ':	 ' + type[data_size[N_ELEMENTS(data_size)-2]] + ' = ['   $
				 + STR(data_size[1]) + ',' + STR(data_size[2]) + ','+nentries+']'
				
		ENDFOR	
		
		
		;Plot dates with data for the selected tag.
		;Currently only plots the year and month.
		IF KEYWORD_SET(plot_tag) EQ 1 THEN BEGIN
			
			    ind = WHERE(STRUPCASE(plot_tag) EQ STRUPCASE(uniq_tag))
				IF ind NE -1 THEN BEGIN
					
					self -> SELECT, tags = uniq_tag[ind]
					ind2      = WHERE((*self.selected) EQ 1)
					CALDAT,((*self.jul)[ind2]), month, day, year, hour, minute, second
					dyear = year + month/12.
					
					PLOT, dyear, (*self.selected)[ind2], yrange = [0,2], psym = 4, title = uniq_tag[ind]
								
				ENDIF ELSE BEGIN
					PRINT, 'Invalid tag: ', plot_tag
					RETURN				
				ENDELSE
		ENDIF
				  	
		RETURN
    ENDELSE		
	
END
