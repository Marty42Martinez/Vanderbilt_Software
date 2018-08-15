; NAME
;	de2h
;
; PURPOSE
;	Equatorial to horizon coordinates:  HA,Dec to Az,El
;
; CALLING SEQUENCE
;	DE2H, Ha, Dec, Phi, Az, El
;
; INPUT
;	Ha	hour angle, radians
; 	Dec 	declination, radians
;	Phi	latitude of observer, radians
;
; OUTPUT
;	Az	azimuth, radians
;	El	elevation, radians
;
;	*** ALL ARGUMENTS IN RADIANS ***
;
; adapted from a C version of slaDe2h, John Keck, May 1998

PRO de2h, ha, dec, phi, az, el

; Useful trig functions
   sh = SIN ( ha );
   ch = COS ( ha );
   sd = SIN ( dec );
   cd = COS ( dec );
   sp = SIN ( phi );
   cp = COS ( phi );

; Az,El as x,y,z
   x = - ch * cd * sp + sd * cp;
   y = - sh * cd;
   z = ch * cd * cp + sd * sp;

; To spherical */
   r = SQRT ( x * x + y * y );
;   a = ( r == 0.0 ) ? 0.0 : atan2 ( y, x ) ;
   IF r EQ 0 THEN az = 0. ELSE az = ATAN(y,x)
;   *az = ( a < 0.0 ) ? a + D2PI : a;
   IF az LT 0 THEN az = az + 2*!pi
;   *el = atan2 ( z, r );
   el = ATAN( z, r )

RETURN
END

;----------------------------------------------------------------------
;+
; NAME
;	RD2AZEL
;
; PURPOSE
;	convery RA and Dec to Azimuth and Elevation
;	(equatorial to horizon coordinates)
;
; CATEGORY
;	astronomical tool
;
; CALLING SEQUENCE
;
;	RD2AZEL, Ra, Dec, U_time, Lon, Lat, Az, El
;
; INPUT
;	Ra	decimal hours
;	Dec	decimal degrees of arc
;	U_time	time structure with tags:
;		(year, month, day, hour, minute, sec)
;		in appropriate units
;	Lon	degrees E
;	Lat	degrees N
;
; OUTPUT
;	Az	azimuth, degrees
;	El	elevation, degrees
;
;	***** ALL ARGUMENTS IN DEGREES, *****
;	** EXCEPT R.A., WHICH IS IN HOURS ***
;	*** (u_time tags have own units) ****
;
;	all arguments are scalars in this version
;
; EXAMPLE
;	lat = -23.8 & lon = 133.40	; Alice Springs, NT
;	ra = 18.020083 & dec = -25.743333 ; GRS 1758-258 for epoch 2000
;	u_time = {UT, year: 1995 $
;		, Month: 10 $
;		, day: 17 $
;		, hour: 5, minute: 43, sec: 0.0}
;
;	RD2AZEL,ra,dec,u_time,lon,lat,az,el
;	PRINT, az, el
;	      100.147      66.4507
;
; REQUISITES
;	DE2H (included in this module)
;	standard IDL astronomy library
;	    (viz. JULDATE, JDCNV, CT2LST)
;
; TBD
;	make it accept vector arguments
;
; HISTORY
; 	Written by: John Keck (jwk@phys.columbia.edu),
; 			Columbia Astrophysics Lab, May 1998
;
;-
PRO rd2azel, ra,dec,jd,lon,lat,az,el $
	,HELP=help

IF KEYWORD_SET(help) THEN BEGIN
	DOC_LIBRARY,"rd2azel"
	RETURN
ENDIF

IF N_PARAMS() EQ 0 THEN BEGIN
	PRINT,"Calling sequence--"
	PRINT
	PRINT,"RD2AZEL, Ra, Dec, U_time, Lon, Lat, Az, El"
	PRINT
	PRINT,"    All arguments in degrees,"
	PRINT,"    except Ra, which is in hours"
	PRINT,"    U_time = {year, month, day, hour, minute, sec}"
	PRINT
	PRINT,"For additional help, type rd2azel,/help."
	RETURN
ENDIF

;	c60 = 1./[1,60,3600]

;	ut = TOTAL([u_time.hour,u_time.minute,u_time.sec]/[1.,60.,3600.])
;	ut = REFORM([[u_time.hour],[u_time.minute],[u_time.sec]]#c60)
;	JULDATE,[u_time.year,u_time.month,u_time.day],rjd2
;	JDCNV, u_time.year,u_time.month,u_time.day,0,jd
	CT2LST, gmst $		; output
		, 0 $		; longitude for Greenwich
		, 0 $		; time zone
		, jd;+ut/24.		; Julian date
;	gmst2 = LMST(jd, ut, 0)
	gmst = gmst *(15*!dtor)
;	IF !debug THEN HELP,jd,gmst
	eqeqx_corr = 0	; approx.
 	hour_angle=(gmst + lon*!dtor + eqeqx_corr - ra*15*!dtor);
;	IF !debug THEN HELP,hour_angle
	DE2H,hour_angle,dec*!dtor,lat*!dtor,az,el
	az = az*!radeg
	el = el*!radeg
RETURN

END
