PRO plot_vectorfield,u_in,v_in,lon_in,lat_in,length=length,_EXTRA=_EXTRA,hsize=hsize

 ;  plots a wind vector field in geographical coordinates
 ;  automatically clips vevtorfield to current clipping area....
 ; 
 ;  allows to pass all arrow keywords
 ;
 ;  length is given in degrees / (m/s). 
 ;  I.e. if length=1 a 1 m/s wind vector will have a length of 1 degree.
 ;
 ;  u,v : [m/s]
 ;  lat,lon : grogrpahic grid -90...+90 -180...+180
 ;  length: gives lengths in degrees per m/s
 ;
 
 KEYWORD_DEFAULT,length, 1.0
 KEYWORD_DEFAULT,hsize ,-0.5

 lat = lat_in
 lon = lon_in
 u   = u_in
 v   = v_in

 ind = WHERE(lat GT -90.0 AND lat lt 90.0 AND lon GT -180 and lon LT 180,cnt)
 IF cnt EQ 0 THEN RETURN
 u   = u  [ind]
 v   = v  [ind]
 lat = lat[ind]
 lon = lon[ind]
 
 xx  = CONVERT_COORD(lon,lat,/DATA,/TO_DEVICE)
 X0  = xx[0,*]
 y0  = xx[1,*]
 
 dlat = v * length
 dlon = u / COSD(lat) * length 

 ind = WHERE(lat+dlat GT -90. AND lat+dlat lt 90. AND lon+dlon GT -180 and lon+dlon LT 180,cnt)
 IF cnt EQ 0 THEN RETURN
 u    = u   [ind]
 v    = v   [ind]
 lat  = lat [ind]
 lon  = lon [ind]
 dlat = dlat[ind]
 dlon = dlon[ind]
 x0   = x0  [ind]
 Y0   = y0  [ind]
 
 xx   = CONVERT_COORD(lon+dlon,lat+dlat,/DATA,/TO_DEVICE)
 X1   = xx[0,*]
 Y1   = xx[1,*]
 
 ind = WHERE( $
             x0 GT !P.CLIP[0] AND x0 LT !P.CLIP[2] AND $
             x1 GT !P.CLIP[0] AND x1 LT !P.CLIP[2] AND $
             y0 GT !P.CLIP[1] AND y0 LT !P.CLIP[3] AND $
             y1 GT !P.CLIP[1] AND y1 LT !P.CLIP[3], cnt $
			)

 IF cnt NE 0 THEN ARROW,X0[ind],Y0[ind],X1[ind],Y1[ind],_EXTRA=_EXTRA,HSIZE=HSIZE

END
