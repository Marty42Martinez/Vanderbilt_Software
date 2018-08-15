function extract_map_from_stc, stc, select_in, select=select, value=select_name, error=error


routine = 'extract_map_from_stc'
header = stc.(0)
select = index_word(tag_names(stc),select_in,value=select_name,err=error)
if (error ne 0 or select eq 0) then begin
    print,'wrong select in '+routine
    print,select_in,tag_names(stc)
    error = 1
    return,0
endif

coverage = strtrim(strupcase(sxpar(header,'OBJECT',Count=flag_cov)),2)
nside_head = long(sxpar(header,'NSIDE',Count=flag_nside))

if (flag_cov gt 0 and nside_head gt 0 and coverage eq 'PARTIAL') then begin
    npix_head = 12 * nside_head^2
    map = make_array(npix_head,/float,value=-1.6375e30)
    map(stc.(1)) = stc.(select)
endif else begin
    map   = stc.(select)
endelse

return, map
end


pro loaddata, file_in, select_in,$
  data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, title_display, sunits, $
  SAVE=save,ONLINE=online,NESTED=nested_online,UNITS=units,COORD=coord,ROT=rot_ang,QUADCUBE=quadcube,LOG=log,ERROR=error
;+
; LOADATA
;
; IN:
;   file_in, select_in
; OUT:
;   data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat,
;   title_display, sunits 
; KEYWORDS
;   save, online, nested, units, coord, rot, quadcube, log
; OPTIONAL OUPUT
;   error
;
;-

; ----------------------------------------------
; check consistency of parameters
; ----------------------------------------------
error = 0
routine='loaddata'
kw_save = KEYWORD_SET(save) & kw_online = KEYWORD_SET (online)
if ((kw_save) and (kw_online)) then begin
    print,routine+' : /ONLINE and /SAVE can not be used together'
    error=1
    return
endif

if (datatype(file_in) NE 'STR' AND kw_save) then begin
    print,routine+' : an external file is expected with /SAVE'
    error=1
    return
endif

if (datatype(file_in) NE 'STR' AND NOT kw_online) then begin
    print,routine+' : a file name is expected or /ONLINE is missing'
    error=1
    return
endif

if (datatype(file_in) EQ 'STR' AND kw_online) then begin
    print,routine+' : /ONLINE can not be used with an external file'
    error=1
    return
endif

if (datatype(file_in) EQ 'STR') then begin ; looking for a file
    junk = FINDFILE(file_in, count=countfile) ; check its existence
    if (countfile eq 0) then begin
        print,file_in+' not found'
        error=1
        return
    endif
endif

; ----------------------------------------------
; reads in the FITS file or the SAVESET file
; ----------------------------------------------
print,'reading the file ...'
; in file_in, kw_save, kw_online, select_in, routine
; out data, title_display, header
select_name = ''
if undefined(select_in) then select_in = 1

case 1 of
    ;---------------------
    kw_online : begin
        if (datatype(file_in) EQ 'STC') then begin ; structure
            header = file_in.(0)
            data = extract_map_from_stc(file_in, select_in, select=select, value=select_name, error=error)
            if (error ne 0) then return
        endif else begin
            data = file_in
        endelse
	title_display = ' on line processing '
    end
    ;---------------------
    kw_save : begin            ; read the saveset file
        RESTORE, file_in, /VERBOSE
        title_display = file_in
    end
    ;---------------------
    else : begin
        READ_FITS_S, file_in, data_s, /merge ; reads in a FITS extension or an image
        header = data_s.(0)
        data = extract_map_from_stc(data_s, select_in, select=select, value=select_name, error=error)
        data_s = 0.
        if (error ne 0) then return
        title_display = file_in
    end
endcase
title_display = title_display + ': '+select_name

; ---- Pixel scheme ----
; Healpix : Nested or Ring scheme
; or Quadcube
pix_type = 'R' ; Healpix ring by default
IF KEYWORD_SET(nested_online) THEN pix_type = 'N'
IF DEFINED(header) THEN BEGIN
    ordering = strtrim(SXPAR(header,'ORDERING',COUNT=flag_order),2)
    if (flag_order ne 0 and STRUPCASE(STRMID(ordering,0,4)) eq 'NEST') then pix_type = 'N'
ENDIF 
if keyword_set(quadcube) then pix_type = 'Q'

; ---- units ----
sunits = ''
if (datatype(units) eq 'STR') then begin ; if the units given is a string, take it
    sunits = units
endif else begin ; otherwise find it in the file
    if defined(header) then begin
        key_unit = 'TUNIT'+STRTRIM(STRING(select,form='(i4)'),2) ; TUNITi
        sunits_read = SXPAR(header,key_unit,COUNT=flag_units)
        if (flag_units NE 0) then sunits = STRTRIM(sunits_read, 2)
    endif
endelse
if keyword_set(log) then sunits = 'Log ('+sunits+')'


;----------------------------------------------------
;       plot parameters defined by the user
;----------------------------------------------------
; ---- input and output coord system ----
flag_coord = 0 & coord_in = 'G'
IF DEFINED(header) THEN coord_in = STRUPCASE(STRMID(strtrim(SXPAR(header,'COORDSYS',COUNT=flag_coord),2),0,1))
if (flag_coord eq 0) then coord_in = 'G' ; nothing in the header -> assume galactic
coord_out = coord_in
if N_elements(coord) EQ 1 then coord_out = STRUPCASE(STRMID(coord(0),0,1))
if N_elements(coord) EQ 2 then begin 
    coord_in  = STRUPCASE(STRMID(coord(0),0,1)) 
    coord_out = STRUPCASE(STRMID(coord(1),0,1))
endif
if coord_in  EQ 'C' then coord_in =  'Q'  ; cgis skyconv coding convention for celestial/equatorial
if coord_out EQ 'C' then coord_out = 'Q'
print,'input file : ',decode_coord(coord_in)+' coordinates'
print,'plot coord : ',decode_coord(coord_out)+' coordinates'
do_conv = (coord_in NE coord_out)

; ---- extra rotation ----
if defined(rot_ang) then rot_ang = ([rot_ang,0.,0.])(0:2) else rot_ang = [0., 0., 0.]
eul_mat = euler_matrix(-rot_ang(0), -rot_ang(1), -rot_ang(2), /Deg, /ZYX)
do_rot = (TOTAL(ABS(rot_ang)) GT 1.e-5)

; ---- resolution parameter ----
npix = N_ELEMENTS(data)
nside = ROUND(SQRT(npix/12))
pix_param = nside
if (keyword_set(quadcube)) then pix_param = ROUND(ALOG(npix/6.)/ALOG(4.)) + 1 ; resolution parameter

return
end
