PRO GET_PSD,tod,psd,f,YLOG=YLOG,charsize=charsize,xlog=xlog,VrtHz=VrtHz,welch=welch,op=op,color=color, $
	xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax,av=av,hann=hann,bartlett=bartlett,gauss=gauss


s=tod




;sampling rate in Hz
samp_rate=160
N=n_elements(s)
print,n
;Nyquist rate is f=1/2T=1/2*samp_rate
f=(findgen(N/2.)+1.)*samp_rate/N

if (keyword_set(welch)) then begin
	w=findgen(N)
	w=1-((w-0.5*N)/(0.5*N))^2
	s=s*w
endif


if (keyword_set(hann)) then begin
	w=findgen(N)
	w=(0.5)*(1-cos(2*!pi*w/N))
	s=s*w
endif



if (keyword_set(gauss)) then begin
	w=findgen(N)-N/2
	w=exp(-w^2/(N^(1.5)))
	s=s*w
	
endif

psd=2*abs(fft(s))^2

psd[0]=psd[0]/2
psd[N/2-1]=psd[N/2-1]/2

psd=psd(0:N/2-1)

;normalize
norm=total(psd*160./N)
psd=((total(s^2))/n)*psd/norm
psd=sqrt(psd)

if (n_elements(charsize) eq 0) then charsize=2.5

if (n_elements(xmin) eq 0) then xmin=f[1]
if (n_elements(xmax) eq 0) then xmax=max(f)
if (n_elements(ymin) eq 0) then ymin=min(psd)
if (n_elements(ymax) eq 0) then ymax=max(psd)

if (keyword_set(op)) then begin
	oplot,f,psd,color=color
endif else begin

plot,f,psd,xtitle='Frequency(Hz)',ytitle=textoidl('PSD (V Hz^{-1/2})'),   $
	ylog=ylog,xlog=xlog,charsize=charsize, xrange=[xmin,xmax],yrange=[ymin,ymax],color=color
endelse


print,((total(s^2))/n)
print,(total(psd^2)*160/N)


end
