;+
; NAME:
;	CAPE_FIELD
; PURPOSE:
;	CAlculate maximum convective available potential energy (CAPE)
;       for a 2-dimensional input field. The first index is a
;       geographical index (e.g. lat or lon) and the second index is
;       the vertical level index. For an example see program
;       calc_cape.
;
; 	The calculation is based on program calcsound of Kerry Emanuel
;       but has been simplified and vectorized (both leading to a
;       considerable improvement in CPU performance).
;
;
; INPUT PARAMETERS:
;   P: FltArr(M,N): pressures (hPa) at M latitudes and N levels
;   T: FltArr(M,N): Temperatures (K) at M latitudes and N levels
;   R: FltArr(M,N): Water vapor mixing ratio R (kg H2O per kg of dry
;   air) at M latitudes and N levels
;   Note: Relation between R and specific humidity S: R=S/(1-S)
;
;  OUTPUT PARAMETERS:
;  Funtion returns an M element vector of the maximum convectively 
;  available potential energy in the column at M different latitudes.
;  CAPEP: FltArr(M) CAPE of each air parcel
;        (for unstable conditions CAPEP has typically a value of 3000)
;  NAP: FltArr(M) Negative area: A useful measure for the barrier
;
; EXAMPLE:
; 	PRES=[ 1000., 850., 700., 500.,  300.,  200.,  100.] ; pressures
;	TEMP=[ 30.,  20.,  10., -10.,  -40.,  -60.,  -70.] ; temp (Celsius)
;	DEWPT=[  15.,  10.,   4., -20.,  -60., -90., -110.] ; dew points (Celsius) 
;	R=MIXR_SAT(dewpt,pres)/1000.
; or    R=[0.0107849,0.00911408,0.00731244,0.00156797,4.04480e-05,7.08816e-07,2.71149e-08]
;	print,cape(pres,temp+273.15,R)
; HISTORY:
; 	Dominik Brunner, ETH Zurich, Jun 2000: converted to IDL, vectorized,
;		and speeded up considerably
; 	The calculation is based on program calcsound of Kerry Emanuel
;       but has been simplified and vectorized (both leading to a
;       considerable improvement in CPU performance).
;-

FUNCTION  ESA,TC
; water vapor saturation pressure (hPa) at temperature TC
return,6.112*EXP(17.67*TC/(243.5+TC))
END


FUNCTION CAPE_FIELD,P,T,R,CAPEP=CAPEP,NAP=NAP,TLP=TLP,TLVP=TLVP,TVPDIF=TVPDIF

; check for input
IF n_params() LT 3 THEN BEGIN
   message,'Usage: Cape,p,T,R'
   return,-1
ENDIF

s=size(P)

IF (s[0] EQ 3) AND (s[1] EQ 1) THEN BEGIN
   P=reform(P,s[2],s[3])
   T=reform(T,s[2],s[3])
   R=reform(R,s[2],s[3])
ENDIF ELSE IF s[0] NE 2 THEN BEGIN
   print,'Error: arrays must be 2 dimensional (latitudes x levels)'
   return,-1
ENDIF

s=size(P)
M=s[1] & N=s[2]	; number of latitudes and levels
IF (n_elements(T) NE (M*N)) OR (n_elements(R) NE (M*N)) THEN BEGIN
   print,'Error: arrays p,T,R must have same size'
   return,-1
ENDIF

IF N EQ 0 THEN return,-1

TLP=fltarr(M,N,N)
TLVP=fltarr(M,N,N)
TVPDIF=fltarr(M,N,N)
NAP=fltarr(M,N)
PAP=fltarr(M,N)
CAPEP=fltarr(M,N)
CAPE=fltarr(M)

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
    RS=EPS*ES[*,I]/(P[*,I]-ES[*,I])
    ALV=ALV0-CPVMCL*TC[*,I]
    EM=(EV[*,i] GT 1.e-6)*EV[*,I]+(EV[*,i] LE 1e-6)*1e-6
    SP=CPD*ALOG(T[*,I])-RD*ALOG(P[*,I]-EV[*,I])+$
	ALV*R[*,I]/T[*,I]-R[*,I]*RV*ALOG(EM/ES[*,I])

;
;   ***   Find lifted condensation pressure PLCL    ***
;
    RH=R[*,I]/RS	; relative humidity
    RH=(RH LT 1.0)*RH+(RH GE 1.0) ; limit to 1.
    CHI=T[*,I]/(1669.0-122.0*RH-T[*,I])
    PLCL=(RH GT 0.0)*P[*,i]*RH^CHI+(RH LE 0.)

;
;   ***  Begin updraft loop   ***
;
    SUM=fltarr(M)
    RG0=R[*,I]
    TG0=T[*,I]
    FOR J=I,N-1 DO BEGIN
;
;   ***  Calculate estimates of the rates of change of the entropies  ***
;   ***           with temperature at constant pressure               ***
;  
        RS=EPS*ES[*,J]/(P[*,J]-ES[*,J])	; saturation mixing ratio
        ALV=ALV0-CPVMCL*TC[*,J]
        SLP=(CPD+RS*CL+ALV*ALV*RS/(RV*T[*,J]*T[*,J]))/T[*,J]
;   
;   ***  Calculate lifted parcel temperature TLP  ***
;
        ; BOK is a boolean flag for levels below LCL
        ; Below LCL the lifted parcel temperature TLP is calculated
        ; for an adiabatic ascent.
        ; Above LCL the lifted parcel temperature TLP is calculated 
        ; iteratively for a pseudo-adiabatic ascent
        BOK=P[*,J] GE PLCL
        
        ;
        ;  Iteratively calculate lifted parcel temperature TG and mixing
        ;  ratios RG for pseudo-adiabatic ascent above LCL
        ;
        TG=T[*,J]
        RG=RS ; start with saturation mixing ratio
        FOR K=1,7 DO BEGIN
	   CPW=(J GT 0)*( SUM+CL*0.5*(RG0+RG)*(ALOG(TG)-ALOG(TG0)) )
           EM=RG*P[*,J]/(EPS+RG)
           ALV=ALV0-CPVMCL*(TG-273.15)
           SPG=CPD*ALOG(TG)-RD*ALOG(P[*,J]-EM)+CPW+ALV*RG/TG
           TG=TG+(SP-SPG)/SLP  
	   ENEW=ESA(TG-273.15)
           RG=EPS*ENEW/(P[*,J]-ENEW)           
        ENDFOR ; K
        
        TLP[*,I,J]=BOK*T[*,I]*(P[*,J]/P[*,I])^(RD/CPD)+(1-BOK)*TG
        TLVP[*,I,J]=BOK*TLP[*,I,J]*(1.+R[*,I]/EPS)/(1.+R[*,I])+$
            (1-BOK)*TG*(1.+RG/EPS)/(1.+RG)
        TVPDIF[*,I,J]=TLVP[*,I,J]-T[*,J]*(1.+R[*,J]/EPS)/(1.+R[*,J])
        RG0=BOK*RG0+(1-BOK)*RG
        TG0=BOK*TG0+(1-BOK)*TG
        SUM=BOK*SUM+(1-BOK)*CPW
    ENDFOR ; J
    
;
;  ***  Find positive and negative areas PA and NA and
;       CAPE (=PA-NA) from pseudo-adiabatic ascent ***
;

;
;   ***  Find lifted condensation level and maximum level   ***
;   ***               of positive buoyancy                  ***
;
    INBP=intarr(M) ; index of maximum level of positive buoyancy
    FOR J=(N-1),I,-1 DO BEGIN
       BOK=(TVPDIF[*,I,J] GT 0.0) AND (J GT INBP) ; boolean
       INBP=BOK*J+(1-BOK)*INBP
       ; set TVPDIF to zero above INBP
       ind=WHERE(J GT INBP,count)
       IF count GT 0 THEN TVPDIF[ind,I,J]=0.
    ENDFOR
    
    ;
    ;****  Do updraft loops ****
    ;
    FOR J=(I+1),(N-1) DO BEGIN
;       BOK=(J LE INBP)
       TVM=0.5*(TVPDIF[*,I,J]+TVPDIF[*,I,J-1]) ;*BOK
       PM=0.5*(P[*,J]+P[*,J-1])
       BOK=TVM LE 0.
       NAP[*,I]=NAP[*,I]-BOK*RD*TVM*(P[*,J-1]-P[*,J])/PM
       PAP[*,I]=PAP[*,I]+(1-BOK)*RD*TVM*(P[*,J-1]-P[*,J])/PM
    ENDFOR
    CAPEP[*,I]=PAP[*,I]-NAP[*,I]
    BOK=CAPEP[*,I] GT CAPE
    CAPE=BOK*CAPEP[*,I]+(1-BOK)*CAPE
ENDFOR	; loop over air parcel origins

return,cape

END
