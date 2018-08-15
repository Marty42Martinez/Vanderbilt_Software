;+
; NAME:
;	sh2mixr.pro
;
; PURPOSE:
;	Convert specific humidity (g H2O per kg of humid air) into
;       mixing ratio in terms of g H2O per kg of dry air
;   
; CATEGORY:
;	atmospheric physics
;
; CALLING SEQUENCE:
;	result=sh2mixr(q)
;
; EXAMPLE:
;	print,sh2mixr([5,10,20])
;
;       prints      5.02513      10.1010      20.4082
;
; INPUTS:
;	Q: specific humidity (g H2O / kg humid air)
;
; OPTIONAL INPUT PARAMETERS:
;
; KEYWORD INPUT PARAMETERS:
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
;
;                                      Mw*e              e
;  W (mixing ration) = m_h2o/m_dry = -------- = Mw/Md * ---
;                                    Md*(p-e)           p-e

;                                                   Mw*e          W
;  Q (spec. hum.)    = m_h2o/(m_dry + m_h2o) =  ------------  = -----
;                                               Mw*e+Md*(p-e)   1 + W
;
;
;  Thus: W = Q / (1-Q)
;
;-
FUNCTION  sh2mixr,q
  return,Q/(1.-Q/1000.)
END
