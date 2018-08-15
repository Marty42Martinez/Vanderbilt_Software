;+
; NAME:
;	mixr2vmr.pro
;
; PURPOSE:
;	Convert mass mixing ratio (g H2O per kg dry air) into
;       volume mixing ration in terms of ppmv.
;   
; CATEGORY:
;	atmospheric physics
;
; CALLING SEQUENCE:
;	result=mixr2vmr(mixr)
;
; EXAMPLE:
;	print,mixr2vmr([5,10,20])
;
;       prints       1990.35      2271.56      2444.2
;
; INPUTS:
;	MIXR: mass mixing ratio (g H2O / kg dry air)
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
;  Derivation:
;  mixr = m_w/m_d
;    = n_w*Mw/n_d*Md , where n_w and n_d are the number of moles
;      of water vapor and dry air, respectively
;  The volume mixing ratio is
;    vmr = n_w/n_d
;  Thus,
;     vmr = Md/Mw*mixr
;-
FUNCTION  mixr2vmr,mixr
   
   Md=28.966                   ; molecular mass of dry air
   Mw=18.016                   ; molecular mass of water
   
   return,Md/Mw*mixr * 1e3     ; factor
   
END
