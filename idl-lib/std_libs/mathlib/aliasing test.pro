; aliasing program

fline = 18.3 ; frequency of sine wave signal
maxtime= 60. ; length of timestream
dt = 0.001 ; initial (fast) sampling period
samp = 8. ; sampling rate

Ntot = round(maxtime/dt)
time = findgen(Ntot)/Ntot * maxtime
s = sin(fline * 2 * !pi * time)
Ns = fix(max(time) * samp) + 1 ; # of samples in sampled signal

w = round(lindgen(Ns) * float(Ntot)/float(Ns))
daq = s[w]

; this does averaging then sampling
N2 = Ntot * (dt * samp)
daq2 = bindata(s,n2)

copsd, daq, samp = samp, /ylog, yr= [1e-7,10]
copsd, daq2, samp = samp, /ylog, /oplot, col = 50
copsd, s, samp = 1/dt, /ylog, /oplot, col = 250

END
