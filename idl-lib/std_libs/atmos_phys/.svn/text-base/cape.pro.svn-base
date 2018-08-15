;+
; NAME:
;	CAPE
; PURPOSE:
;	CAlculate maximum convective available potential energy (CAPE)
;       for either
;       - a vertical sounding of pressure, temperature and mixing ratio
;       - a 3-dimensional input field of pressure, temperatures and
;         mixing ratios. The output is a 2D cape field in this case.
;
;       The program checks for the input dimensions and either calls 
;       cape_sound or cape_field.
; 
; INPUT PARAMETERS:
;   P: FltArr(nz) or FltArr(nx,ny,nz): pressures (hPa)
;   T: FltArr(nz) or FltArr(nx,ny,nz): Temperatures (K)
;   R: FltArr(nz) or FltArr(nx,ny,nz): Water vapor mixing ratios R
;                                      (kg H2O per kg of dry air)
;   Note: Relation between R and specific humidity S: R=S/(1-S)
;
;  OUTPUT PARAMETERS:
;  Funtion returns maximum convectively available potential energy.
;  If input is a sounding the output is a scalar.
;  If input is a 3D distribution the output is a 2D field.
;
;  NAP: Same dimension as cape:  Negative area, a useful measure for the barrier
;
; EXAMPLE:
; 	PRES=[ 1000., 850., 700., 500.,  300.,  200.,  100.] ; pressures
;	TEMP=[ 30.,  20.,  15., 0.,  -40.,  -60.,  -70.] ; temp (Celsius)
;	DEWPT=[  25.,  18.,   14., -20.,  -60., -90., -110.] ; dew points (Celsius) 
;	R=MIXR_SAT(dewpt,pres)/1000.
; or    R=[0.0107849,0.00911408,0.00731244,0.00156797,4.04480e-05,7.08816e-07,2.71149e-08]
;	print,cape(pres,temp+273.15,R)
; HISTORY:
; 	Dominik Brunner, ETH Zuerich, Jun 2000
;-
FUNCTION cape,P,T,R

; IF input fields are 3D then calculate a 2D field of cape
s=size(p)
np=n_elements(p)
IF n_elements(T) NE np THEN return,-1
IF n_elements(R) NE np THEN return,-1
IF max(T) LT 105. THEN T0=273.15 ELSE T0=0.

; find dimension with more than 1 elements
count=0
FOR i=1,s[0] DO BEGIN
   count=count+(s[i] GT 1)
   CASE count OF
      1: dimx=i
      2: dimy=i
      3: dimz=i
      else:
   ENDCASE
ENDFOR

IF count EQ 1 THEN return,cape_sound(P,T+T0,R)
IF count NE 3 THEN BEGIN
   print,'invalid field dimensions (must be either 1D or 3D)'
   return,-1
ENDIF

capefield=fltarr(s[dimx],s[dimy])

P=reform(P,s[dimx],s[dimy],s[dimz])
T=reform(T,s[dimx],s[dimy],s[dimz])
R=reform(R,s[dimx],s[dimy],s[dimz])

FOR i=0,s[dimx]-1 DO BEGIN
    print,'processing longitude index ',i,' of',s[dimx]-1
    capefield[i,*]=cape_field(P[i,*,*],T[i,*,*]+T0,R[i,*,*])
ENDFOR
return,capefield

END
