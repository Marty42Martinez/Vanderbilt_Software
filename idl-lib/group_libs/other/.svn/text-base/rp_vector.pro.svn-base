;+
; NAME:
; 
;	VECTOR
;
; PURPOSE:
; 
;       Make a vector of PTS points, with values ranging from MIN to
;       MAX.
;
; CALLING SEQUENCE:
; 
;	Result = VECTOR(MIN,MAX,PTS)
;
; INPUTS:
; 
;       MIN - Starting value for vector.
;	
;       MAX - Ending value for vector.
;	
;       PTS - Number of points.
;
; KEYWORDS:
; 
;       LOGARITHMIC - set for logarithmic spacing between points.
;                     [MIN and MAX must be positive, i.e., gt 0]
;
; OUTPUTS:
; 
;       This function returns a vector of PTS points, ranging from MIN
;       to MAX.  The returned vector is of the same type as MIN/MAX.
;
; EXAMPLE:
;
;	X=VECTOR(5.,100.,1000)
;	
;	This example returns a 1-D Floating point array X, made up of 
;	1000 points, ranging from 5. to 100.
;
;	X=VECTOR(5.d,100.d,1000)
;	
;	This example returns a 1-D Double point array X, made up of 
;	1000 points, ranging from 5. to 100.
;
; MODIFICATION HISTORY:
; 
; 	David L. Windt, Bell Labs, June 1993.
; 	
;       March, 1997: modified code so returned vector is same type as
;                    MAX.  added LOGARITHMIC keyword.
;                    
;       windt@bell-labs.com
;                    
;-
function rp_vector,v1,v2,pts,logarithmic=logarithmic
sv1=size(v1)
sv2=size(v2)
if sv1(0) ne 0 then message,'Min and Max must be scalars.'
if sv1(1) eq 7 then message,'String vectors not supported.'
if sv1(1) eq 8 then message,'Vectors of structures not supported.'
pts=long(pts)
if pts eq 1 then result=v1 else begin
    if keyword_set(logarithmic) then begin
        if (v1 le 0) or (v2 le 0) then  $
          message,'Min and Max must be positive for logarithmic spacing.'
        v1=alog10(v1)
        v2=alog10(v2)
    endif
    case sv1(1) of
        1: result=bindgen(pts)*(byte(v2)-byte(v1))/byte(pts-1)+byte(v1)
        2: result=indgen(pts)*(v2-v1)/(pts-1)+v1
        3: result=lindgen(pts)*(v2-v1)/(pts-1)+v1
        4: result=findgen(pts)*(v2-v1)/(pts-1)+v1
        5: result=dindgen(pts)*(v2-v1)/(pts-1)+v1
        6: result=cindgen(pts)*(v2-v1)/(pts-1)+v1
        9: result=dcindgen(pts)*(v2-v1)/(pts-1)+v1
    endcase
endelse
if keyword_set(logarithmic) then result=(10.d)^result
return,[result]
end

