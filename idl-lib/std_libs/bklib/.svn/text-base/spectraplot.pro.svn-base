FUNCTION psd, data, samples, samplerate, datapoints,df
;note: the spectrum of a sinwave of amplitude A, freq f, is
;A/2 at f and -f
;the power spectrum (PS) is  (A/2)^2 = A^2/4 at f and -f
;the sqrt(PS) = A/2 at f and -f
;the PSD is PS/npts
;total(psd)/npts = variance of sinewave in = A^2/2
;total(psd)_0^f from 0 to f is sigma

m = datapoints/samples
time = datapoints/samplerate

shorttime=samples/samplerate

print,'datapoints=',datapoints
print,'samplerate=',samplerate;Hz
print,'time in seconds',time
print,'short time=',shorttime
psdarray = fltarr(samples,m)
for i = 0L,(m-1) do begin
        q = fft(data[i*samples:(i+1)*samples-1]); see Num Recipes p.492
		nelq = N_ELEMENTS(q)
		psdarray(*,i) = 2.*(abs(q))^2.*samples/samplerate
        ;note:
		;samples/samplerate = N/N/sec = sec
        ; IDL fft = fft/N and P(f) = fft^2/N^2
        ; so abs(q)^2/N^2 = this is what Whalen p. 54 calls P(f)
        ;P(f)/df = S(f) = PSD
        ;so abs(q)^2 is two-sided PSD. to get onesided, I just double
        ;and only plot from 0 to +f

endfor
psdavarray = fltarr(samples)
for j = 0l,(samples - 1) do begin
    h = psdarray(j,0:(m-1))
    psdavarray(j) = comean(h)
end
RETURN, psdavarray
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro spectraplot, signal,samples,freqscale,F,amplitude, overplot = overplot, color = col , acfon = acfon
ERR = N_PARAMS()

IF (ERR EQ 1) THEN GOTO, JUMP
sampleper = 1./20.; sample period in seconds = 30 for sampled every rotation
samplerate = 1./sampleper; sample rate in Hertz

print, 'samples per second: ',samplerate

datapoints = N_ELEMENTS(signal);total number of data points in file
;samples = number of samples to be taken at a time in psd averages

if keyword_set(acfon) then begin
	!p.multi = [0,1,2]
endif else !p.multi = [0,1,1]

F = FINDGEN(samples/2+1)/(samples*sampleper)
nf = N_ELEMENTS(F)

df = F[nf -1.]/(nf)
print,'nf=',nf
print,'1./dF=',1./df

psdavarray = psd(signal,samples,samplerate,datapoints,df)

amplitude = sqrt(psdavarray)
nelamp = N_ELEMENTS(amplitude)

print, 'mean amplitude=', mean(amplitude(1:9))

print, 'max freq',F[nf-1]
acorr = fft(psdavarray,-1)
psdrms = mean(amplitude[5:9])
print, 'rms from psd=', psdrms
print, 'rms from time series', stddev(signal)
print, 'rms from ACF(0)', abs(sqrt(acorr[0]))


ymaxscale = 100; scale factor for y axis
yminscale = .1

if keyword_set(overplot) then begin
oplot, F, amplitude,linestyle = 0,color = col
endif else plot, F, amplitude,XRANGE = [0.0001,1.0/(2*sampleper*freqscale)], $
	yrange = [yminscale*min(amplitude),ymaxscale*(amplitude(nf/4))],ystyle = 1, XSTYLE = 1, $
	ytitle = '!6!4D!5T!Irms!N  [K-s!E1/2!N]', xtitle = 'Frequency [Hz]',$
	title = ' Power Spectral Density: Viewing 100% Polarized 77 K Load',$
	/ylog,linestyle = 0,charsize = 1.1



bins = findgen(samples/2 + 1)*sampleper
print, 'number of frequency bins=',nf
if keyword_set(acfon) then plot, bins[0:(nf-1)/10.], abs(acorr[0:(nf-1)/2.]),/ylog, ytitle = 'ACF', xtitle = 'Lag [s]'
print, 'mean square amplitude=',total(signal^2)/datapoints
print, 'frequency integral of psd from 0 to 10 Hz = variance=',total(psdavarray[1:nf-1]*df)


JUMP: if err eq 1 then PRINT, "NOT ENOUGH PARAMETERS IN SPECTRAPLOT CALL"

end
