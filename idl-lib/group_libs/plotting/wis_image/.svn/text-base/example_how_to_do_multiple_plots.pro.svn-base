;get some dummy lats and longs...


lat = RANDOMU(seed,1000)*180.-90. 
lon = RANDOMU(seed,1000)*360.-180.
dat = (lat+90)/MAX(lat+90)*250.

X2ps,'asd.ps',bits=8 ; open 8 bit psotscript device

!P.CHARSIZE=1.0

; North Pole....
wis_image,dat,lat,lon,mag=2,proj='Stereographic',limit=[60,90,-180,180],/horizon,center=[90,0],/isotropic, $ ; map projection
         glinest=1,gcolor=255-!P.background,londel=45,latdel=15, $    ; grid                
         missing=!P.background,              $    ; make sure background is white
         mini=0,maxi=250,ctable = 2,       $      ; set limits for colr bar (can be suppressed with /no_colobar
         /bhorizontal,bpos=[0.05,0.24,0.45,0.28], $         ; colorbar
         position=[0.05,0.1,0.45,0.9],/normal     ; where to plot the whole thing 
XYOUTS,0.15,0.18,'BAR TITLE I',/normal

map_continents,/hires,thick=1
          
; South Pole.....          
wis_image,dat,lat,lon,mag=2,proj='Stereographic',limit=[-90,-60,-180,180],/horizon,center=[-90,0],/isotropic, $ ; map projection
         glinest=1,gcolor=255-!P.background,londel=45,latdel=15, $    ; grid                
         missing=!P.background,              $    ; make sure background is white
         mini=0,maxi=250,ctable = 2,       $      ; set limits for colr bar (can be suppressed with /no_colobar
         /bhorizontal,bpos=[0.55,0.24,0.95,0.28],    $  ; color bar
         position=[0.55,0.1,0.95,0.9],/normal,/noerase ; where to plot the whole thing 
XYOUTS,0.65,0.18,'BAR TITLE II',/normal
         
map_continents,/hires,thick=1


XYOUTS,0.4,0.75,'Some other text',/normal

PS2X,/convert  ; convert postscript to png 

END
