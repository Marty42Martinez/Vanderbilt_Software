pro cmbfast2fits, sfile, tfile, outname=outname

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
if n_elements(outname) eq 0 then outname = 'cl.fits'
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
l = findgen(lmax-1) + 2
f = l*(l+1)/(2*!pi*Tcmb^2)
TT = TT/f
EE = EE/f
TE = TE/f
BB = BB/f

; Convert from E-B format to C-G format (Healpix wants C-G)
EE = EE/2.
BB = BB/2.
TE = TE/sqrt(2.)

; construct 4-by-(lmax+1) array from these quanties, and give add in monopole and dipole (at 0 level)

Cl = dblarr(lmax+1,4)
Cl[0:1,*] = 0. ; make sure monopole, dipole terms are zero.
Cl[2:lmax,0] = TT
Cl[2:lmax,1] = EE
Cl[2:lmax,2] = BB
Cl[2:lmax,3] = TE

; Load newly constructed Cl into fits format with the HEALPIX routine cl2fits.


cl2fits, Cl, outfile

END