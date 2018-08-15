function matrixread, inname, N, header=header, double=double

; Reads a square NxN matrix M from an ASCII file.

get_lun, lun
openr, lun, inname
if keyword_set(double) then M = dblarr(N, N) else M=fltarr(N,N)
n = n_elements(binra)
if keyword_set(header) then readf, lun, header
readf, lun, M
close, lun
free_lun, lun

return, M
end