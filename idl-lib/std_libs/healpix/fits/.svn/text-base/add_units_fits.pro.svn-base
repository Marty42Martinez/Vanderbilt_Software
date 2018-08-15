pro add_units_fits,info_header, units=units,colnum=colnum,error=error
;+
; add_units_fits
;
; add_units_fits,info_header, units=,colnum=error=
;
;  adds the UNITS keyword defined by 'units' in
;  the fits header 'info_header'
;
;  EH 2000-01
;-

if (datatype(units) ne 'STR' and datatype(units) ne 'UND') then begin
    print,'unvalid UNITS'
    error=1
    return
endif
error=0

; info_header present and not empty
header_flag = 0
;;if (n_params() eq 2) then begin
if info_header(0) ne ' ' then header_flag=1
;;endif

if undefined(colnum) then colnum = [1]
scolnum = strtrim(string(colnum,form='(i4)'),2)
ncolnum = n_elements(colnum)

; units given in the header
units_flag = 0
if (header_flag) then units_fits = strtrim(sxpar(info_header,'TUNIT'+scolnum[0],count=units_flag),2)
if units_flag eq 0 then begin
    units_fits = ' '
    if undefined(units) then units='unknown'
endif else begin
    if undefined(units) then return
endelse

; no header, open one
if (header_flag eq 0) then info_header = strarr(1) 

; change TUNIT*
if (units_fits ne units) then begin
    print,' value of UNITS changed from '+units_fits+' to '+units
    for i=0,ncolnum-1 do begin
        sxaddpar,info_header,'TUNIT'+scolnum[i],units
    endfor
endif


return
end

;--------------------------------
