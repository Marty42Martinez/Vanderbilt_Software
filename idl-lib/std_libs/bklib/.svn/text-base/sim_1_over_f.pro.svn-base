pro sim_1_over_f,bs_fr_n

n = 9000. ; number of samples per hour file
nel = 2.*n; for simplicity to make ffts

psd1f = fltarr(nel/2)
fny = 2./nel; nyquist freq in sampls
fk = 1000000.; knee freq in units of nyq
noizamp = 1.; variance of noise in the TOD

for i = 0,nel/2.-1 do psd1f[i] = noizamp*(1.+fk/float(i+1.)); psd of 1/f noise

psd1f = psd1f/total(psd1f);+randomu(2,nel/2.)/sqrt(2.)

real = sqrt(psd1f[0:nel/2.-1])*randomn(seed,nel/2.)
imag = sqrt(psd1f[0:nel/2.-1])*randomn(seed,nel/2.)

fff = complex(real , reverse(imag))

oneovf = fft(fff,/inverse,/double)

uamp = 11.; amp of U simulated
sig = uamp*sin(4.*3.14*indgen(9000.)/600); fake signal

dat=sig+float(oneovf)

map = fltarr(600)
nrot = nel/600/2
for i = 0,nrot-1 do map = map + dat[i*600.:(i+1.)*600-1]
map = map/nrot

fk = 20.
filtnoiseamp = 1.
filt = (fk/(fk+ indgen(9000.)))+filtnoiseamp; here is the filter
; you will want to fit for fk and filtnoiseamp

fftd = fft(dat,/double); fft of fake data

;apply the filter and normalize this makes new data
;this is the convolution N^-1 y step done with FFT's
;note that it preserves phase
newd= float(fft(((fftd/filt)/total(1./filt)),/inv,/doub)*n)

goodmap = fltarr(9000.)
;then do A^T newdata to bin it into rotations:
for i = 0,nrot-1 do goodmap = goodmap + newd[i*600.:(i+1.)*600-1]
goodmap=goodmap/nrot

;try plotting psd of newd and dat
;and plot goodmap vs map for various 1/f and
;signal simulations

end