function slow_congrid, map, lat1, lon1, lat2, lon2

; requires going for a higher-res map to a lower-res map!
; 1 : hi-res
; 2 : lo-res
Nlon1= n_elements(lon1)
Nlat1= n_elements(lat1)
nlon2 = n_elements(lon2)
nlat2 = n_elements(lat2)

dlat1 = lat1[1] - lat1[0]
dlat2 = lat2[1] - lat2[0]
dlon1 = lon1[1] - lon1[0]
dlon2 = lon2[1] - lon2[0]

gx = round( nlon1/float(2*nlon2) + 1 ) ;# of pixels to go in lon direction
gy = round( nlat1/float(2*nlat2) + 1 ) ;# of pixels to go in lat direction

out = fltarr(nlon2, nlat2)

lat_1 = fltarr(2*gx+1, 2*gy+1)
lon_1 = fltarr(2*gx+1, 2*gy+1)

for j=0,nlon2-1 do begin
	dum = min(abs(longitude_difference(lon1, lon2[j])), j1) ; location of closest hi-res lon to this lo-res lon
	for i=0,nlat2-1 do begin
		f = fltarr(2*gx+1, 2*gy+1)
		dum = min(abs(lat1-lat2[i]), i1) ; location of closest high-res lat to this low-res lat
		; now create a small 2D array of possible overlapping points

		a = (i1-gy) > 0
		b = (i1+gy) < (nlat1-1)
		for k=a,b do lat_1[*, k-i1+gy] = lat1[k]
		sub = fltarr(2*gx+1, b-a+1)

		lon_0 = lon2[j]
		lat_0 = lat2[i]
		nab = b-a+1
		ao = a - (i1-gy)
		bo = ao+nab-1
		for k = -gx, gx do begin
			 l = k + j1
			 if l LT 0 then l = nlon1+l
			 if l GE nlon1 then l = l - nlon1
			 lon_1[k+gx,*] = lon1[l]
			 sub[k+gx,*] = map[l, a:b]
		endfor

		f = area_overlap(lon_0, lat_0, dlon2, dlat2, lon_1[*,ao:bo], lat_1[*,ao:bo], dlon1, dlat1)
		out[j,i] = total(f*sub) / total(f)
	endfor
endfor

return, out

END