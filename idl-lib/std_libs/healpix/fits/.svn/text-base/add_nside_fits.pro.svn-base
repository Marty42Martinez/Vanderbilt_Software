pro add_nside_fits, info_header, nside=nside, partial=partial, error=error
;+
; add_nside_fits
;
; add_nside_fits,info_header, nside=, partial=, error=
;
;  adds the NSIDE keyword defined by 'nside' in
;  the fits header 'info_header'
;
;  a full sky coverage is assumed unless partial is set
;
;  EH 2000-02
;-

error=0

npix = nside2npix(nside,err=errpix)
if errpix gt 0 then begin
    print,'Invalid nside ',nside
    error=1
    return
endif

; info_header present and not empty
header_flag = 0
if info_header(0) ne ' ' then header_flag=1


; no header, open one
if (header_flag eq 0) then info_header = strarr(1) 

if keyword_set(partial) then begin
     sxaddpar,info_header,'NSIDE',nside,' Healpix resolution parameter'
     sxdelpar,info_header,['NPIX','OBJECT','FIRSTPIX','LASTPIX']
endif else begin
    sxaddpar,info_header,'NSIDE',nside,' Healpix resolution parameter'
    sxaddpar,info_header,'NPIX',npix,' Total number of pixels',after='NSIDE'
    sxaddpar,info_header,'OBJECT','FULLSKY',' Sky coverage, either FULLSKY or PARTIAL'
    sxaddpar,info_header,'FIRSTPIX',0,' First pixel # (0 based)'
    sxaddpar,info_header,'LASTPIX',npix-1,' Last pixel # (zero based)'
endelse

return
end

;--------------------------------
