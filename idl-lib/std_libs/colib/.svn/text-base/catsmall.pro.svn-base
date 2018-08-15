pro catsmall, startfile, stopfile, path, outname=outname, under=under

; this program makes longvectors of all acquired channels for all individual 7.5 minute .var files
; it stores the longvectors to a file called 'longvars.var' in the same directory as the .var files
; the data is undersampled, however.


if (n_elements(outname) eq 0) then outname = 'shortvars.var'
if (n_elements(under) eq 0) then under = 50

;CONSTANTS--------------------------

q = 9000.
r = long(q-1)/under + 1
n = startfile
m = stopfile
nm = m - n +1 ; total number of hour files
tot = r*nm
;---------------------------------------------------------------
;Initialize all data arrays
;---------------------------------------------------------------
;arrays containing all the data in (sample#,file#) format
tp0arr = fltarr(tot)
tp1arr = fltarr(tot)
j1iarr = fltarr(tot)
j2iarr = fltarr(tot)
j3iarr = fltarr(tot)
j1oarr = fltarr(tot)
j2oarr = fltarr(tot)
j3oarr = fltarr(tot)
tcparr = fltarr(tot)
themtarr = fltarr(tot)
tloarr = fltarr(tot)
tradarr = fltarr(tot)
time = fltarr(tot)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Read in hour files and record their data contents to the above variables

for h = n,m do begin
	restfile = strcompress(path+'hour'+string(h)+'.dat.var',/REMOVE_ALL)
	restore, restfile
	i = h - n
	print, h

	tcparr[i*r:(i+1)*r-1] = tempcalcarr(u(tcp,under))
	themtarr[i*r:(i+1)*r-1] = tempcalcarr(u(themt,under))
	tloarr[i*r:(i+1)*r-1] = tempcalcarr(u(tlo,under))
	tradarr[i*r:(i+1)*r-1] = tempcalcarr(u(trad,under))


    ;Enter actual data-------------------------------------------

	tp0arr[i*r:(i+1)*r-1] = u(tp0,under)
	tp1arr[i*r:(i+1)*r-1] = u(tp1,under)
	j1iarr[i*r:(i+1)*r-1] = u(j1i,under)
	j1oarr[i*r:(i+1)*r-1] = u(j1o,under)
	j2iarr[i*r:(i+1)*r-1] = u(j2i,under)
	j2oarr[i*r:(i+1)*r-1] = u(j2o,under)
	j3iarr[i*r:(i+1)*r-1] = u(j3i,under)
	j3oarr[i*r:(i+1)*r-1] = u(j3o,under)

endfor

time = findgen(tot) /20./3600. * under
outfile = strcompress(path+outname)
save, filename = outfile, startfile,stopfile, $
				tp0arr, tp1arr, j1iarr,j2iarr,j3iarr, j1oarr,j2oarr,j3oarr, $
				tcparr, themtarr, tradarr, tloarr
end