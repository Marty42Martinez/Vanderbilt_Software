;+
; NAME:
;	rh2mixr.pro
;
; PURPOSE:
;	Convert relaitve humidity (%) over liquid water or optionally
;       over ice into mixing ratio (g H2O per kg of dry air) given
;       temperature and pressure.
;   
; CATEGORY:
;	atmospheric physics
;
; CALLING SEQUENCE:
;	result=rh2mixr(rh,p,T)
;
; EXAMPLE:
;       rh=(findgen(5)+1)*20
;	print,rh2mixr(rh,1013.,273.15)
;         prints     0.750788      1.50339      2.25781      3.01407      3.77215
;
; INPUTS:
;	RH: Float or FltArr(n) relative humidity in percent
;       p : Float or FltArr(n) ambient pressure in hPa
;       T : Float or FltArr(n) ambient Temperature in C or K
;
; OPTIONAL INPUT PARAMETERS:
;
; KEYWORD INPUT PARAMETERS:
;     /ice  : set keyword if RH is over ice
;
; OUTPUTS:
;	returns the mixing ratio as g H2O per kg of dry air
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
;
;  Dominik Brunner (brunner@atmos.umnw.ethz.ch), August 2001
;
;  Derivation:
;                                      Mw*e              e
;  W (mixing ration) = m_h2o/m_dry = -------- = Mw/Md * --- *1000
;                                    Md*(p-e)           p-e
;
;  RH (rel. hum.)    = e/esat(T)*100
;
;  Thus: W = Mw/Md*U*esat(T)/(p-U*esat(T))*1000, 
;        where U=RH/100
;
;-
FUNCTION  rh2mixr,RH,p,T, ice=ice
   ; check for input
   ON_ERROR,2
   IF n_params() NE 3 THEN message,'Usage: rh2mixr(RH,p,T)'
   ; note east accepts temperature in deg C or in Kelvin
   IF keyword_set(ice) THEN es=eice(T) ELSE es=esat(T)
   Mw=18.0160 ; molecular weight of water
   Md=28.9660 ; molecular weight of dry air
   return,Mw/Md*RH/100.*es/(p-RH/100.*es)*1000.
END
