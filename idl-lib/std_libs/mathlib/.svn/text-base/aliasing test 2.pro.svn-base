; aliasing program

fline = 10.45*2 ; frequency of sine wave signal
maxtime= 60. ; length of timestream
dt = 0.001 ; initial (fast) sampling period
samp = 8. ; sampling rate

Ntot = round(maxtime/dt)
time = findgen(Ntot)/Ntot * maxtime
s = sin(fline * 2 * !pi * time)

N2 = Ntot * (dt * samp)

daq2 = bindata(s,n2)

END
