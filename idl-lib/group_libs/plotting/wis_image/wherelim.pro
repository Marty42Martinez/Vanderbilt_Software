function wherelim, lim_, lat, lon, mask_=mask_

if (n_elements(lon) eq 0 AND size(lat, /type) eq 8) then begin
	lat_ = lat.lat
	lon_ = lat.lon
endif else begin
	lat_ = lat
	lon_ = lon
endelse

; first get lim from -180 to 180
lim = lim_
if lim[2] GT 180. then lim[2] = lim[2] - 360.
if lim[3] GT 180. then lim[3] = lim[3] - 360.

; this is to account for limit ranges that cross +-180....
watchit=0
if lim[2] GT lim[3] then begin
  asd = lim[2]
  lim[2] = lim[3]
  lim[3] = asd 
  watchit = 1
endif

w = where(lon_ GT 180.)
if w[0] ne -1 then lon_[w] = lon_[w] - 360.

IF watchit EQ 0 THEN BEGIN
mask = (lat_ GE lim[0] AND lat_ LE lim[1] AND $
       lon_ GE lim[2] AND lon_ LE lim[3] )
ENDIF ELSE BEGIN
mask = (lat_ GE lim[0] AND lat_ LE lim[1] AND $
       (lon_ LE lim[2] OR lon_ GE lim[3]) )
ENDELSE

if keyword_set(mask_) then return, mask else return, where(mask)

END
