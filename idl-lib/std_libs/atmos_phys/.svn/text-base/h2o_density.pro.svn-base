;+
; NAME:
;    h2o_density (function)
;
; PURPOSE:
;
;        Compute density of water vapor (in kg/m3) for given water
;        vapor partial pressure(s) e and temperature(s)
;
; CATEGORY:
;
;        Atmospheric physics, thermodynamics
;
; CALLING SEQUENCE:
;
;        h2o_density(e,T)
;
; INPUTS:
;
;        e     : Float or FltArr(n): water vapor partial pressures in hPa
;        T     : Float or FltArr(m): temperatures in Kelvin
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
;        Water vapor density in kg/m3. The result type will match
;        the type and array dimensions of p unless p is a scalar
;        and T an array.
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
;    print,h2o_density(3.25,273.15)*1000.
;    ; prints 2.57872 (g/m3)
;
;    e = findgen(5)+1.
;    print,h2o_density(e,273.15)*1000.
;    ; prints 0.793453      1.58691      2.38036      3.17381      3.96727
;
; MODIFICATION HISTORY:
;
;   (c) Dominik Brunner, Aug 2001: first implementation
;
;-
function h2o_density,e,T
   
   ; some constants
   Rv=461.40 ; Gas constant for water vapor
   
   ; create result depending on dimensions of e,T
   result = make_array(size=size([e]),value=-9999.)
   if (n_elements(e) eq 1 AND n_elements(T) gt 1) then  $
      result = make_array(size=size(T),value=-9999.)
   
   ; compute dens only for valid values of e and T 
   okind = where( T gt 0. AND e gt 0.)
   
   result[okind] = e*1e2/(Rv*T[okind])
   
   ; convert vector to scalar if only on element 
   if (n_elements(result) eq 1) then result = result[0]
 
   return,result
 
end
