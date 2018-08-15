pro make_polar_filter,bs_ir_n,bs_fr_n,nfilt,res

;this pro takes in the filter in the time domain: bs_ir_n
;and  in the freq domain: bs_fr_n
;and makes a Max like cirulant filter matrix
;it also simulates data with 1-phi [cos and sin]
;2-phi [q,u]  a slope [to simulate 1/f]
;and white noise

nel = nfilt;9000.
n = 1.;noise amplitude
c = 1; c amp
s = 1.;sin ampl
u = 1.;u ampl
q= 1.;q amp

slope = 0.;slope amp

rotscl = nel/9000.; scale filter and data so things plot right
;when we assume POLAR: 20Hz sample rate, 2 rpm rotation rate

nz = n*randomn(seed,nel)

twophi = q*cos(20*rotscl*6.28*indgen(nel)/nel)+$
u*sin(20*rotscl*6.28*indgen(nel)/nel)

onephi = c*cos(10*rotscl*6.28*indgen(nel)/nel)+$
s*sin(10*rotscl*6.28*indgen(nel)/nel)

drift=slope*indgen(nel)/nel

sig = twophi+onephi+drift

dat = sig + nz

ynew = fltarr(nel)

;apply D as reform(D##y) using circulant trix
for i = 0, nel-1 do ynew[i] = total(shift(bs_ir_n,nel/2+i)*dat)

;ynew has only Q and U and noise .
; Mean,Drifts,C,S, are all gone after filtering

res = stddev(ynew-nz -twophi)
asdf

end