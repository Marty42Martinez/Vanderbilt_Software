;+
; NAME:      
;              rh_wetbulb
;
; PURPOSE:     Compute relative humidity from wet and dry bulb temperature
;              and pressure
;
; CALLING SEQUENCE:       result=rh_wetbulb(td,tw,p) 
;
; INPUT:      
;   t          ambient (dry bulb) temperature (celsius)
;   tw         wet bulb temperature           (celsius)
;   p          pressure                       (hPa)
;
; OUTPUT:
;   rh         relative humidity (partial pressure of water vapor divided
;              by the saturated water vapor pressure in percent)
;
; EXAMPLE:
;   
;              print,'the relative humidity is     ',rh_wetbulb(29,20,980)
;
;     References:
;
;     Tetans, O. 1930. Uber einige meteorologische Begriffe. Z. Geophys. 6:297-309
;
;     Weiss, A.1977. Algorithms for Calculation of Moist Air Properties on a Hand
;     Calculator. Trans. ASAE 20:1133-1136
;
; MODIFICATION HISTORY:
;  Dominik Brunner, 10 Aug. 2001: first version largely adapted from
;           Paul Richiazzi's program relhum.pro. Modifications were
;           made only to the values of the heat capacities of dry air 
;           and water vapor.
;-
FUNCTION rh_wetbulb,t,tw,p

;   ps  = saturated vapor pressure at ambient temperature  (mb)
;   pw  = saturated vapor pressure at wet bulb temperature (mb)
;   pa  = actual vapor pressure in                         (mb)
;
ON_ERROR,2
IF n_params() NE 3 THEN message,'Usage: result=rh_wetbulb(t,tw,p)'

ps = esat(t)
pw = esat(tw)

n=.62198
cpa=1.00467                 ; (J/deg C /g)  specific heat of dry air at constant p
cpv=1.8651                  ; (J/deg C /g)  specific heat of water vapor at constant p
L=2500.80-2.3668*tw         ; Latent heat of vaporization at tw (linear correction)
; saturation mixing ratio
ws = n * ps / (P - ps)
a=n*(cpa+cpv*ws)/(L*(n+ws)^2)
pa=pw-a*p*(t-tw)
tdew=alog(pa/61.078)/17.2693882
tdew=237.7*tdew/(1.-tdew)
;print,tdew
return, (pa/ps) * 100.

end
