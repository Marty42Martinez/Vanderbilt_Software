;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erzeugt contourplots mit color bar sowohl 
; auf ps als auch auf den Schirm (nur true color!!!!!!)
; Aufruf:

;make_cool_contour,bild,bild_X,bild_Y,			$
;		,n_level				$
;		,yrange=yrange 				$
;		,xrange=xrange 				$
;		,xtitle='x axxxe'			$
;		,ytitle='y axxxxe'			$
;		,bar_title=x_title_of_color_bar		$
;		,mini=minimum_of_color_bar		$
;		,maxi=maximum_of_color_bar		$
;		,format=format_string_of_bar 		$  z.B.: '(f6.2)'
;		,/bw					$  schwarz/weiss				
;		,/lines					$  overplot mit lines
;		,nbar=nbar
; Achtung: mini=0 bedeutet,das mini nicht gesetzt ist
;(IDL keyword konvention! also 0.00001)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro make_bar,levels,position,title=title,bw=bw,format=format,lines=lines $
	    ,nbar=nbar,contin_bar=contin_bar,no_bar=no_bar

	if keyword_set (nbar) then $
			levels=rp_vector(min(levels),max(levels),float(nbar))

	border=rp_vector(0.,1.,n_elements(levels)+1)
	mittel=(border+shift(border,1))/2.
	mittel=[0,mittel(1:*),1]
	plot,[0,1],[0,0],ystyle=4		$
 	   ,xticks=n_elements(levels+2)		$
  	   ,xtickv=mittel				$
   	   ,xtickname=['  ',string(levels,format=format),'  ']  $
	   ,position=position				$
	   ,xtitle=title
    	   
	
		
        if keyword_set(bw) then begin
		if keyword_set(contin_bar) then dum_bar=rp_vector(20.,255.,2500.)  $
    	  	else dum_bar=rp_vector(20,255,n_elements(levels)) 		; ps!!!!
		dum_bar=[transpose(dum_bar),transpose(dum_bar),transpose(dum_bar)]
		
 		if keyword_set(contin_bar) then   dum_bar=reform(transpose(dum_bar),2500,1,3)$
    	  	else dum_bar=reform(transpose(dum_bar),n_elements(levels),1,3) 
     	endif else begin
		if keyword_set(contin_bar) then dum_bar=color_image(indgen(2500))				$
		   else dum_bar=color_image(indgen(n_elements(levels)))
	endelse	 
	
;	dum_bar(3,*,0)=255
;	dum_bar(3,*,1)=0
; 	dum_bar(3,*,2)=255
;
  	x  = !d.x_size * !x.window
  	y  = !d.y_size * !y.window
  	if (!d.flags and 1) eq 1 then begin ; device has scalable pixel size
   	 dx = x[1] - x[0]
    	 dy = y[1] - y[0]
         bar=dum_bar
 	endif else begin              ; pixels are non-scalable
    	 dx = ceil(x[1]) - floor(x[0])
    	 dy = ceil(y[1]) - floor(y[0])
    	 bar= lonarr(dx,dy,3)
    	 for i=0,2 do bar(*,*,i)=transpose(congrid(transpose(dum_bar(*,*,i)),dy,dx))
    	endelse
  
  	oplot,[0,1]

        tv,bar,x(0),y(0),true=3,xsize=dx,ysize=dy,/device 
	
	tv,bar,x(0),y(0),true=3,xsize=dx,ysize=dy,/device

	x_schlange=[border(0),border(1),border(1),border(0),border(0)]
	y_schlange=[0,0,1,1,0]
	
	if n_elements(levels) ge 2 then begin
	for i=1,n_elements(levels)-1 do begin
	  x_schlange=[x_schlange,border(i),border(i+1),border(i+1),border(i),border(i)]
	  y_schlange=[y_schlange,0,0,1,1,0]
	endfor
	endif 
	plots,x_schlange,y_schlange
	
	
	

end

pro make_cool_contour,bild,bild_x,bild_y,n_lev		$
		     ,mini=mini,maxi=maxi		$
		     ,_extra=extra			$
		     ,bar_title=bar_title		$
		     ,bw=bw,format=format, lines=lines	$
		     ,nbar=nbar,contin_bar=contin_bar,no_bar=no_bar


	IF NOT(KEYWORD_SET(no_bar)) THEN !p.multi=[0,1,2]

	

	if is_defined(mini) then minii=mini else minii=min(bild)
	if is_defined(maxi) then maxii=maxi else maxii=max(bild)
	
	print,	minii,min(bild)
	print,	maxii,max(bild)


	if maxii lt max(bild) then 			$  
	print,'Warning max of data is higher than max of bar. Plot could be ambiguous!' 
	if minii gt min(bild) then 			$  
	print,'Warning min of data is lower than min of bar. Plot could be ambiguous!' 


	fill_levels=rp_vector(FLOAT(minii),FLOAT(maxii),FLOAT(n_lev-1))

	line_levels=rp_vector(FLOAT(minii),FLOAT(maxii),FLOAT(n_lev))
	
	if keyword_set(bw) then begin
	   fill_col=rp_vector(10,255,n_lev-1) 
	   fill_col=[transpose(fill_col),transpose(fill_col),transpose(fill_col)]
 	   fill_col=reform(transpose(fill_col),n_lev-1,1,3) 
	endif else fill_col=color_image(fill_levels)
;	fill_col(3,*,0)=(255)
;	fill_col(3,*,1)=(0)
;	fill_col(3,*,2)=(255)
;

	if (!d.flags and 1) eq 1 then begin ; device has scalable pixel size
	   	tvlct,r,g,b,/get
 	  	tvlct, [0,fill_col(*,0,0)],[0,fill_col(*,0,1)],[0,fill_col(*,0,2)]
  	 	fill_col=(indgen(n_lev-1)+1) 
 	endif else begin         
		fill_col=true_color_index(fill_col(*,0,0),fill_col(*,0,1),fill_col(*,0,2))
	endelse
	
	IF NOT(KEYWORD_SET(no_bar)) THEN position=[0.20,0.38,0.96, 0.95 ]


	contour, bild ,bild_x,bild_y		$
	,/follow				$
	,/close					$
	,/fill					$
	,levels=line_levels			$
	,c_colors=fill_col			$
	,xstyle=1				$
	,ystyle=1				$
	,_extra=extra	$			
	,position=position

	if keyword_set(lines) then begin

		contour, bild ,bild_x,bild_y		$
		,/follow				$
		,/close					$
		,levels=line_levels			$
		,/overplot			
	endif

	if (!d.flags and 1) eq 1 then tvlct,r,g,b
	position=[!x.window(0),0.15,!x.window(1),0.2]
	IF NOT(KEYWORD_SET(no_bar)) THEN $
	   make_bar,fill_levels,position,title=bar_title,bw=bw,format=format,nbar=nbar,contin_bar=contin_bar

end
