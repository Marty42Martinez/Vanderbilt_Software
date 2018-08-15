PRO grid::points_to_grid,dat,lat,lon_in,tagname,_EXTRA=_EXTRA
   ; 
   ; this routine sorts a set of individual observations into a grid.
   ; if there are more than one observation in a grid-box, it averages those....
   ;
   ;  INPUT : dat,lat,lon Arrays of OBservations and corresponding lat,lon values.
   ;              dat : Whatever values are to be sorted into the grid
   ;              lat :  -90,...., +90
   ;              lon : -180,...., +180 (!!!!!)
   ;             These three fields can have arbitrary dimensions 
   ;             but all three MUST have the same dimension/size
   ;          TAGNAME : Name of TAG 
   ;  OPTIONAL KEYWORDS: year,month,day,hour,minute,second, corresponding to time of observations...
   ;                     see time_series::add
   ;
   ;  Coordinates for lat lon grid are lower left corner... i.e.
   ;  if, for a 360x180 grid  input latitude between 50.0... and 50.9999 
   ;    then this will all be sorted into bin [*,140] (140 b/c it starts with [*,0]  for lat -90 .. -89.0001
   ;    
   ;  RB, 10 Aug 2010 
   ;
   ;  bug fixes 14 Feb 2012
   ;

   lon=lon_in
   ind = WHERE(lon GT 180.,cnt)
   IF cnt NE 0 THEN lon[ind] = lon[ind] -360.

   lat0=self.latlon[0]
   lat1=self.latlon[1]
   lon0=self.latlon[2]
   lon1=self.latlon[3]
   
   nlon = LONG(self.nlon)
   nlat = LONG(self.nlat)
   
   iok = WHERE(lat GE lat0 AND lat LT lat1 AND lon GE lon0 AND lon LT lon1,cnt)
   
   IF cnt EQ 0 THEN BEGIN
     PRINT,'No data in lat/lon range ....returning'
     RETURN
   ENDIF
   
   ind2d = LONG((lon[iok]-lon0)/(lon1-lon0) * nlon)  +  $
           LONG((lat[iok]-lat0)/(lat1-lat0) * FLOAT(nlat)) * nlon
   datok = dat[iok]
   
   dummy=HISTOGRAM(ind2d,min=0,max=nlat*nlon-1L,reverse_ind=rrr)
   
   grid = FLTARR(nlon,nlat)
   nnn  = FLTARR(nlon,nlat)
   
   FOR i = 0L, nlon*nlat - 1L DO BEGIN
        IF rrr[i] EQ rrr[i+1] THEN CONTINUE
        grid[i] = grid[i] + TOTAL(datok[rrr[rrr[i]:rrr[i+1]-1]])
        nnn [i] = nnn [i] + rrr[i+1]-rrr[i]
   ENDFOR

   grid = grid / (nnn>1)
   ind  = WHERE(nnn EQ 0,cnt)
   IF cnt NE 0 THEN grid[ind] = self.missing   
    
   self->add,grid,tagname,_EXTRA=_EXTRA

;STOP

END
