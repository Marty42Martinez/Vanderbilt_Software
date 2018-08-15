PRO ALM2FITS, index, alm_array, fitsfile, HDR = hdr, XHDR = xhdr

;+
; NAME:
;       ALM2FITS
;
; PURPOSE:
;       write to a FITS file a binary table extension containing spherical
;       harmonic coefficients (and optioanl errors) and their index. Writes 
;       header information if required.
;
; CALLING SEQUENCE:
;       ALM2FITS, index, alm_array, fitsfile, [HDR = , XHDR = ]
; 
; INPUTS:
;       fitsfile = String containing the name of the file to be written      
;       index    = Long array containing the index for the corresponding 
;                  array of alm coefficients (and erralm if required). The
;                  index {i} is related to {l,m} by the relation
;                  i = l^2 + l + m + 1
;      alm_array = real array of alm coefficients written to the file.
;                  This has dimension (nl,nalm,nsig) -- corresponding to
;                  nl   = number of {l,m} indices
;                  nalm = 2 for real and imaginary parts of alm coefficients;
;                         4 for above plus corresponding error values
;                  nsig = number of signals to be written (1 for any of T E B
;                         or 3 if ALL to be written). Each signal is stored
;                         in a separate extension.
;
; OPTIONAL INPUTS:
;
;
; OUTPUTS:
;
;
; OPTIONAL OUTPUT KEYWORDS:
;       HDR      = String array containing the header for the FITS file.
;       XHDR     = String array containing the extension header(s). If 
;                  ALL signals are required, then the three extension 
;                  headers are returned appended into one string array.
;                  NOTE: optional header strings should NOT include the
;                  header keywords explicitly written by this routine.
;
; EXAMPLE:
;       Write the T spherical harmonic coefficients with corresponding errors
;       stored in the array, alm, into the FITS file, coeffs.fits, as indexed 
;       by the array index, and extension header information contained in the 
;       string array, ext_text
;
;       IDL> alm2fits,index,alm,'coeffs.fits',XHDR=ext_txt
;
;
; PROCEDURES CALLED:
;       FXHMAKE, SXADDPAR, FXWRITE, FXBHMAKE, FXADDPAR, FXBCREATE, 
;       FXBWRITE, FXBFINISH
;       TODAY_FITS()
;
; MODIFICATION HISTORY:
;       May 1999: written by A.J. Banday (MPA)   
;       Feb 2000: replace today() by today_fits(), EH (Caltech)      
;-

if N_params() LT 3 or N_params() gt 5 then begin
  print,'Syntax : ALM2FITS, index, alm_array, fitsfile, [HDR = , XHDR = ]'
  goto, Exit
endif

; run astrolib routine to set up non-standard system variables
defsysv, '!DEBUG', EXISTS = i  ; check if astrolib variables have been set-up
if (i ne 1) then astrolib      ; if not, run astrolib to do so

if n_elements(hdr)  eq 0 then hdr  = ' '
if n_elements(xhdr) eq 0 then xhdr = ' '

; ------- primary unit ----------
; create the primary header information
fxhmake,h0,0,/extend,/date            ; default primary header

; update date to Y2K
fdate = today_fits()
SXADDPAR,h0,'DATE',fdate,' Creation date (CCYY-MM-DD) of FITS header'

; add header information given by user
if (STRMID(hdr(0),0,1) NE ' ') then begin
  iend = WHERE( STRUPCASE(STRMID(h0,0,8)) EQ 'END     ', nend)
  if (nend eq 1) then begin
    iend = iend(0)
    h1 = [h0(0:iend-1), hdr]
  endif else begin
    h1 = h0
  endelse
endif

; initial write of minimal primary header and null image
fxwrite,fitsfile,h0

; -------- extension -----------

; array information
info  = size(alm_array)
nrows = info(1)
ncols = info(2) + 1 ; # of columns in array, ADD one for output # of columns
if(info(0) gt 2)then nsigs = info(3) else nsigs = 1

; run a loop to create successive binary extension tables: 1 = T; 2 = E; 3 = B
for ix = 0,nsigs-1 do begin

; create the extension header information
fxbhmake,xthdr,nrows                  ; default extension header

; add/update header information
nbytes = 4*ncols
fxaddpar,xthdr,'NAXIS1  ',nbytes,'Number of 8 bit bytes in each row'
fxaddpar,xthdr,'NAXIS2  ',nrows,'Number of rows in file'
fxaddpar,xthdr,'TFIELDS ',ncols,'Number of fields (columns) in the table'
fxaddpar,xthdr,'TFORM1  ','1J        '
for i = 1,ncols-1 do begin
  keyword = 'TFORM' + STRTRIM(STRING(i+1),2) + '  '
  fxaddpar,xthdr,keyword,'1E        '
endfor

; add the user defined header 
if (STRMID(xhdr(0),0,1) NE ' ') then begin
  iend = WHERE( STRUPCASE(STRMID(xthdr,0,8)) EQ 'END     ', nend)
  if (nend eq 1) then begin
    iend = iend(0)
    xthdr = [xthdr(0:iend-1), xhdr]
  endif
endif

; write the binary table extension header
fxbcreate,lun,fitsfile,xthdr            ; add extension header to disk FITS file

; write out the data
for i = 0L,LONG(nrows-1) do begin
  fxbwrite,lun,index(i),1,i+1L            ; index # is column # 1
  for j = 0,ncols-2 do begin
    fxbwrite,lun,alm_array(i,j,ix),j+2,i+1L
  endfor
endfor

; free the file
fxbfinish,lun

endfor ; loop over extension tables

; Exit routine
Exit:
return
end



