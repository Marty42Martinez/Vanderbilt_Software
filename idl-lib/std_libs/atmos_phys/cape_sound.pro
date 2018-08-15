;+
; NAME:
;	CAPE_SOUND
; PURPOSE:
;	CAlculate maximum convective available potential energy (CAPE)
;       for a vertical sounding of pressure, temperature and mixing
;       ratio.
;
; INPUT PARAMETERS:
;   P: pressures (hPa) at the N levels
;   T: Temperatures (K) at the N levels
;   R: Water vapor mixing ratio R (kg H2O per kg of dry air) at the N levels
;   Note: Relation between R and specific humidity S: R=S/(1-S)
;
;  OUTPUT PARAMETERS:
;  Funtion returns maximum convectively available potential energy
;  in the column
;  CAPEP: CAPE of each air parcel
;        (for unstable conditions CAPEP has typically a value of 3000)
;  NAP: Negative area: A useful measure for the barrier
;
; EXAMPLE:
; 	PRES=[ 1000., 850., 700., 500.,  300.,  200.,  100.] ; pressures
;	TEMP=[ 30.,  20.,  15., 0.,  -40.,  -60.,  -70.] ; temp (Celsius)
;	DEWPT=[  25.,  18.,   14., -20.,  -60., -90., -110.] ; dew points (Celsius) 
;	R=MIXR_SAT(dewpt,pres)/1000.
; or    R=[0.0107849,0.00911408,0.00731244,0.00156797,4.04480e-05,7.08816e-07,2.71149e-08]
;	print,cape(pres,temp+273.15,R)
; HISTORY:
; 	Based on Fortran program calcsound of Kerry Emanuel
; 	Dominik Brunner, KNMI, Feb 2000: converted to IDL
;		and speeded up considerably
;-

FUNCTION  ESA,TC
; water vapor saturation pressure (hPa) at temperature TC
return,6.112*EXP(17.67*TC/(243.5+TC))
END


FUNCTION CAPE_SOUND,P,T,R,CAPEP=CAPEP,NAP=NAP,TLP=TLP,TLVP=TLVP,TVPDIF=TVPDIF
   
ON_ERROR,2

; check for input
IF n_params() LT 3 THEN BEGIN
   message,'Usage: Cape_sound,p,T,R'
   return,-1
ENDIF

N=n_elements(p)	; number of vertical levels
IF (n_elements(T) NE N) OR (n_elements(R) NE N) THEN BEGIN
   print,'Error: arrays p,T,R must have same size'
   return,-1
ENDIF

IF N EQ 0 THEN return,-1

TLP=fltarr(N,N)
TLVP=fltarr(N,N)
TVPDIF=fltarr(N,N)
CAPEP=fltarr(N)
NAP=fltarr(N)
PAP=fltarr(N)

;
;   ***   ASSIGN VALUES OF THERMODYNAMIC CONSTANTS     ***
;
CPD=1005.7	; specific head dry air
CPV=1870.0	; ?
CL=4190.0	; specific head water at 0deg
CPVMCL=2320.0	; ?
RV=461.5	; gas constant water vapor = R*/M_H2O
RD=287.04	; gas constant dry air = R*/M_dry
EPS=RD/RV
ALV0=2.501E6	; "Verdampfungswaerme"
T0=273.15

;
;  *** Water vapor pressure EV and saturation vapor pressure ES ***
;
TC=T-T0	; Celsius
EV=R*P/(EPS+R)	; vapor pressure
ES=ESA(TC)	; saturation vapor pressure

;
;   ***  Begin outer loop, which cycles through parcel origin levels I ***
;  
FOR I=0,N/3-1 DO BEGIN	; do calculation only for lowest N/3 levels

;
;   ***  Define the pseudo-adiabatic entropy SP (conserved variable) ***
;
    RS=EPS*ES[I]/(P[I]-ES[I])
    ALV=ALV0-CPVMCL*TC[I]
    EM=(EV[i] GT 1.e-6)*EV[I]+(EV[i] LE 1e-6)*1e-6
    SP=CPD*ALOG(T[I])-RD*ALOG(P[I]-EV[I])+$
	ALV*R[I]/T[I]-R[I]*RV*ALOG(EM/ES[I])

;
;   ***   Find lifted condensation pressure PLCL    ***
;
    RH=R[I]/RS	; relative humidity
    RH=(RH LT 1.0)*RH+(RH GE 1.0)
    CHI=T[I]/(1669.0-122.0*RH-T[I])
    PLCL=(RH GT 0.0)*P[i]*RH^CHI+(RH LE 0.)

;print,'PLCL:',p[i],plcl

;
;   ***  Begin updraft loop   ***
;
    SUM=0.0
    RG0=R[I]
    TG0=T[I]
    FOR J=I,N-1 DO BEGIN
;
;   ***  Calculate estimates of the rates of change of the entropies  ***
;   ***           with temperature at constant pressure               ***
;  
        RS=EPS*ES[J]/(P[J]-ES[J])	; saturation mixing ratio
        ALV=ALV0-CPVMCL*TC[J]
        SLP=(CPD+RS*CL+ALV*ALV*RS/(RV*T[J]*T[J]))/T[J]
;   
;   ***  Calculate lifted parcel temperature below its LCL   ***
;
        IF P[J] GE PLCL THEN BEGIN
           TLP[I,J]=T[I]*(P[J]/P[I])^(RD/CPD)
           TLVP[I,J]=TLP[I,J]*(1.+R[I]/EPS)/(1.+R[I])
           TVPDIF[I,J]=TLVP[I,J]-T[J]*(1.+R[J]/EPS)/(1.+R[J])
        ENDIF ELSE BEGIN
;
;   ***  Iteratively calculate lifted parcel temperature and mixing   ***
;   ***    ratios for pseudo-adiabatic ascent     ***
;
           TG=T[J]
           RG=RS
           FOR K=1,7 DO BEGIN
	       CPW=(J GT 0)*( SUM+CL*0.5*(RG0+RG)*(ALOG(TG)-ALOG(TG0)) )
               EM=RG*P[J]/(EPS+RG)
               ALV=ALV0-CPVMCL*(TG-273.15)
               SPG=CPD*ALOG(TG)-RD*ALOG(P[J]-EM)+CPW+ALV*RG/TG
               TG=TG+(SP-SPG)/SLP  
	       ENEW=ESA(TG-273.15)
               RG=EPS*ENEW/(P[J]-ENEW)           
  	   ENDFOR ; K
           TLP[I,J]=TG
           TLVP[I,J]=TG*(1.+RG/EPS)/(1.+RG)
           TVPDIF[I,J]=TLVP[I,J]-T[J]*(1.+R[J]/EPS)/(1.+R[J])
           RG0=RG
           TG0=TG
           SUM=CPW
        ENDELSE
    ENDFOR 	; J

;
;  ***  Find positive and negative areas  PA and NA and
;       CAPE (=PA-NA) from pseudo-adiabatic ascent ***
;

;
;   ***  Find lifted condensation level and maximum level   ***
;   ***               of positive buoyancy                  ***
;
;    ICB=N	; index of lifted cond level
    INBP=0	; index of maximum level of positive buoyancy
    FOR J=(N-1),I,-1 DO BEGIN
;        IF P[J] LT PLCL THEN ICB=MIN([ICB,J])
        IF TVPDIF[I,J] GT 0.0 THEN BEGIN
           INBP=(J GT INBP)*J+(J LE INBP)*INBP
	   GOTO,cont
	ENDIF
    ENDFOR
    cont:
    IMAX=(INBP GT I)*INBP+(INBP LE I)*I
    TVPDIF[I,IMAX:N-1]=0.	; set to zero for levels above IMAX
;
;   ***  Do updraft loops        ***
;
    IF INBP GT I THEN BEGIN
       FOR J=(I+1),INBP DO BEGIN
           TVM=0.5*(TVPDIF[I,J]+TVPDIF[I,J-1])
           PM=0.5*(P[J]+P[J-1])
           IF TVM LE 0.0 THEN $
              NAP[I]=NAP[I]-RD*TVM*(P[J-1]-P[J])/PM $
           ELSE $
              PAP[I]=PAP[I]+RD*TVM*(P[J-1]-P[J])/PM
       ENDFOR
       CAPEP[I]=PAP[I]-NAP[I]
    ENDIF ; else cape=0 if no free convection is possible
    
ENDFOR	; loop over air parcel origins

return,max(CAPEP)

END
