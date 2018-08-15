PRO CL2FITS, cl_array, fitsfile, HDR = hdr, XHDR = xhdr

;+
; NAME:
;       CL2FITS
;
; PURPOSE:
;       write into a FITS file as an ascii table extension the power 
;       spectrum coefficients passed to the routine . Adds additional
;       headers if required.
;
; CALLING SEQUENCE:
;       CL2FITS, cl_array, fitsfile, [HDR = , XHDR = ]
; 
; INPUTS:
;       cl_array = real array of Cl coefficients to be written to file.
;                  This has dimension:
;                    (lmax+1,1) for Temperature only   
;                      or
;                    (lmax+1,4) given in the sequence T E B TxE,
;                     for temperature and polarisation
;                  The convention for the power spectrum is 
;                  cl = Sum_m {a_lm^2}/(2l+1)
;                  ie. NOT normalised by the Harrison-Zeldovich spectrum.
;       fitsfile = String containing the name of the file to be written      
;
; OPTIONAL INPUTS:
;
;
; OPTIONAL INPUT KEYWORDS:
;       HDR      = String array containing the (non-trivial) header for the 
;                  FITS file.
;       XHDR     = String array containing the (non-trivial) extension header 
;                  for the extension.
;                  NOTE: optional header strings should NOT include the
;                  header keywords explicitly written by this routine.
; EXAMPLE
;       Write the power spectrum coefficients in the real array, pwr,
;       into the FITS file, spectrum.fits, with extension header information
;       contained in the string array, ext_text
;
;       IDL> cl2fits,pwr,'spectrum.fits',XHDR=ext_txt
;
;
; PROCEDURES CALLED:
;       WRITEFITS, HEADFITS, SXADDPAR, FTCREATE, FTPUT, TODAY_FITS()
;
; MODIFICATION HISTORY:
;       May 1999: written by A.J. Banday (MPA)        
;       Feb 2000: accept one column array for temperature only,
;                 give explicit name to each column
;                 put in today_fits()   EH (Caltech) 
;                 added EXTNAME and fit file size to actual number of fields
;
;-

code = 'CL2FITS'
if N_params() NE 2 then begin
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

if n_elements(hdr)  eq 0 then hdr  = ' '
if n_elements(xhdr) eq 0 then xhdr = ' '

; ------- primary unit ----------
; opens the file, write a minimal header and close it
WRITEFITS,fitsfile,0

; update date to Y2K
h0 = HEADFITS(fitsfile)
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

; opens the file, write the header and the image if any, and close it
WRITEFITS, fitsfile, 0, h1

; -------- extension -----------

; get the dimensions of the input array
info  = size(cl_array)
ndims = info(0) ; # of array dimensions
nrows = info(1) ; # of entries for l-range; nrows = lmax+1
if ndims eq 1 then nsigs = 1 else $
  nsigs = info(2) ; # of signals; should be 1 corresponding to T
;                                        or 4 corresponding to T E B TxE

if (nsigs ne 4 and nsigs ne 1) then begin
  print,code+': Input array must have dimensions (lmax+1,1) or (lmax+1,4)'
  print,'  No file written'
  goto, Exit
endif

width = 16  ;(assuming TFORM= E15.x)
; create the minimal extension header
ncols = width*nsigs-1 ; # of character columns 
FTCREATE,ncols,nrows,xthdr,tab

; add/update header information
SXADDPAR,xthdr,'COMMENT','-----------------------------------------------'
SXADDPAR,xthdr,'EXTNAME','POWER SPECTRUM',' Power spectrum : C(l)  '
SXADDPAR,xthdr,'COMMENT','-----------------------------------------------'
SXADDPAR,xthdr,'TFIELDS',nsigs,' # of fields in file'
SXADDPAR,xthdr,'NAXIS1',width*nsigs-1,    ' # of characters in a row'
SXADDPAR,xthdr,'NAXIS2',nrows, ' # of rows in file'

ttype_kw = ['TEMPERATURE','GRADIENT','CURL','G-T']
ttype_cm = [' Temperature C(l)',' Gradient (=ELECTRIC) polarisation C(l)',$
            ' Curl (=MAGNETIC) polarisation C(l)',' Gradient-Temperature cross terms']

for i = 0,nsigs-1 do begin
  keyword = 'TTYPE' + STRTRIM(STRING(i+1),2)
  SXADDPAR,xthdr,keyword,ttype_kw[i],ttype_cm[i]
  keyword = 'TBCOL' + STRTRIM(STRING(i+1),2)
  SXADDPAR,xthdr,keyword,1+width*i,'beginning column of field'
  keyword = 'TFORM' + STRTRIM(STRING(i+1),2)
  SXADDPAR,xthdr,keyword,'E15.7'
endfor

; add the user defined header 
if (STRMID(xhdr(0),0,1) NE ' ') then begin
  iend = WHERE( STRUPCASE(STRMID(xthdr,0,8)) EQ 'END     ', nend)
  if (nend eq 1) then begin
    iend = iend(0)
    xthdr = [xthdr(0:iend-1), xhdr]
  endif
endif

; add the data values
for irow = 0L,LONG(nrows-1) do begin
  for icol = 0L,LONG(nsigs-1) do begin
    FTPUT,xthdr,tab,icol+1,irow,cl_array(irow,icol)
  endfor
endfor

; write the header 
WRITEFITS, fitsfile, tab, xthdr, /append

; Exit routine
Exit:
return
end



