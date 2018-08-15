@time_series__define
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; LIFETIME ROUTINES INIT, CLEANUP, DEFINE, and GET_TAG
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION grid::init,nlat=nlat,nlon=nlon,missing=missing,latlon=latlon

   KEYWORD_DEFAULT,nlon,360
   KEYWORD_DEFAULT,nlat,180
   KEYWORD_DEFAULT,missing,-999.
   KEYWORD_DEFAULT,latlon,[-90.0,90.0,-180.0,180.0]
   
   idum=self->time_series::init(missing=missing)
   
   self.nlon    = nlon
   self.nlat    = nlat
   self.latlon  = latlon
      
   dlon = (latlon[3]-latlon[2])/nlon
   self.lon=PTR_NEW(rp_vector(latlon[2]+dlon/2,latlon[3]-dlon/2,nlon) # (FLTARR(nlat)+1))

   dlat = (latlon[1]-latlon[0])/nlat
   self.lat=PTR_NEW(rp_vector(latlon[0]+dlat/2,latlon[1]-dlat/2,nlat) ## (FLTARR(nlon)+1))
      
   self.selarea = PTR_NEW(INTARR(nlon,nlat) + 1) 
   
   RETURN,1
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO grid::cleanup

   PTR_FREE,self.lat  
   PTR_FREE,self.lon 
   PTR_FREE,self.selarea 

   IF self.nfields GT 0 THEN self->time_series::cleanup

END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO grid__define

  structure  = {grid, $
				nlat     : 0L,  $
				nlon     : 0L,  $
				latlon   : [0.,0.,0.,0.],  $
				lat      : PTR_NEW(), $
				lon      : PTR_NEW(), $
				selarea  : PTR_NEW(), $
                INHERITS time_series  $
			   } 

END
