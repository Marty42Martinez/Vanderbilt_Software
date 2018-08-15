;+
; NAME:
;	sh2vmr.pro
;
; PURPOSE:
;	Convert specific humidity (g H2O per kg humid air) into
;       volume mixing ration in terms of ppmv.
;   
; CATEGORY:
;	atmospheric physics
;
; CALLING SEQUENCE:
;	result=sh2vmr(q)
;
; EXAMPLE:
;	print,sh2vmr([5,10,20])
;
;       prints       1990.35      2271.56      2444.2
;
; INPUTS:
;	Q: specific humidity (g H2O / kg humid air)
;
; OPTIONAL INPUT PARAMETERS:
;
; KEYWORD INPUT PARAMETERS:
;
; OUTPUTS:
;	returns the volume mixing ratio of H2O in ppmv
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
;  Derivation: see mixr2vmr
;-
FUNCTION  sh2vmr,q
  
  Md=28.966                   ; molecular mass of dry air
  Mw=18.016                   ; molecular mass of water
  
  return,1e3 * Md/Mw * q/(1-q/1000.)

END
