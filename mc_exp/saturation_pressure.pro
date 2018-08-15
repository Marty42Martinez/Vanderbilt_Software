FUNCTION saturation_pressure,T,ice=ice
; Returns  saturation pressure of wv in air ; Rogers&Yau Eqns 2.16 and 2.17
; Input:
;          T : Temperature [K]
;
; Output:
;         saturation pressure : [PA]
;
   e_sat = 611.2*exp(17.67*(T-273.16)/(T-273.16+243.5))

   IF KEYWORD_SET(ice) THEN BEGIN
     ind = WHERE(T LT 273.16,cnt)
     IF cnt NE 0 THEN  e_Sat[ind]=e_sat[ind]*(T[ind]/273.)^2.66
   ENDIF
   IF N_ELEMENTS(e_Sat) EQ 1 THEN e_Sat=e_sat[0] 
   
  RETURN,e_sat
END
