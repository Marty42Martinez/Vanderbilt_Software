pro cmbfast2IDL, sfile, tfile, outname=outname, uK = uK

; Converts outputs from CMBFAST into an IDL Save File
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
if n_elements(outname) eq 0 then outname = 'cl.var'
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
if keyword_set(uK) then g = 1.0e12 else g = 1.
TT = TT/f*g
EE = EE/f*g
TE = TE/f*g
BB = BB/f*g

; construct 4-by-(lmax+1) array from these quanties, and give add in monopole and dipole (at 0 level)

C0 = fltarr(lmax+1) ; 0..lmax
Cl = {T:C0, E: C0, B:C0, X:C0} ; initially all set to zero.

Cl.T[2:lmax] = TT
Cl.E[2:lmax] = EE
Cl.B[2:lmax] = BB
Cl.X[2:lmax] = TE

; Load newly constructed Cl into IDL save file.

save, fi = outfile, Cl

END