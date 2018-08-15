function co_refract3, a, altitude=altitude, wave=wave, P=P, T=T, RH=RH,lat=lat, radio=radio

; to do the neutral atmosphere effect on the radio refraction
; a is the altitude (degrees)

if n_elements(altitude) eq 0 then altitude = 0. ; [km]
if n_elements(P) eq 0 then P = 1010.*(1-6.5/288000*altitude)^5.255 ; [mbar]
if n_elements(RH) eq 0 then RH = 0. ; [percent]
if n_elements(T) eq 0 then begin
	if altitude GT 11000 then T = 211.5 else T = 283.0 - 0.0065*altitude
endif
if n_elements(lat) eq 0 then lat = 45.0
if n_elements(wave) eq 0 then wave = 0.56 ; micronsp
d2r = !dpi/180.
z = (90. - a) * d2r ; zenith angle [radians]

if RH NE 0. then begin
	es = 6.105 * exp(25.22 * (T-273.)/T - 5.31*alog(T/273.))
	e = es * RH/100. / (1 - (1-RH/100.)*es/P)
endif else e = 0. ; e is the partial pressure due to H20 in millibars.

;***************************************
; RADIO FORMULA, Accurate below 100 GHz
N = 77.6 * P/T + 3.73e5 * e/T^2 ; n-1 * 10^6, where n is index of refraction


;****************************************
; OPTICAL FORMULA, Accurate for 230 nm to 2059 nm.
Ds = (1+P*(57.9e-8 - 9.325e-4/T + 0.25844/T^2))*P/T
Dw = (1+e*(1+3.7e-4*e)*(-2.37321e-3 + 2.23355/T -710.792/T^2 + 7.75141e4/T^3))*e/T
s = 1.0/wave ; wavenumber in inverse microns
; below is (n-1)*10^6.  Slightly more complicated for optical!
if not(keyword_set(radio)) then $
N = (23.7134 + 6839.397/(130.-s^2) + 45.473/(38.9-s^2))*Ds + $
	(64.8731 + 0.58058*s^2 - .007115*s^4 + 0.0008851*s^6)*Dw
;print, N
beta = 0.001254*T/273.15
kappa = 1 + 0.005302*sin(lat*d2r)^2-0.00000583*sin(2*lat*d2r)^2 $
	    - 0.000000315*altitude

N = N * 1e-6
R = kappa*N*(1-beta)*tan(z) - kappa*N*(beta-N/2)*tan(z)^3 ; refraction [radians]
R = R / d2r ; degrees
return, R


END