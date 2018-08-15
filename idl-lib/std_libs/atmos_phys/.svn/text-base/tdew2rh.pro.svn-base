;+
; NAME:
;        tdew2rh (function)
;
; PURPOSE:
;        calculate relative humidity from temperature and
;        dew/frostpoint
;
; CATEGORY:
;        atmospheric physics
;
; CALLING SEQUENCE:
;        tdew2rh(dewpoint, temperature [,/ice])
;
; INPUTS:
;        dewpoint:  dewpoint (or frostpoint) temperature in K
;        temperature: dry air temperature
;
; KEYWORD PARAMETERS:
;        /ice: calculate RH over ice (i.e. parameter dewpoint is the 
;                                     frostpoint temperature)
;
; OUTPUTS:
;        The relative humidity in percent, per default over water.
;        Use keyword /ice to calculate RH over ice
;
; SUBROUTINES:
;
; REQUIREMENTS:
;        functions esat or eice are called
;
; NOTES:
;
; EXAMPLE:
;        PRINT,TDEW2RH(266.,278.)
;
;        IDL prints:   41.4439
;
; MODIFICATION HISTORY:
;        Dominik Brunner, 10 Aug 2001.
;-
FUNCTION tdew2rh, tdew, t, ice=ice
 
;IF (tdew[0] GT T[0]) THEN BEGIN
;  print,"ERROR in tdew2rh: dew-/frostpoint greater than static air temperature"
;  return,-1
;END

IF keyword_set(ice) THEN BEGIN
   e=eice(tdew) 
   es=eice(t)
ENDIF ELSE BEGIN
   e=esat(tdew)
   es=esat(t)
ENDELSE

return,e/es*100.

END
