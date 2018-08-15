function polar_1f,signal,f_knee, samp_rate=samp_rate, nbins=nbins

; Based on Sean Cordone's "make_1f", this program assumes the "white noise"
; section of the signal can be accurately sampled by the periodogram estimate
; of the power spectrum between 1. and 3. Hz. (this, however, can be easily
; changed in the call to "noise", when calculating the noise level.

; if the signal has big drifts in it already, this algorithm will do very
; little to the signal.  Works best on noise closest to white/stationary noise.

if n_elements(nbins) eq 0 then nbins = 16
if n_elements(samp_rate) eq 0 then samp_rate = 20.

sigma_ = noise(signal, samp_rate=samp_rate, nbins = nbins) * sqrt(samp_rate/2.)
seed = randomseed()
white = randomn(seed,n_elements(signal))*sigma_

return, signal + make_1f(white,f_knee, samp_rate=samp_rate) - white

end

