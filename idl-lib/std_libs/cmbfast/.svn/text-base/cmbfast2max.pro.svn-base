pro cmbfast2max, sfile, tfile, outname=outname

; Converts outputs from CMBFAST into a Fits File Readable by HEALPIX
;
; INPUTS:
;	sfile: Name of scalar Cl file (required)
;   tfile: Name of tensor Cl file (optional)
;
;
; OUTPUTS:
;	Program will write the output to "outname" in the same directory
;   as the input file(s).
;
;

; Break out the filename
split_dir, sfile, dir
if n_elements(outname) eq 0 then outname = 'cl.dat'
outfile = dir + outname

; read in power spectra (note: these are in CMBFast standard format!!)

readcol, sfile, l, TTs, EEs, TEs, skipline = 0

if n_elements(tfile) ne 0 then begin
	readcol, tfile, l_t, TTt, EEt, BB, TEt, skipline = 0
endif else begin
	TTt = 0.
	EEt = 0.
	BBt = EEt * 0.
	TEt = 0.
endelse

lmax = max(l)

; Add Scalar and Tensor contributions to Power Spectra
TT = TTs + TTt
EE = EEs + EEt
TE = TEs + TEt

; Convert from (l)*(l+1)*Cl/(2*!pi*Tcmb^2) to Cl
Tcmb = 2.726 ; temp used by CMBFast
l = indgen(lmax-1) + 2
f = float(l)*(l+1.)/(2.*!pi*Tcmb^2)
TT = TT/f
EE = EE/f
TE = TE/f
BB = BB/f

; Save this stuff into an ascii file
write_ascii, outfile, l, TT, EE, BB, TE, $
	format='(I5,"  ", E12.4, "  ",E12.4, "  ",E12.4, "  ",E12.4)', $
	header='ell       TT	      EE	    	BB		  TE,       all in Kelvin'

END