PRO scpsd,tod,psdarr,f,YLOG=YLOG,charsize=charsize,xlog=xlog,VrtHz=VrtHz,welch=welch,op=op,color=color, $
	xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax,av=av,hann=hann,bartlett=bartlett,gauss=gauss, nbins=nbins, $
	linesty=linesty, psym=psym, title=title


;sampling rate in Hz
samp_rate=20.
N=n_elements(tod)
if n_elements(nbins) eq 0 then nbins = 1
Nb = N/nbins
;print,n
;Nyquist rate is f=1/2T=1/2*samp_rate
f=(findgen(Nb/2.)+1.)*samp_rate/Nb


;calculate PSD
psdarr = fltarr(Nb/2)
for i=0,nbins-1 do begin

	s = tod[i*Nb:(i+1)*Nb-1] ; extract subset of data

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

	subpsd=2*abs(fft(s))^2
	subpsd[0]=subpsd[0]/2.
	subpsd[Nb/2-1]=subpsd[Nb/2-1]/2.

	psdarr = subpsd(0:Nb/2-1) * Nb/samp_rate * 1./nbins + psdarr ; calculates mean of individual psd's
endfor

psdarr = sqrt(psdarr) ; convert to V/sqrt(Hz) (amplitude of PSD)

if (n_elements(charsize) eq 0) then charsize=1.5

if (n_elements(xmin) eq 0) then xmin=f[1]
if (n_elements(xmax) eq 0) then xmax=max(f)
if (n_elements(ymin) eq 0) then ymin=min(psdarr)
if (n_elements(ymax) eq 0) then ymax=max(psdarr)

if (keyword_set(op)) then begin
	oplot,f,psdarr,color=color
endif else begin

plot,f,psdarr,xtitle='Frequency(Hz)',ytitle=textoidl('psdarr (V Hz^{-1/2})'),   $
	ylog=ylog,xlog=xlog,charsize=charsize, xrange=[xmin,xmax],yrange=[ymin,ymax],color=color, $
	psym=psym, linesty=linesty, title=title
endelse


print,((total(tod^2))/N)       ; print time-power integral
print,(mean(psdarr^2)*samp_rate/2.)  ; print integral of PSD

end
