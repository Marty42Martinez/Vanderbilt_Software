FUNCTION grid::get_selected,data=data,anomly=anomaly
;
; retrieves all selected data...
;
	; now add the areal selection criteria,
    sel = self->get_tag('selected')
    sel=WHERE(sel GT 0,cnt)
	IF cnt EQ 0 THEN RETURN,-1
	area_mask = *self.selarea
	inok      = WHERE(area_mask EQ 0,cnt2)
	q0 = area_mask
	jul=0D
	tag=''
	FOR i=0,N_ELEMENTS(sel)-1 DO BEGIN
	    r  = self->get_item(sel[i],/deref)
		IF cnt2 NE 0 THEN r[inok] = -999.
	    q0  = [[[q0]],[[r]]]
		jul = [jul,(*(self.jul))[sel[i]]]
		tag = [tag,(*(self.tag))[sel[i]]]
	ENDFOR

    xdat = q0[*,*,1:*]
    jul  = jul[1:*]

    IF N_ELEMENTS(anomaly) NE 0 THEN BEGIN
    
      ok   = xdat GT -900.
      inok = WHERE(ok EQ 0,cnt)
      CALDAT,jul,mm,dd,yy
      FOR m=1,12 DO BEGIN
         ind = WHERE(mm EQ m)
         xm  = TOTAL(xdat[*,*,ind]*ok[*,*,ind],3) / (TOTAL(ok[*,*,ind],3)>1)
         FOR i=0,N_ELEMENTS(ind)-1 DO xdat[*,*,ind[i]] =xdat[*,*,ind[i]]-xm
      ENDFOR
      xdat[inok]=-999.
    
    ENDIF



	IF KEYWORD_SET(data) THEN RETURN,xdat
	
	Struct = { $
	             jul  : jul ,  $
				 tag  : tag[1:*] ,  $
				 data : xdat $ 
	          }	


    RETURN,struct			  	  	
		
END  
