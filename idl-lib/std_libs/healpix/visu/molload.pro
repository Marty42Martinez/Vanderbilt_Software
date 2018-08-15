pro molload, file_in, select_in,$
  data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, title_display, sunits, $
  SAVE=save,ONLINE=online,NESTED=nested_online,UNITS=units,COORD=coord,ROT=rot,QUADCUBE=quadcube,LOG=log
;+
;
; IN:
;   file_in, select_in
; OUT:
;   data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat,
;   title_display, sunits 
; KEYWORDS
;   save, online, nested, units, coord, rot, quadcube, log
;
;-
kw_save = KEYWORD_SET(save) & kw_online = KEYWORD_SET (online)
if ((kw_save) and (kw_online)) then begin
    print,routine+' : you can not use /ONLINE and /SAVE together'
    return
endif

routine='molload'

; ----------------------------------------------
; reads in the FITS file
; ----------------------------------------------
print,'reading the file ...'
; in file_in, kw_save, kw_online, select_in, routine
; out data, title_display, header
select_name = ''
if undefined(select_in) then select_in = 1
IF NOT kw_save AND NOT kw_online THEN BEGIN
    READ_FITS_S, file_in, data_s, /merge ; reads in a FITS extension or an image
    header = data_s.(0)
    select = index_word(tag_names(data_s),select_in,value=select_name,err=error)
    if (error ne 0 or select eq 0) then begin
        print,' wrong select in '+routine
        print,tag_names(data_s)
        return
    endif
    data   = data_s.(select)
    title_display = file_in
ENDIF ELSE BEGIN 
    IF kw_online THEN BEGIN
        if (datatype(file_in) EQ 'STC') then begin ; structure
            header = file_in.(0)
            select = index_word(tag_names(file_in),select_in,value=select_name,err=error)
            if (error ne 0 or select eq 0) then begin
                print,' wrong select in '+routine
                return
            endif
            data   = file_in.(select)
        endif else begin
            data = file_in
        endelse
	title_display = ' on line processing '
    ENDIF ELSE BEGIN            ; read the saveset file
        RESTORE, file_in, /VERBOSE
        title_display = file_in
    ENDELSE
ENDELSE
title_display = title_display + ': '+select_name

; ---- Pixel scheme ----
; Healpix : Nested or Ring scheme
; or Quadcube
pix_type = 'R' ; Healpix ring by default
IF KEYWORD_SET(nested_online) THEN pix_type = 'N'
IF DEFINED(header) THEN BEGIN
    ordering = SXPAR(header,'ORDERING',COUNT=flag_order)
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

; ---- input and output coord system ----
flag_coord = 0 & coord_in = 'G'
IF DEFINED(header) THEN coord_in = STRUPCASE(STRMID(SXPAR(header,'COORDSYS',COUNT=flag_coord),0,1))
if (flag_coord eq 0) then coord_in = 'G' ; nothing in the header -> assume galactic
coord_out = coord_in
if N_elements(coord) EQ 1 then coord_out = STRUPCASE(STRMID(coord(0),0,1))
if N_elements(coord) EQ 2 then begin 
    coord_in = STRUPCASE(STRMID(coord(0),0,1)) 
    cood_out = STRUPCASE(STRMID(coord(1),0,1))
endif
if coord_in  EQ 'C' then coord_in =  'Q'  ; cgis skyconv coding convention for celestial/equatorial
if coord_out EQ 'C' then coord_out = 'Q'
print,'input file : ',decode_coord(coord_in)+' coordinates'
print,'plot coord : ',decode_coord(coord_out)+' coordinates'
do_conv = (coord_in NE coord_out)

; ---- extra rotation ----
if defined(rot) then rot = ([rot(*),0.,0.])(0:2) else rot = [0., 0., 0.]
eul_mat = euler_matrix(-rot(0), -rot(1), -rot(2), /Deg, /ZYX)
do_rot = (TOTAL(ABS(rot)) GT 1.e-5)

; ---- resolution parameter ----
npix = N_ELEMENTS(data)
nside = ROUND(SQRT(npix/12))
pix_param = nside
if (keyword_set(quadcube)) then pix_param = ROUND(ALOG(npix/6.)/ALOG(4.)) + 1 ; resolution parameter


end
