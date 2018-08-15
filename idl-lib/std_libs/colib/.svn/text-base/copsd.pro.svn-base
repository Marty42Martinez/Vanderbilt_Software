;+
; COPSD
;
; AUTHOR:
;   Chris O'Dell
; 	 Univ. of Wisconsin-Madison
;   Observational Cosmology Laboratory
;   Email: odell@cmb.physics.wisc.edu
;
; PURPOSE:
;		Calculates and plots the Power Spectral Density Amplitude of a (real) data vector.
;
; CALLING SEQUENCE:
;
;  		COPSD, tod [, psdarr, f, samp_rate=samp_rate, nbins=nbins, $
;			 /nograph, /careful, /zeropad, $
;			/hann, /gauss, /welch, /bartlett, $
;			/net, kill=kill, /full ]
;
;
; DESCRIPTION:
;	 copsd computes the power spectrum of a data set, and optionally plots the result.
;
; INPUT VARIABLES:
; tod		:	time-ordered data - float/double 1D array of data
;
; OPTIONAL OUTPUT VARIABLES:
; psdarr	:	the output power spectrum
; f			:	the frequency array corresponding to psdarr
;
; OPTIONAL KEYWORDS:
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
; careful   : Setting this will calculate the rough running time of the
;					calculation.  Requires access to "FACTOR" procedure in the astrolib.

; samp_rate	: 	The sampling rate, in Hz [default = 1 sample per second]
; hann,bartlett,welch,gauss:  which (if any) apodizing function to use.  Do NOT select more than one.
;
;
; DEPENDENCIES:  IF CAREFUL=1 then requires PRIME and FACTOR from the Astrolib.
;		   			(available at http://idlastro.gsfc.nasa.gov/homepage.html)
;					  IF CAREFUL=0 or not set, then no dependencies.
;
;
; NOTES
;
; 1. The user is strongly advised to set the "CAREFUL" keyword.
;    if the sum of the prime factors of the number of elements in
;    TOD is very large, the computation could take an inordinate
;	  amount of time.  In this case, the user is advised to set
;	  the keyword ZERO_PAD. To use the CAREFUL keyword, IDL must
;	  have access to the procedures PRIME and FACTOR found in the astrolib
;    available at http://idlastro.gsfc.nasa.gov/homepage.html .
;
; 2. By setting the NBINS keyword to an integer greater than 1, COPSD
;    will take the psd of multiple sections of the input data vector TOD,
;    and average them together in such a way as to reproduce the best possible
;    estimate of the power spectrum.  The technique used is that of Welch, described
;    in section 13.4 of "Numerical Recipes".  The data vector is broken
;    up into NBINS sections each of length 2*Nd, such that
;    they overlap each other by half their length. If the original data vector has
;    N elements, then N = (Nbins+1)*Nd.  This means that the length of each
;    subsegment is Nb = 2*Nd = 2*N/(Nbins+1).
;
;	  This can clearly lead to a tricky situation if Nbins+1 is some funky odd
;   number, or N is not a nice number (say it is prime or something).
;	 Again, the user is cautioned to set the keyword CAREFUL, which will check
;   on the rough expected calculation time and warn you if it will be too long
;   (roughly > 1 minute).
;
;  MODIFICATION HISTORY:
;		6/15/2003:  -Added keyword CAREFUL to estimate calculation time.
;						-Removed Dependence on TEXTOIDL and ZERO_PAD procedures.
;-

PRO copsd, tod, psdarr, f, nbins=nbins, $
	hann=hann,gauss=gauss, welch=welch, bartlett=bartlett, oplot=oplot, $
	samp_rate = samp_rate, nograph = nograph,  _extra = _extra, zeropad=zeropad, $
	net = et, kill = kill, full=full, careful=careful, nomean = nomean


if n_elements(samp_rate) eq 0 then samp_rate = 1.0
; Find the binning with each samp# a power of 2, fitting as many as possible into the data.

N = n_elements(tod)
if n_elements(nbins) eq 0 then nbins =1

Nd = N/(nbins+1) ; the length of each bin will be 2*Nd samples.
Nb = 2*Nd

;Nyquist rate is f=1/2T=1/2*samp_rate
f= findgen(Nd)*samp_rate/Nb
meantod = mean(tod)
;calculate PSD
psdarr = fltarr(Nd)
for i=0,nbins-1 do begin
	; NEW Method:
	s = tod[i*Nd:(i*Nd)+Nb-1] ; extract subset of data
	if keyword_set(nomean) then s = s - meantod
	m = mean(s^2)
	if keyword_set(zeropad) then begin
		j = ceil(alog(Nb)/alog(2))
		if (2L^j ne Nb) then s = [s,0*s[0:2L^j-Nb-1]]
	endif

; compute rough running time and abort if necessary
	if keyword_set(CAREFUL) AND (i eq 0) then begin
		ns = n_elements(s)
		factor, ns, factors, multiplicity, /quiet
		prop = total(factors*multiplicity) * ns * Nbins ; propto total running time.
		if prop GT (1e10) then begin
			user_answer = ''
			read, user_answer, $
			  prompt='Running Time will probably be > 1 minute.'+ $
			 'Would you like to continue (Y/N)?: '
			if strupcase(user_answer) eq 'N' then begin
				print, 'COPSD aborted without calcuation.'
				goto, no_calculation
			endif
		endif
	endif

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
		ytit_ = 'PSD Amplitude [V sec!U1/2!N]'
	endif else begin
		if keyword_set(full) then ytit_ = 'PSD [mK!U2!N Hz!U-1!N]' $
			else ytit_ = 'PSD Amplitude [V Hz!U-1/2!N]'
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
;	print,((total(tod^2))/float(N))       ; print time-power integral
;	print,(mean(psdarr^2)*samp_rate/2.)  ; print integral of PSD

endif

no_calculation:

end
