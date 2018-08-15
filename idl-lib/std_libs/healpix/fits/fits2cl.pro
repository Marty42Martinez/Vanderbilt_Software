PRO FITS2CL, cl_array, fitsfile, HDR = hdr, XHDR = xhdr

;+
; NAME:
;       FITS2CL
;
; PURPOSE:
;       read from a FITS file an ascii table extension containing power 
;       spectrum coefficients and return them. Reads header information
;       if required.
;
; CALLING SEQUENCE:
;       FITS2CL, cl_array, fitsfile, [HDR = , XHDR = ]
; 
; INPUTS:
;       fitsfile = String containing the name of the file to be written      
;
; OPTIONAL INPUTS:
;
;
; OUTPUTS:
;       cl_array = real array of Cl coefficients read from the file.
;                  This has dimension (lmax+1,4) given in the 
;                  sequence T E B TxE. The convention for the power
;                  spectrum is 
;                  cl = Sum_m {a_lm^2}/(2l+1)
;                  ie. NOT normalised by the Harrison-Zeldovich spectrum.
;
; OPTIONAL OUTPUT KEYWORDS:
;       HDR      = String array containing the header for the FITS file.
;       XHDR     = String array containing the extension header for the 
;                  extension.
;
; EXAMPLE:
;       Read the power spectrum coefficients into the real array, pwr,
;       from the FITS file, spectrum.fits, with extension header information
;       contained in the string array, ext_text
;
;       IDL> fits2cl,pwr,'spectrum.fits',XHDR=ext_txt
;
;
; PROCEDURES CALLED:
;       HEADFITS, MRDFITS
;
; MODIFICATION HISTORY:
;       May 1999: written by A.J. Banday (MPA)         
;
; requires the THE IDL ASTRONOMY USER'S LIBRARY 
; that can be found at http://idlastro.gsfc.nasa.gov/homepage.html
;
;-

code = 'FITS2CL'
if N_params() NE 2  then begin
      print,'Syntax : '+code+', cl_array, fitsfile, [HDR = , XHDR = ] '
      goto, Exit
endif

if datatype(cl_array) eq 'STR' or datatype(fitsfile) ne 'STR' then begin
      print,'Syntax : '+code+', cl_array, fitsfile, [HDR = , XHDR = ] '
      print,'   the array comes first, then the file name '
      print,'   file NOT written '
      goto, Exit
endif

; run astrolib routine to set up non-standard system variables
defsysv, '!DEBUG', EXISTS = i  ; check if astrolib variables have been set-up
if (i ne 1) then astrolib      ; if not, run astrolib to do so

hdr  = HEADFITS(fitsfile)
xhdr = HEADFITS(fitsfile,EXTEN=1)

; -------- extension -----------

; simply read the extension from the FITS file
tmpout = MRDFITS(fitsfile,1,/use_colnum)

; get the dimensions of the input array
info  = size(tmpout)
nrows = info(1) ; # of entries for l-range: nrows = lmax+1
ncols = n_elements(tag_names(tmpout))

if ( (ncols ne 1) and (ncols ne 4) )then begin
  print,' Input file does not conform to expected structure'
  goto, Exit
endif

; output array
if (ncols eq 1) then begin
  cl_array = tmpout.c1
endif else begin
  cl_array = fltarr(nrows,4)
  cl_array(*,0) = tmpout.c1
  cl_array(*,1) = tmpout.c2
  cl_array(*,2) = tmpout.c3
  cl_array(*,3) = tmpout.c4
endelse

; Exit routine
Exit:
return
end



