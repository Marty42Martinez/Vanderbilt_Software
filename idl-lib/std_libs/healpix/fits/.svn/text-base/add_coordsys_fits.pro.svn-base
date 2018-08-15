pro add_coordsys_fits, info_header, coordsys = coordsys, error = error
;+
; add_coordsys_fits, info_header, coordsys = coordsys, error = error
;
;-

if datatype(coordsys) ne 'STR' then begin
    print,'unvalid coordinate system'
    return
endif

coord = strmid(strupcase(strtrim(coordsys,2)),0,1)

if (coord eq 'C' or coord eq 'G' or coord eq 'E') then begin
    sxaddpar, info_header,'COORDSYS',coord, ' Pixelization coordinate system'
    sxaddpar, info_header,'COMMENT',$
      '        G = Galactic, E = ecliptic, C = celestial = equatorial',after='COORDSYS' 
endif else begin
    print,'coordinate system unknown'
    return
endelse

return
end

