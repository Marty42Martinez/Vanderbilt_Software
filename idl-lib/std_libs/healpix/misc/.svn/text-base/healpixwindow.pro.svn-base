function healpixwindow, nside
;+
; NAME:
;   healpixwindow
;
; PURPOSE:
;   returns the Healpix pixel window corresponding to resolution parameter Nside
;
; CATEGORY:
;
; CALLING SEQUENCE:
;   result = healpixwindow(nside)
;
; INPUTS:
;   nside : scalar integer, should be a power of 2 in {2,4,8,16,...,8192}
;
; OUTPUTS:
;   result = Healpix pixel window corresponding to resolution parameter Nside
;
; PROCEDURE:
;   reads the file $HEALPIX/data/pixel_window_n*.fits
;
; EXAMPLE:
;   wpix = healpixwindow(1024)
;
; MODIFICATION HISTORY:
;     version 1.0, EH, Caltech, 11-1999
;
;-

ns = long(nside)
routine = 'HEALPIXWINDOW'

; check nside
err = 0
npix = nside2npix(ns,err=err)

; test, complain and exit
if (err ne 0) then begin
    print,routine +': invalid Nside ',nside
    return,-1
endif

if (ns le 1) then begin
    print,routine +print,'Nside out of range ',nside
    return,-1
endif

; if OK, find full path
dir1 = '$HEALPIX/data/'
dir = expand_path(dir1)

; form file name
snside = string(ns,form='(i4.4)')
file = dir+'pixel_window_n'+snside+'.fits'

; read in file data
read_fits_map, file, wpix,/silent

; exit
return,wpix
end
