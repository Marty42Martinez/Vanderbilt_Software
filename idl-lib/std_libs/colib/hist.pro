; HIST

; AUTHOR:
;   Chris O'Dell
; 	Univ. of Wisconsin-Madison
;   Observational Cosmology Laboratory
;   Email: odell@cmb.physics.wisc.edu
;
; PURPOSE
;		Versatile program to make and plot histograms of data.
;
; CALLING SEQUENCE
;
;	hist, data, binsize [, x, h, gfit=gfit, /oplot, psym=psym, /normalize, /intplot, /noplot, $
;			/quartile, qx=qx, qy=qy, qtit = qtit, qlabel = qlabel, $
;			/fit, /text, xlog=xlog, _extra = _extra]
;
; DESCRIPTION
;		This is a versatile histogram maker and plotter.  Takes data vector and a user-chosen
;		binsize, and will plot the resulting histogram.  Will optionally normalize the histogram,
;		perform a gaussian fit and overplot the fit, and plot the integrated histogram instead of the
;		regular histogram.  The integrated histogram is simple the fraction of data less than a certain value.
;		The "quartile" function can be employed in the case of making integrated histograms, to see where
;		to the left of what values 25%, 50% and 75% of the data lies.
;
;
; INPUT VARIABLES
; 	data	:	The vector of data values to be histogrammed.
;	binsize	:	The size to make the data bins.  Typically choose binsizes such that there are 10-20 total bins,
;				but this is completely up to you.
;
; OPTIONAL INPUT KEYWORDS
;	oplot		:	Set this to overplot.  In this case, unnecessary keywords are ignored.
;	intplot		:	Set this to perform an integrated histogram.
;	noplot		:	Set this to not plot anything.  Used if all you care about is getting x and h returned to you.
;	fit			:	Set this to fit the histogram to a gaussian, and overplot the resulting gaussian over the histogram.
;	text		:	If /fit set, setting this causes the mean and standard dev. of the fit gaussian to be printed.
;	normalize	:	Set this to normalize the area under the histogram to equal 1.0
;	multiplier  :   Set this to multiply the y-values of the histogram by an amount equal to multiplier.
;	quartile	:	If /intplot set, set this keyword to print the "quartiles"
;					(if you don't know what this is, don't worry about it)
;	qx, qy		:	Set these to normalized screen coords to contain the location of the quartile legend.
;					(default = [0.65,0.6])
;	qtit		:	Set this to a string variable containing the title of the Quartile legend [default='Quartiles']
;	qlabel		:	Set this to a string labelling the quartiles row (useful if you are overplotting and need
;					to discriminate between various quartile sets).
;	psym		:	Set this to a standard PSYM value [default = 10]
;	_extra		: 	Use this to add any standard PLOT keywords, such as COLOR, THICK, LINESTYLE, XRANGE, YRANGE,
;					TITLE, SUBTITLE, etc.
;
; OPTIONAL OUTPUT VARIABLES
;	x	:	The values of the bin centers for the chosen binning.
;	h	: 	The value of the histogram at each x (this is the # of data points lying in each bin if the /normalize
;			keyword wasn't set, otherwise its the fraction of data points lying in each bin).
;
; OPTIONAL OUTPUT KEYWORDS
;	gfit 	:	Set this keyword to a named variable to contain the value of the fitted gaussian at each x value
;				(requires the /fit keyword to work)
;
; DEPENDENCIES:
;	TEXTOIDL, NUM2STR (O'Dell Lib)
;

pro hist, data, x, h, binsize=binsize, gfit=gfit, oplot=oplot, _extra=_extra, normalize = normalize, $
			noplot = noplot, intplot=intplot, psym=psym, multiplier=multiplier,$
			quartile=quartile, qx=qx, qy=qy, qtit = qtit, qlabel = qlabel, $
			fit=fit, text=text, barplot=barplot, locations=locations, xlog=xlog, nbins=nbins, $
			gparams=gparams

;quartile keyword : add a print-out of the quartiles (intplot only)

 xlog = keyword_set(xlog)
 if xlog then data_ = alog10(data > 1e-20) else data_ = data
 do_fit = keyword_set(fit) AND (not keyword_set(intplot))
 o = keyword_set(oplot)
 if n_elements(locations) GT 0. then begin
	if xlog then x = alog10(locations) else x = locations
	binsize = x[1] - x[0]
 endif else begin
	if n_elements(binsize) eq 0 then begin
		if n_elements(Nbins) eq 0 then Nbins = 20
		binsize = (max(data_, min=min) - min)/float(Nbins)
	endif
 	if binsize eq 0 then binsize = 1.0
 	nh = ceil((max(data_,min=min) - min) / binsize)
 	binsize = (max(data_, min=min) - min)/nh
 	x = findgen(nh)*binsize + min(data_) + 0.5*binsize ; this may be in LOGARITHMIC UNITS!
 endelse
 b = binsize/2.

; now find the histogram
 s = sort(data_)
 v = value_locate(data_[s]+0., [x[0]-b, x+b])
 h = v[1:*] - v
 if v[0] GT -1 then h[0] = h[0] + n_elements(where(data_[s[0:v[0]]] eq (x[0]-b)))
 nh = n_elements(h)


if keyword_set(normalize) then begin
	;i = int_tabulated(x, float(h))
	i = total(h*binsize)
	h = h/float(i)
endif
if n_elements(multiplier) eq 0 then multiplier = 1.
h = h * multiplier

yr1 = [min(h),max(h)]
yr = yr1


if do_fit then begin

endif

if n_elements(psym) eq 0 then if keyword_set(intplot) then psym = 0 else psym=10

if keyword_set(intplot) then begin
	N = float(total(h)) ; total # of occurrences
	hi = fltarr(nh)
;	minx = min(x)
;	if minx GT 0 then
	for i = 0,nh-1 do hi[i] = total(h[0:i])/N
	h = hi
	if keyword_set(quartile) then begin ; calculate the quartiles
	 	percents = [0.25,0.5,0.75]
	 	quart = fltarr(3)
		for i =0,2 do begin
			m = min(abs(h-percents[i]),pi)
			quart[i] = x[pi]
		endfor
	endif
endif

if xlog then x_ = 10.^(x) else x_ = x

if not(keyword_set(noplot)) then begin
	if keyword_set(barplot) then begin
		barplot, x_, h, _extra=_extra, xlog=xlog, oplot=oplot
	endif else begin
		if keyword_set(oplot) then oplot, x_, h, psym=psym, _extra=_extra $
								 else plot, x_, h, psym=psym, _extra=_extra, xlog=xlog
	endelse

	if ( psym eq 10 AND ~keyword_set(barplot) AND ~keyword_set(intplot) ) then begin
		if !y.type eq 0 then y0 = !y.crange[0] $
			else y0 = 10^(!y.crange[0])
		cxr = !x.crange
		h0 = h[0] > y0
		xvec1 = ((x[0]-b) > cxr[0]) + [0,0]
		xvec2 = [x[0]-b, x[0]+.01*b] > cxr[0]
		if xlog then begin
			xvec1 = 10^xvec1
			xvec2 = 10^xvec2
		endif
		oplot, xvec1, [y0,h0], _extra = _extra
		oplot, xvec2, (h0 + [0,0]), _extra=_extra

		hn = h[nh-1] > y0
		xvec1 = ((x[nh-1]+b) > cxr[0]) + [0,0]
		xvec2 = [x[nh-1]+b, x[nh-1]-.01*b] < cxr[1]
		if xlog then begin
			xvec1 = 10^xvec1
			xvec2 = 10^xvec2
		endif
		oplot, xvec1, [y0,hn], _extra = _extra
		oplot, xvec2, (hn + [0,0]), _extra=_extra
	endif
	if do_fit then begin
		Nfit = 101
		xfit = findgen(Nfit)/(Nfit-1.) * (!x.crange[1]-!x.crange[0]) + !x.crange[0]
		if fit eq 2 then begin
			gparam = [0., mean(data), stddev(data)]
			gparam[0] = total(h)*binsize/sqrt(2*!pi*gparam[2]^2)
			gfit = gparam[0] * exp( -(xfit -gparam[1])^2/2./gparam[2]^2. )
		endif else begin
			gfit = gaussfit(x,h,gparam,n=3)
			gfit = gparam[0] * exp( -(xfit -gparam[1])^2/2./gparam[2]^2. )
		endelse
		residuals = h-gfit
		if keyword_set(res) then begin
			yr2 = [min(residuals),max(residuals)]
			yr = [min([yr1(0),yr2(0)]),max([yr1(1),yr2(1)])]
		endif
		oplot, xfit,gfit, _extra=_extra
		if keyword_set(text) then begin
		    smu = num2str(abs(gparam[1]))
		    if gparam[1] LT 0 then smu = '-' + smu
		    ssig = num2str(abs(gparam[2]))
		    if gparam[2] LT 0 then ssig = '-' + ssig
		    co_xyouts, /rel, 0.72,0.68-0.12*o, textoidl('\mu=')+smu, _extra = _extra
   		    co_xyouts, /rel, 0.72,0.62-0.12*o,textoidl("\sigma=")+ssig,  _extra =_extra
   		endif
	endif
	if (keyword_set(quartile) and keyword_set(intplot)) then begin ; add quartile legend
		if !y.type eq 0 then cyr = !y.crange $
			else cyr = 10^(!y.crange[0])
		if !x.type eq 0 then cxr = !x.crange $
			else cxr = 10^(!x.crange)
		oldpfont = !p.font
		!p.font = 0
		if n_elements(qx) eq 0 then qx = 0.65
		if n_elements(qy) eq 0 then begin
			if not(keyword_set(oplot)) then qy = 0.6 else qy = 0.55
		endif
		qx_ = [0,.08,.16] + qx
		qnam = ['25%','50%','75%']
		if n_elements(qtit) eq 0 then qtit = '!3Quartiles'
		if not(keyword_set(oplot)) then begin
			xyouts, qx+.03, qy + 0.12,qtit, /norm
			for i=0,2 do xyouts, qx_[i], qy+0.07, qnam[i], /norm
		endif

		for i = 0,2 do begin
			qdig = 2
			if abs(quart[i]) GT 10. then qdig=1
			if abs(quart[i]) GT 100 then qdig = 0
			xyouts, qx_[i], qy, num2str(quart[i],qdig), _extra=_extra, /norm
		endfor

		if keyword_set(qlabel) then xyouts, qx_[2] + .08, qy, qlabel, _extra=_extra, /norm

		!p.font = oldpfont
	endif
endif

x = temporary(x_)

end
