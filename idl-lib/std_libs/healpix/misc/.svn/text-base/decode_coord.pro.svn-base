function decode_coord, coord_code, nlong=nlong, nlat=nlat, flong=flong, flat = flat, error = error
;+
; NAME:
;   decode_coord
;
; PURPOSE:
;   returns the meaning of the coordinate coding used for Cobe
;
; CATEGORY:
;
; CALLING SEQUENCE:
;  result = DECODE_COORD(Coord_code, [Nlong=, Nlat=, Flong=, Flat=,
;  Slong=, Slat=])
; 
; INPUTS:
;  Coord_code = 1 character string coding for coordinate system
;
; OPTIONAL INPUTS:
; KEYWORD PARAMETERS:
; OUTPUTS:
;  result = string with the full name of the coordinate system
;
; OPTIONAL OUTPUTS:
;  Nlong, Nlat : named variable containing on output
;     the longitude-like and latitude-like coordinates
;  Flong, Float : named variable containing on output
;     the Fits coding for longitude and latitude coordinates
;  Error : set to 1 on output if invalid input
;
;  Coord_code         result   Nlong   Nlat    Flong      Flat   Slong   Slat
;         'E'     'Ecliptic'  'Long'  'Lat'   'ELON'   'ELAT'
;         'Q'   'Equatorial'    'RA'  'Dec'   'RA--'   'DEC-'   'Alpha' 'Delta'
;         'G'     'Galactic'  'Long'  'Lat'   'GLON'   'GLAT'       'l'     'b'
;      
; COMMON BLOCKS:
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
; EXAMPLE:
; MODIFICATION HISTORY:
;         March 1999,   EH Caltech, version 1.0
;         Feb   2000,  added error
;-


coordinate ='unknown'
error = 1
if N_params() ne 1 then begin
    print,'incorrect call to DECODE_COORD'
    print, 'result = DECODE_COORD(Coord_code, [Nlong=, Nlat=, Flong=, Flat=])'
    return, coordinate
ENDIF

code = STRMID(STRTRIM(STRUPCASE(coord_code),2),0,1) ; first letter, upper case

case code of
    'G' : begin
        coordinate = 'Galactic'
        nlong = 'Long' & Nlat = 'Lat'
        flong = 'GLON' & Flat = 'GLAT'
        error = 0
        end
    'E' : begin
        coordinate = 'Ecliptic'
        nlong = 'Long' & Nlat = 'Lat'
        flong = 'ELON' & Flat = 'ELAT'
        error = 0
        end
    'Q' : begin
        coordinate = 'Equatorial'
        nlong = 'RA'   & Nlat = 'Dec'
        flong = 'RA--' & Flat = 'DEC-'
        error = 0
        end
    else : begin
        print,'coordinate code unknown'
        error = 1
    end
endcase

return,coordinate

end

