PRO lidar_image, ovp, name, minlat, maxlat, avg=avg, ps = ps


	; Author: Elena Willmot
	; Date Created: June 2012
	; 
	; File creates Lidar Backscatter plot for one overpass.
	;
	; INPUTS: 
	;      ovp  :: Overpass number
	;      name :: Name of image to be saved. *Must add '.ps' to end!!*
	;	 minlat :: Minimum Latitude
	;    maxlat :: Maximum Latitude
	;
	; KEYWORDS:
	;	   avg :: If set, program will average 2 backscatter profiles.
	;		PS :: If set, display will output to postscript, otherwise it will display in IDL window.
	;

	startup				; Start AVACS
	o=OBJ_NEW('atrain')
	o->set_overpass,ovp
	
	IF keyword_set(PS) THEN X2PS,name,bits=8
	
	!P.FONT=0
	!P.CHARSIZE=0.8

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Data Section
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	; Import CALIOP data:	
	t05 = o->get_Data(Sen='CALIOP',pro='TAB_0532',/DATA,/NEAR)
	t10 = o->get_Data(Sen='CALIOP',pro='TAB_1064',/DATA,/NEAR)
	hgt = o->get_Data(Sen='CALIOP',pro='HGT',/DATA,/NEAR)
	lat = o->get_Data(Sen='CPR',pro='LAT',/DATA)
	
	min_val = 1.0E-4		; minimum value to display
	max_val = 1.0E-1	; maximum value to display
	x_ran = [minlat,maxlat] ;latitude array for abcissa label
	y_ran = hgt/1E3		;height array for the ordinate label (in km)
	ncol = 256		;number of colors to display
	;aspect  : user specified aspect (height/width) ratio
	
	;Data for chosen latitudes
	newt10 = t10[*,WHERE(lat GT minlat AND lat LT maxlat)]
	newt05 = t05[*,WHERE(lat GT minlat AND lat LT maxlat)]
	newhgt = hgt[*,WHERE(lat GT minlat AND lat LT maxlat)]

	;Apply data thresholds
	t10 = newt10 > min_val < max_val
	t05 = newt05 > min_val < max_val
	hgt = newhgt > 0 < 30E3
	
	;Reformat data arrays between 0 and 30km
	s_lid = SIZE(hgt)
	ind_jdr = hgt lt 30e3 and hgt gt 0.
	sum = TOTAL(ind_jdr,2)
	blah = WHERE(sum EQ s_lid[2],count)
	t10_2 = FLTARR(count,(SIZE(ind_jdr))[2])
	t05_2 = FLTARR(count,(SIZE(ind_jdr))[2])
	t10_2[*,*] = t10[blah,*]
	t05_2[*,*] = t05[blah,*]
	
	newlid = ROTATE(t10_2,3)
	newlid05 = ROTATE(t05_2,3)
		
	xtitle = 'Latitude [deg]'
	ytitle = 'Altitude [km]'
	
	;Average every 2 vertical profiles - smoother?
	IF keyword_set(avg) THEN BEGIN
	
		N = 2
		outprofiles = (SIZE(newlid))[1] / N
		out = FLTARR(outprofiles, (SIZE(newlid))[2])
		ind = 0
	
			FOR i=0,outprofiles-1 DO BEGIN
				X = newlid[ind:ind+N-1,*]
				Y = newlid[(i-1)*N+1+1:(i*N)+1,*]
		
				out(i,*) = mean(X,dimension=1)
				out(i,*) = mean(Y,dimension=1)
				ind = ind+N
	
			ENDFOR
			
		newlid = out		

	ENDIF
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	;Color Table Stuff
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
	steps = 2 ;Dark Blue
	r = Replicate(0,steps)
	g = Replicate(0,steps)
	b = Replicate(128,steps)
	
	steps = 5 ;Medium Blue
	r = [r, Replicate(30,steps)]
	g = [g, Replicate(144,steps)]
	b = [b, Replicate(255,steps)]
	
	r = [r, 0] ; Light Green
	g = [g, 250]
	b = [b, 154]
	
	steps = 2 ;Dark Green to medium-dark green
	scaleFactor = FINDGEN(steps)/(steps-1)
	r = [r, 0 + (46-0)*scaleFactor]
	g = [g, 100 + (139 - 100)*scaleFactor]
	b = [b, 0 + (87-0)*scaleFactor]
	
	steps = 7 ; Yellow to Red
	scalefactor1 = FINDGEN(steps)/(steps-1)
	r = [r, Replicate(255,steps)]
	g = [g, 255 + (0-255)*scalefactor1]
	b = [b, Replicate(0,steps)]
	
	steps = 3 ;Dark Red to Pink
	scalefactor2 = FINDGEN(steps)/(steps-1)
	r = [r, 255 + (255 - 255)*scalefactor2]
	g = [g, 80 + (128 - 80)*scalefactor2]
	b = [b, 80 + (178 - 80)*scalefactor2]
	
	steps = 14 ;Dark Gray to White
	scalefactor3 = FINDGEN(steps)/(steps-1)
	r = [r, 80 + (255 - 80)*scalefactor3]
	g = [g, 80 + (255 - 80)*scalefactor3]
	b = [b, 80 + (255 - 80)*scalefactor3]
	
	r = congrid(r, 256)
	g = congrid(g, 256)
	b = congrid(b, 256)
	
	r[147] = 0
	g[147] = 0
	b[147] = 0
	
	TVLCT,r,g,b
	
	elenaCT = {r : r , $		; Save my fancy-schmancy color table.
				   g : g , $	; Also saved as ElenaWcolortable.sav
				   b : b  $
				   }
	rgb = [r, g, b]
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	;Image Display
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
	IMDISP_LIDAR, newlid,/AXIS, NCOLORS = ncol, XRANGE = MINMAX(x_ran), $
			YRANGE = [0,30], BACKGROUND = 255,XTITLE = xtitle, YTITLE = ytitle, $
			RANGE=[min_val,max_val],COLOR = 147, ASPECT = 0.5
	
	;IMDISP_LIDAR, newlid,/AXIS, NCOLORS = ncol, POSITION=[0.06,0.72,0.96,0.99], $
	;		XRANGE = MINMAX(x_ran), YRANGE = [0,30], BACKGROUND = 255, $
	;		XTITLE = xtitle, YTITLE = ytitle, RANGE=[1.0E-4,1.0E-1], $
	;		BOTTOM=1, ASPECT = 5.0/25.0, COLOR = 20

	;Adds Horizontal color bar:
	DF_COLORBAR, MINRANGE=min_val, MAXRANGE=max_val, NCOLORS = ncol, $
		color = 147, DIVISIONS = 33, MINOR = 0, /VERTICAL, FORMAT = '(e9.1)', $
		POSITION = [0.91,0.19,0.93,0.81], /RIGHT, TICKLEN = 1.0 ,/ylog
	
	; Add text (title, axes, units, etc)
	XYOUTS, 0.50, 0.95, 'CALIOP Backscatter Profile', ALIGNMENT=0.5, /NORMAL, $
		CHARSIZE=0.8, CHARTHICK=1.0, color = 147
	
	XYOUTS, 0.96, 0.16, '[/km /sr]', ALIGNMENT=0.5, /NORMAL, $
		CHARSIZE=0.7, CHARTHICK=0.8, COLOR = 147


	IF keyword_set(PS) THEN PS2X,/disp,/conv

STOP

END
