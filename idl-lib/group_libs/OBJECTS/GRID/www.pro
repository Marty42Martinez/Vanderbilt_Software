lon=FINDGEN(10000)/10000.*89.
lat=FINDGEN(10000)/10000.*89.
dat=FINDGEN(10000)^2.0       
o=OBJ_NEW('grid')
o->points_to_grid,dat,lat,lon,'asd'
q=o->temporal_mean(/data)          
tvscl,q

END
