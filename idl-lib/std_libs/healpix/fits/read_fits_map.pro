; ------------------------------------------------------------------------
PRO fast_read_fits_ext, filename, T_sky, silent=silent
;
; routine to read fast FITS extension, with one field, and one entry
; per field (ie, TFORM1 = 1x, for backward compatibility)
;
;


	exthdr = headfits(filename, exten=1)

	; identify the format in the row (number of entry per row)
	tform1 = SXPAR(exthdr,'TFORM1')
	nentry = ROUND(FLOAT(tform1))
	if (nentry gt 1) then begin
		stop,'STOP :  can NOT use fast_read_fits_ext'
	endif
	tform1 = STRMID(STRUPCASE(STRTRIM(tform1,2)),0,2) ; first 2 characters of TFORM1
	ndata = SXPAR(exthdr,'NAXIS2')
	ndata = LONG(ndata)

	; read the whole first extension (that's the easy part)
	full_data = readfits(filename,/exten, silent=silent) ; gets a binary table

	; extracts the bytes corresponding to the 1st column
	; and stick them together to convert them in real, double ...
	case tform1 of 
	'1I' :  begin  ; integer (2bytes)
		idltype = 2 
		T_sky = full_data(0:1,*) ; 1st column
		T_sky = FIX(T_sky,0,ndata)
		end
	'1J' :  begin  ; long (4bytes)
		idltype = 3 
		T_sky = full_data(0:3,*) ; 1st column
		T_sky = LONG(T_sky,0,ndata)
		end
	'1E' :  begin ; floating point (4bytes)
		idltype = 4 
		T_sky = full_data(0:3,*) ; 1st column
		T_sky = FLOAT(T_sky,0,ndata) 
		end
	'1D' :  begin  ; DP floating point (8bytes)
		idltype = 5 
		T_sky = full_data(0:7,*) ; 1st column
		T_sky = DOUBLE(T_sky,0,ndata)
		end
	else : 	begin
		stop,'STOP : unknown format in fast_read_fits_ext'
		end
	endcase
	; turns IEEE into host convention
	IEEE_TO_HOST, T_sky, IDLTYPE=idltype

RETURN
END
; ------------------------------------------------------------------------



PRO READ_FITS_MAP, filename, T_sky, hdr, exthdr, silent=silent

;+
; NAME:
;       READ_FITS_MAP
;
; PURPOSE:
; 	reads the temperature map and possibly the polarisation map in binary table
; 	extension of FITS file filename
; 	if doesn't find an extension, look in the image part
;
;       T_sky is returned as a 2-dim array 
;       1st dim = number of pixels
;       2nd dim = number of maps present in the file
;
; CALLING SEQUENCE:
; 	READ_FITS_MAP, filename, T_sky, [hdr, exthdr]
; 
; INPUTS:
;	filename = String containing the name of the file to be read.
;
; OPTIONAL OUTPUTS:
;	hdr = String array containing the header from the FITS file.
;	exthdr = String array containing the header from the extension
;
; OPTIONAL KEYWORDS:
;    silent : if set, no message is issued during normal execution
;
; PROCEDURES USED:
;	several (see below)
;
; MODIFICATION HISTORY:
;  October 1997:
;  *strip down edited by E. Hivon from the READ_FITS_MAP.pro 
;  written by A. Banday for COBE data analysis.
;  *added the image reading if no extension, EH		Nov-97
;  *made it faster by using READFITS,/exten		Dec-97
;  addition of /SLOW (=previous implementation using FXBREAD)
;  *made it compatible with multiple entry per row and per column
;  (eg TFORM = '1024E') wich makes the reading faster.  Jan-98
;
;
; requires the THE IDL ASTRONOMY USER'S LIBRARY 
; that can be found at http://idlastro.gsfc.nasa.gov/homepage.html
;
;-

if N_params() LT 2 then begin
      print,'Syntax : READ_FITS_MAP, filename, T_sky [, hdr, exthdr]'
      stop
endif

; run astrolib routine to set up non-standard system variables
defsysv, '!DEBUG', EXISTS = i  ; check if astrolib variables have been set-up
if (i ne 1) then astrolib       ; if not, run astrolib to do so

; get the primary header information
hdr = headfits(filename)

; checks for the existence of an extension
; if none, reads the image
fits_info,filename, /silent, n_ext=n_ext
if (n_ext eq 0) then begin
    T_sky = readfits(filename,hdr, silent=silent)
    exthdr = ' '
    return
endif


; identify the format in the row (number of entry per row)
exthdr = headfits(filename, exten=1)
nentry = ROUND(FLOAT(SXPAR(exthdr,'TFORM1')))
nmaps  = ROUND(FLOAT(SXPAR(exthdr,'TFIELDS')))

if (nentry EQ 1 AND nmaps EQ 1) then begin
    fast_read_fits_ext,filename,T_sky, silent=silent
endif else begin
    ; open the fits file
    fxbopen,lun,filename,1,exthdr ; sky map is binary extnsion table #1
    ; ----------------------------------------------

    nmaps = ROUND(FLOAT(SXPAR(exthdr,'TFIELDS')))
    ;nmaps_read = N_params() - 1

    ; read in the required columns
    fxbread,lun,map_tmp,1       ; pixel temperature is column #1
    npix = N_ELEMENTS(map_tmp)
    ss = size(map_tmp)
    T_sky = MAKE_ARRAY(npix,nmaps,TYPE= ss(ss(0)+1) )

    ; if #entry/row > 1 (eg TFORM = '1024x') one gets an array
    ; turn it to a vector 
    T_sky(*,0) = REFORM(map_tmp,npix) 
    ; ----------------------------------------------
    for icoln = 2, nmaps do begin
        fxbread,lun,map_tmp,icoln ; 

        ; if #entry/row > 1 (eg TFORM = '1024x') one gets an array
        ; turn it to a vector 
        T_sky(*,icoln-1) = REFORM(map_tmp,npix) 
    endfor

    ; free the file
    fxbclose,lun
endelse

; Exit, stage left ....
return
end

