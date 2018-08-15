PRO copsd_old,tod,psdarr,f, nbins=nbins, $
	hann=hann,gauss=gauss, welch=welch, bartlett=bartlett, $
	oplot=oplot, xrange=xrange, yrange=yrange,$
	samp_rate = samp_rate, nograph = nograph, _extra = _extra

; copsd computers the power spectrum of a data set, and plots the result.
; NOTE: you must make sure the variable samp_rate is set correct below before compiling.
;
;
; PARAMETERS
; tod		time-ordered data - float/double array of data
; psdarr	the output power spectrum
; f			the frequency array corresponding to psdarr

; KEYWORDS
; nbins		the # of power spectra to perform (and average together). Default is 1.
; hann,bartlett,welch,gauss:  which (if any) apodizing function to use.  Do NOT select more than one.
; op		indicates you should overplot
; linsty,psym,title,xrange,yrange,color,charsize,xlog,ylog : standard PLOT keywords
; nograph 	Set this to not generate a graph (you only want the PSD data)

N = n_elements(tod)
if n_elements(nbins) eq 0 then nbins =1

;sampling rate in Hz
if n_elements(samp_rate) eq 0 then samp_rate=20.05
;OLD method
 	Nb = N/nbins
;NEW method
; Find the binning with each samp# a power of 2, fitting as many as possible into the data.
;Nd = N/(nbins+1)
;if (Nd/2 NE Nd/2.0) then Nd = Nd-1
;Nb = 2*Nd

;Nyquist rate is f=1/2T=1/2*samp_rate
f= findgen(Nb/2.)*samp_rate/Nb

;print, Nb

;calculate PSD
psdarr = fltarr(Nb/2.)
for i=0,nbins-1 do begin
; OLD Method:
	s = tod[i*Nb:(i*Nb)+Nb-1]
; NEW Method:
;	s = tod[i*Nd:(i*Nd)+Nb-1] ; extract subset of data

 	m = mean(s^2)

	;convolve with filters
	if (keyword_set(welch)) then begin
		w=findgen(Nb)
		w=1-((w-0.5*Nb)/(0.5*Nb))^2
		s=s*w
	endif

	if (keyword_set(hann)) then begin
		w=findgen(Nb)
		w=(0.5)*(1-cos(2*!pi*w/Nb))
		s=s*w
	endif

	if (keyword_set(gauss)) then begin
		w=findgen(Nb)-Nb/2
		w=exp(-w^2/(Nb^(1.5)))
		s=s*w
	endif

	if (keyword_set(bartlett)) then begin
		w=findgen(Nb)
		w=1-abs((w-0.5*Nb)/(0.5*Nb))
		s=s*w
	endif

	subpsd=2*abs(fft(s))^2
	subpsd[0]=subpsd[0]/2.
	subpsd[Nb/2-1]=subpsd[Nb/2-1]/2.

    norm = 2*m/mean(subpsd[0:Nb/2-1])/samp_rate
	psdarr = subpsd[0:Nb/2-1]*norm/Nbins + psdarr;
endfor

psdarr = sqrt(psdarr) ; convert to V/sqrt(Hz) (amplitude of PSD)

if n_elements(nograph) eq 0 then begin
	if (n_elements(charsize) eq 0) then charsize=1.5

	if n_elements(xrange) eq 0 then xrange=[0,samp_rate/2.]
	if n_elements(yrange) eq 0 then begin
		x1 = findclosest(xrange[0],f)
		x2 = findclosest(xrange[1],f)
		if not keyword_set(ylog) then yrange=getrange(psdarr[x1:x2]) else yrange=getrange(psdarr[x1:x2],pad=0.)
	endif
	oldxstyle = !x.style
	oldystyle = !y.style
	!x.style = 1
	!y.style = 1
	if (keyword_set(oplot)) then begin
		oplot,f,psdarr, _extra = _extra
	endif else begin

	plot,f,psdarr,xtitle='Frequency(Hz)',ytitle=textoidl('psdarr (V Hz^{-1/2})'), $
		 xrange=xrange, yrange=yrange, _extra=_extra
	endelse
	!x.style = oldxstyle
	!y.style = oldystyle

	print,((total(tod^2))/float(N))       ; print time-power integral
	print,(mean(psdarr^2)*samp_rate/2.)  ; print integral of PSD
endif




end
