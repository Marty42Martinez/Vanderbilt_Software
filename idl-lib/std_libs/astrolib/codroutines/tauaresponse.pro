function TauAresponse, alt, az, jd, chan, alignment, verbose=verbose

; az : array of az pointing positions
; alt : array (or scalar) of alt pointing positions

; Tau A Parameters
taupos = {eqloc, ra: 83.635, dec:22.017}
tauint = {j1: 1.2, j2: 1.2, j3: 1.2} ; brightness temp in Kelvin
sigtau = 2./60. * 0.424661

v = keyword_set(verbose)

fwhm_x = 24. /60.   ; fwhm of the beam in x and y
fwhm_y = 19. / 60.
sx = 0.424661 * fwhm_x
sy = 0.424661 * fwhm_y

naz = n_elements(az)
nalt = n_elements(alt)
if naz gt 1 then if nalt eq 1 then alt_ = fltarr(naz) + alt else alt_ = alt
if nalt gt 1 then if naz eq 1 then az_ = fltarr(nalt) + az else az_ = az
nobs = n_elements(alt_)
if n_elements(alt_) ne n_elements(az_) then begin
	print, 'Error: N_el(alt) ne N_el(az)!!!'
	return, -1
endif


; FIND ALT-AZ POSITIONS of Tau A
eq2hor, taupos.ra, taupos.dec, jd, tau_alt, tau_az

; Evaluate each convolution individually
; np : number of pixels along one dimension (az or el)
mlat_b = 1
mlon_b = 1
d2r = !pi/180.

;source parameters
sxs = 2./60. * .424661
sys = 2./60. * .424661
mlat_s = 0.1
mlon_s = 0.1


;***********************************************************
; GET THE BEAM FUNCTION
np = 300
B = fltarr(np,np)
lat = fltarr(np,np)
lon = fltarr(np,np)
lati = lat ; lat index
loni = lon ; lon index

for i = 0,np-1 do begin
	lat[i,*] = (float(i)/np - 0.5) * 5
	lon[*,i] = (float(i)/np - 0.5) * 5
	lati[i,*] = i
	loni[*,i] = i
endfor

; Beam, Fast Method
wb = where( (abs(lat) LT mlat_b) AND (abs(lon) LT mlon_b) )
dlatb = reform(lat[wb])
dlonb = reform(lon[wb])

tot = fltarr(nobs)


if v then begin
progressBar = Obj_New("SHOWPROGRESS", message='Processing Tau A Response',color='GREEN')
progressBar->Start
endif

for p = 0,nobs-1 do begin
	B = B*0.
	mc = 0.5 * ( cos((lat[wb]+alt[p])*d2r) + cos(alt[p]*d2r) )
	B[loni[wb]*np + lati[wb]] = exp(-0.5 * ((dlatb/sx)^2 + (mc*dlonb/sy)^2))
	B = B/total(B)


	; METHOD 1 (fast method)
	; now get the source function
	S = fltarr(np,np)
	w = where( (abs(lat+alt[p]-tau_alt[p]) LT mlat_s) AND (abs(lon+az[p]-tau_az[p]) LT mlon_s) )
	mcs = cos(tau_alt[p]*d2r)

	if w[0] ne -1 then begin
		dlat = reform(lat[w]+alt[p] - tau_alt[p])
		dlon = reform(lon[w]+az[p] - tau_az[p])
		S[loni[w]*np + lati[w]] = 1.2 * exp(-0.5 * ((dlat/sxs)^2 + (mcs*dlon/sys)^2))
	END

	; Now total the fast way: Answer = tot
	if w[0] ne -1 then tot[p] = total ( B[w] * S[w] * cos((lat[w]+alt[p])*d2r) ) else tot[p] = 0.

	if v then progressBar->Update, fix((p+1.)/float(nobs)*100)
endfor

if v then begin
 progressBar->Destroy
 Obj_Destroy, progressBar
endif

return, tot

end