;+
; NAME:
;	theta
;
; PURPOSE:
;	Calculate theta from pressure and temperature
;	
; CATEGORY:
;	FUNCTION
;
; CALLING SEQUENCE:
;	theta(p,T)
;
; EXAMPLE:
;	theta(200,-50)
;
; INPUTS: 
;	p	(FLT OR FLTARR) the pressure in mbar
;	T	(FLT OR FLTARR) the temperature in deg C
;
; OPTIONAL INPUT PARAMETERS:
;
; KEYWORD INPUT PARAMETERS:
;
; OUTPUTS
;	the potential temperature
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
;	first implementation June,10 1997 by Dominik Brunner
;-
FUNCTION theta,p,T
   thet=(p GT 0.)*(T+273.15)*(1000./p)^0.28571429
   return,thet
end
