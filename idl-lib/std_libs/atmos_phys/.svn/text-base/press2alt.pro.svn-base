;+
; NAME:
;	press2alt
;
; PURPOSE:
;	Convert an array of pressures (hPa) into an array of altitudes (m) 
;	or vice versa using the ICAO standard atmosphere.
;
;       See <A HREF="http://www.pdas.com/coesa.htm">exact definition
;       here<\A>
;       
;       The 7 layers of the US standard atmosphere are:
;
;        h1   h2     dT/dh    h1,h2 geopotential alt in km
;         0   11     -6.5     dT/dh in K/km
;        11   20      0.0
;        20   32      1.0
;        32   47      2.8
;        47   51      0.0
;        51   71     -2.8   
;        71   84.852 -2.0
;	
; CATEGORY:
;	atmospheric physics, avionics
;
; CALLING SEQUENCE:
;	press2alt(var,/invert)
;
; EXAMPLE:
;	press2alt([200,300,400])
;
; INPUTS: 
;	var	flt or fltarr: the ambient air pressure or the altitude
;
; OPTIONAL INPUT PARAMETERS:
;
; KEYWORD INPUT PARAMETERS:
;	invert	if set the program calculates pressures from an array
;		of altitudes
;
; OUTPUTS
;	the altitude array (or pressure array if keyword /invert is used)
;
; COMMON BLOCKS:
;
; SIDE EFFECTS: 
;
; RESTRICTIONS:
;	
; PROCEDURE:
;	
; MODIFICATION HISTORY:
;	first implementation Jan, 17 1997 by Dominik Brunner
;-
FUNCTION press2alt,var,invert=invert
   
limits=[0,11,20,32,47,51,71.,84.852]*1000.   ; layer boundaries in m
lrs=[-6.5,9,1,2.8,9,-2.8,-2.0]/1000.         ; lapse rates in each layer (9 means 0)
iszero=[0,1,0,0,1,0,0]                       ; flag for isothermal layers

G=9.80665	; gravity const.
R=287.053	; gas const. for air
GMR=G/R         ; Hydrostatic constant

; calculate pressures at layer boundaries
pB=FltArr(8)
TB=FltArr(8)
pB[0]=1013.25 ; pressure at surface
TB[0]=288.15  ; Temperature at surface

; loop over layers and get pressures and temperatures at level tops
;print,TB[0],pB[0]
FOR i=0,6 DO BEGIN
   TB[i+1]=TB[i]+(1-iszero[i])*lrs[i]*(limits[i+1]-limits[i])
   pB[i+1]=(1-iszero[i])*pB[i]*exp(alog(TB[i]/TB[i+1])*GMR/lrs[i])+$
      iszero[i]*PB[i]*exp(-GMR*(limits[i+1]-limits[i])/TB[i])
;   print,TB[i+1],pB[i+1]
ENDFOR

; now calculate which layer each value belongs to
layer=IntArr(n_elements(var))
IF keyword_set(invert) THEN BEGIN
   FOR i=0L,n_elements(var)-1 DO BEGIN
      index=WHERE( (limits-var[i]) GT 0)
      layer[i]=index[0]-1
   ENDFOR
   ; calculate the corresponding pressures
   return,iszero[layer]*pB[layer]*exp(-GMR*(var-limits[layer])/TB[layer])+$
      (1-iszero[layer])*pB[layer]*(TB[layer]/$
      (TB[layer]+lrs[layer]*(var-limits[layer])))^(GMR/lrs[layer])
ENDIF ELSE BEGIN
    FOR i=0L,n_elements(var)-1 DO BEGIN
      index=WHERE( (var[i]-pB) GT 0)
      layer[i]=index[0]-1
   ENDFOR
   ; calculate the corresponding altitudes
   return,iszero[layer]*(-ALOG(var/pB[layer])*TB[layer]/GMR+limits[layer])+$
          (1-iszero[layer])*((TB[layer]/((var/pB[layer])^(lrs[layer]/GMR))-$
                             TB[layer])/lrs[layer]+limits[layer])
ENDELSE

END
