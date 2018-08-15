PRO FITS2ALM, index, alm_array, fitsfile, signal, HDR = hdr, XHDR = xhdr

;+
; NAME:
;       FITS2ALM
;
; PURPOSE:
;       read from a FITS file a binary table extension containing spherical
;       harmonic (scalar or tensor) coefficients together with their index 
;       and return them. Reads header information if required.
;
; CALLING SEQUENCE:
;       FITS2ALM, index, alm_array, fitsfile, [signal, HDR = , XHDR = ]
; 
; INPUTS:
;       fitsfile = String containing the name of the file to be written      
;
; OPTIONAL INPUTS:
;       signal   = String defining the signal coefficients to read
;                  Valid options: 'T' 'E' 'B' 'ALL' 
;
; OUTPUTS:
;       index    = Integer array containing the index for the corresponding 
;                  array of alm coefficients (and erralm if required). The
;                  index {i} is related to {l,m} by the relation
;                  i = l^2 + l + m + 1
;      alm_array = real array of alm coefficients read from the file.
;                  This has dimension (nl,nalm,nsig) -- corresponding to
;                  nl   = number of {l,m} indices
;                  nalm = 2 for real and imaginary parts of alm coefficients;
;                         4 for above plus corresponding error values
;                  nsig = number of signals extracted (1 for any of T E B
;                         or 3 if ALL extracted). Each signal is stored
;                         in a separate extension.
;
; OPTIONAL OUTPUT KEYWORDS:
;       HDR      = String array containing the header for the FITS file.
;       XHDR     = String array containing the extension header(s). If 
;                  ALL signals are required, then the three extension 
;                  headers are returned appended into one string array.
;
; EXAMPLE:
;       Read the B tensor harmonic coefficients into the real array, alm,
;       from the FITS file, coeffs.fits, with extension header information
;       contained in the string array, ext_text
;
;       IDL> fits2alm,alm,'coeffs.fits','B',XHDR=ext_txt
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

if N_params() LT 3 or N_params() gt 6 then begin
      print,'Syntax : FITS2ALM, index, alm_array, fitsfile, [signal, HDR = , XHDR = ] '
      goto, Exit
endif

; run astrolib routine to set up non-standard system variables
defsysv, '!DEBUG', EXISTS = i  ; check if astrolib variables have been set-up
if (i ne 1) then astrolib      ; if not, run astrolib to do so

hdr  = HEADFITS(fitsfile)

; -------- extension -----------

if(undefined(signal))then signal = 'T'

signal = STRUPCASE(signal)

CASE signal OF
            'T'  : BEGIN
                     extension = 1 
                     nsig = 1
                   END
            'E'  : BEGIN
                     extension = 2
                     nsig = 1
                   END
            'B'  : BEGIN
                     extension = 3 
                     nsig = 1
                   END
            'ALL': BEGIN
                     extension = 1 
                     nsig = 3 ; extension value initialises read-loop
                   END

             else: BEGIN
                     print,' Incorrect signal selected'
                     goto, Exit
                   END
ENDCASE

; simply read the extensions from the FITS file
savehdr = ''
for i = 0,nsig-1 do begin
  xhdr = HEADFITS(fitsfile,EXTEN=extension+i)
  errtest = size(xhdr)
  if(errtest(0) eq 0)then begin
    print,' Required extension does not exist in file'
    goto, Exit
  endif
  savehdr = [savehdr,xhdr]
  tmpout = MRDFITS(fitsfile,extension+i,/use_colnum)

  if (i eq 0) then begin
    ; get the dimensions of the input array
    info  = size(tmpout)
    nrows = info(1) ; # of entries for l-range
    ncols = n_elements(tag_names(tmpout))

    ; output array
    index     = tmpout.c1
    alm_array = fltarr(nrows,ncols-1,nsig)
  endif

  alm_array(*,0,i) = tmpout.c2
  alm_array(*,1,i) = tmpout.c3

  if(ncols eq 5)then begin
    alm_array(*,2,i) = tmpout.c4
    alm_array(*,3,i) = tmpout.c5
  endif

endfor

alm_array = reform(alm_array)
xhdr = savehdr

; Exit routine
Exit:
return
end



