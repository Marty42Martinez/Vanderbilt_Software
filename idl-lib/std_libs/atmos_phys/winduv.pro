;+
; NAME:
;	winduv
;
; PURPOSE:
;	Calculate the horizontal windcomponents (u,v) from given
;	windangle and windspeed
;	u is the wind blowing towards east
;	v is the wind blowing towards north
;	
; CATEGORY:
;	FUNCTION
;
; CALLING SEQUENCE:
;	winduv,wangle,wspeed,u=u,v=v
;
; EXAMPLE:
;	winduv,270,30,u=u,v=v
;
; INPUTS: 
;	wangle	flt or fltarr: the windangle (0=wind from north to south,
;					      90=wind from east to west, etc.)
;	wspeed	flt or fltarr: the windspeed
;
; OPTIONAL INPUT PARAMETERS:
;
; KEYWORD INPUT PARAMETERS:
;
; OUTPUTS
;	windspeed	(flt or fltarr): the windspeed
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
;	first implementation Jan, 1998 by Dominik Brunner
;-
PRO winduv,wangle,wspeed,u=u,v=v

; check for inputs
IF n_elements(wangle) EQ 0 THEN return
IF n_elements(wangle) NE n_elements(wspeed) THEN BEGIN
   print,'Error in winduv() calculation'
   return
ENDIF

d2r=!pi/180.

v=-cos(wangle*d2r)*wspeed
u=-sin(wangle*d2r)*wspeed

end
