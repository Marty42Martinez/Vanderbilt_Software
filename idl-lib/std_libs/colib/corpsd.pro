;+
; CORPSD
;
; AUTHOR:
;   Chris O'Dell
; 	Univ. of Wisconsin-Madison
;   Observational Cosmology Laboratory
;   Email: odell@cmb.physics.wisc.edu
;
; PURPOSE
;		Calculates and plots the Cross-Correlation Power Spectral Density
;		amplitude of two (real) data vectors.
;
; CALLING SEQUENCE
;
;  		corpsd, tod1, tod2, [, psdarr, f, nbins=nbins, $
;			/hann, /gauss, /welch, /bartlett, /oplot $
;			samp_rate=samp_rate, /nograph,  /zeropad $
;			/net, kill=kill, /full ]
;
; INPUT VARIABLES
; tod1		:	time-ordered data - float/double array of data, of first data set
; tod2 		:   second data set, with same # of elements as tod1
;
; OPTIONAL OUTPUT VARIABLES
; psdarr	:	the output power spectrum
; f			:	the frequency array corresponding to psdarr
;
; OPTIONAL KEYWORDS
; nbins		:	the # of power spectra to perform (and average together). Default is 1.
; oplot		:	indicates you should overplot
; nograph	: 	Set this to not generate a graph (you only want the PSD data)
; net 		:	Divides the power spectrum by the sqrt of 2, plots in sqrt(s) instead of Hz^-1/2
; kill 		: 	Kills large outliers above 'kill' frequency.  assumes basic white noise spectrum
; nomean 	:	Removes the mean before calculation
; Full 		: 	Don't take square root of psd
; zeropad 	:	 set this to use the routine ZERO_PAD to pad out to a multiple of 2 data points.
;					this will make the routine significantly faster, at the cost of slightly changing
;					the power spectrum.
; samp_rate	: 	The sampling rate, in Hz [default = 1 sample per second]
; hann,bartlett,welch,gauss:  which (if any) apodizing function to use.  Do NOT select more than one.
;
;
; DEPENDENCIES
;	ZERO_PAD (O'Dell Lib), TEXTOIDL
;-

PRO corpsd, tod1, tod2, psdarr, f, nbins=nbins, $
	hann=hann,gauss=gauss, welch=welch, bartlett=bartlett, oplot=oplot, $
	samp_rate = samp_rate, nograph = nograph,  _extra = _extra, zeropad=zeropad, $
	net = et, kill = kill, full=full


if n_elements(samp_rate) eq 0 then samp_rate = 1.0
; Find the binning with each samp# a power of 2, fitting as many as possible into the data.

N = n_elements(tod1)
if n_elements(nbins) eq 0 then nbins =1.
Nd = N/(nbins+1)
if (Nd/2 NE Nd/2.0) then Nd = Nd-1
Nb = 2*Nd

;Nyquist rate is f=1/2T=1/2*samp_rate
f= findgen(Nb/2.)*samp_rate/Nb

;calculate PSD
psdarr = fltarr(Nb/2.)
for i=0,nbins-1 do begin
	s1 = tod1[i*Nd:(i*Nd)+Nb-1] ; extract subset of data
    s2 = tod2[i*Nd:(i*nd)+Nb-1]
    if keyword_set(zeropad) then begin
        s1 = zero_pad(s1)
        s2 = zero_pad(s2)
    endif
    m = abs(mean(s1*s2))

    ;convolve with filters
    if (keyword_set(welch)) then begin
        w=findgen(Nb)
        w=1-((w-0.5*Nb)/(0.5*Nb))^2
        s1=s1*w
        s2=s2*w
    endif

    if (keyword_set(hann)) then begin
        w=findgen(Nb)
        w=(0.5)*(1-cos(2*!pi*w/Nb))
        s1=s1*w
        s2=s2*w
    endif

    if (keyword_set(gauss)) then begin
        w=findgen(Nb)-Nb/2
        w=exp(-w^2/(Nb^(1.5)))
        s1=s1*w
        s2=s2*w
    endif

    if (keyword_set(bartlett)) then begin
        w=findgen(Nb)
        w=1-abs((w-0.5*Nb)/(0.5*Nb))
        s1=s1*w
        s2=s2*w
    endif


    subpsd=2*(fft(s1) * conj(fft(s2)) )     ; this is a complex function!!
    subpsd[0]=subpsd[0]/2.
    subpsd[Nb/2]=subpsd[Nb/2]/2.
    subpsd = float(sqrt(subpsd*conj(subpsd)))

    ;subpsd = float(subpsd) ; take real part
    norm = 2*m/mean(subpsd[0:Nb/2])/samp_rate
    psdarr = subpsd[0:Nb/2]*norm/Nbins + psdarr;
endfor

if not (keyword_set(full)) then $
psdarr = sqrt(psdarr) ; convert to V/sqrt(Hz) (amplitude of PSD)

if keyword_set(kill) then begin
	; assume kill is great than 2 Hz
	mpf = min(abs(f-kill), fmk) ; fmk is the index of the value of f closest to the kill freq "kill".
	mpsd = mean(psdarr[fmk-51:fmk-1])
	sdpsd =stddev(psdarr[fmk-51:fmk-1])
	w = where( (psdarr[fmk:*] - mpsd) GT 5 * sdpsd)
	psdarr[w+fmk] = mpsd
endif

if n_elements(nograph) eq 0 then begin

	xrange=[0,samp_rate/2.]

	oldxstyle = !x.style
	oldystyle = !y.style
	!x.style = 1
	!y.style = 1
	if keyword_set(net) then begin
		psdarr = psdarr / sqrt(2)
		ytit_ = textoidl('\PSD Amplitude [V sec^{1/2}]')
	endif else begin
		if keyword_set(full) then ytit_ = tex('PSD [mK^2 Hz^{-1}]') $
			else ytit_ = textoidl('PSD Amplitude [V Hz^{-1/2}]')
	endelse
	if (keyword_set(oplot)) then begin
		oplot,f,psdarr, _extra = _extra
	endif else begin
		plot,f,psdarr,xtitle='Frequency [Hz]',$
		ytitle=ytit_, _extra=_extra
	endelse
	!x.style = oldxstyle
	!y.style = oldystyle

;   FOR DEBUGGING PURPOSES ONLY:
;	print,abs((total(tod1*tod2))/float(N))       ; print time-power integral
;	print,(mean(psdarr^2)*samp_rate/2.)  ; print integral of PSD

endif


end



