pro polstrips, binavarr,binsdarr, iunpolarr, qarr,uarr,carr,sarr,slopearr,offsetarr,iunpolsig,qsig,usig,csig,ssig, slopesig, offsetsig, linchisqarr,stokeschisqarr


; this pro takes in the binned rotation data array from newbin.pro
; eg, binavarr, and fits for i,q,u,cos,sin and errors per rotation
; generates vectors of all above and vector of  RA in deg in 'ravec'
; before fitting, it removes a slope and offset,and saves these in
; slope and offset and their errors
; this makes the Iunpols zero

nfiles = n_elements(binavarr(1,*)); number of files used to make binavarr

iunpolarr = fltarr(nfiles)
qarr = fltarr(nfiles)
uarr = fltarr(nfiles)
carr = fltarr(nfiles); cos theta
sarr = fltarr(nfiles); sin theta
slopearr = fltarr(nfiles); drift slope
offsetarr = fltarr(nfiles); drift offset

iunpolsig = fltarr(nfiles)
qsig = fltarr(nfiles)
usig = fltarr(nfiles)
csig = fltarr(nfiles)
ssig = fltarr(nfiles)
slopesig = fltarr(nfiles)
offsetsig = fltarr(nfiles)
stokeschisqarr = fltarr(nfiles)
linchisqarr = fltarr(nfiles)

for i = 0L,nfiles-1 do begin
	dat = binavarr[*,i]
	neldata = N_ELEMENTS(dat)
	xaxis = indgen(neldata)
	result = linfit(xaxis,dat,sdev = binsdarr[*,i],sigma = linsigma,chisq = linchisq)
	data = dat - result[0] - result[1]*xaxis
	;totvar = total(1/(binsdarr[*,i])^2)
	;sigmu = 1.;sqrt(1/totvar)

	;weights = replicate(sigmu,neldata);(sqrt(neldata/binsdarr[*,i]); weight = this *not* this^2 as mentioned in help on svdfit,
	;this is the weight used to get chisq. it gets squared (variance) later


	weights = 1./(binsdarr[*,i])
	;should add in above a sqrt(2) from Q from binsd?!


	A = [1.,1.,1.,1.,1.]
	thet = 2.*!dpi*(indgen(neldata))/(neldata-1.)
	fit = SVDFIT(thet, data, A=A, FUNCTION_NAME='polfunct', weights = weights,$
			SIGMA=stokessigma, YFIT=YFIT, /DOUBLE,chisq=stokeschisq)
	iunpolarr[i] = fit[0]
	qarr[i] = fit[1]
	uarr[i] = fit[2]
	carr[i] = fit[3]
	sarr[i] = fit[4]
	slopearr[i] = result[1]
	offsetarr[i] = result[0]

	iunpolsig[i] = stokessigma[0]
	qsig[i] = stokessigma[1]
	usig[i] = stokessigma[2]
	csig[i] = stokessigma[3]
	ssig[i] = stokessigma[4]
	slopesig[i] = linsigma[1]
	offsetsig[i] = linsigma[0]
	stokeschisqarr[i] = stokeschisq
	if i mod 50 eq 0 then print, i,linchisq,stokeschisq

endfor


end