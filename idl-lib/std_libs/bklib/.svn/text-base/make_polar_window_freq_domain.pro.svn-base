pro make_polar_window_freq_domain

;samp per


delt = 1./20.

nsteps = 20.
;resarr = fltarr(nsteps)
;phiarr= fltarr(nsteps,7)
;magarr= fltarr(nsteps,7)

hpfreq = 0.01*indgen(nsteps)/nsteps+.035

;for yy = 0,nsteps-1 do begin
; Frequencies above f_low will be passed:
;f_low = hpfreq[yy];0.039
f_low = 0.03975; produces lowest residuals and 0 phase shift
; Frequencies below f_high will be passed:
f_high = 0.5*1./delt

; The length of the filter:
nfilt = 9000.; this is also the length of the TOD
;note: this should be 9000, but if it is
;IDL crashes when I try to allocate memory for D matrix

f_filt = FINDGEN(nfilt/2+1) / (nfilt*delt); freq index


; Pass frequencies greater than f_low and less than f_high:
ideal_fr = (f_filt GT f_low); OR (f_filt LT F_high)

; Convert from byte to floating point:
ideal_fr = FLOAT(ideal_fr)

; Replicate to obtain values for negative frequencies:
ideal_fr = [ideal_fr, REVERSE(ideal_fr[1:*])]

; Now use an inverse FFT to get the impulse response
; of the ideal filter:
ideal_ir = FLOAT(FFT(ideal_fr, /INVERSE))

; Ideal_fr is an even function, so the result is real.
; Scale by the # of points:
ideal_ir = ideal_ir / nfilt

; Shift it before applying the window:
ideal_ir = SHIFT(ideal_ir, nfilt/2)

; Apply a Hanning window to the shifted ideal impulse response.
; These are the coefficients of the filter:
bs_ir_n = ideal_ir*HANNING(nfilt,ALPHA=.56);alpha = .5 for hanning, .56 for hamming

; The frequency response of the filter is the FFT
; of its impulse response. Scale by the number of points:
bs_fr_n = FFT(bs_ir_n) * nfilt

; Create a log plot of magnitude in decibels
; Magnitude of Hanning bandstop filter transfer function:
mag = ABS(bs_fr_n(0:nfilt/2))
PLOT, f_filt, 20*ALOG10(mag), YTITLE='Magnitude in dB', $
   XTITLE='Frequency in cycles / second', /XLOG, $
   XRANGE=[1./1000.,1.0/(2.0*delt)], XSTYLE=1, yr = [-40,10],$
   TITLE='Frequency Response for Bandstop!CFIR Filter (Hanning)'

make_polar_filter,bs_ir_n, bs_fr_n,nfilt,res
;this sends the correlation function of the filter
;to the other program which actually makes the filter
;matrix and tests it

;resarr[yy] = res
;phiarr[yy,*] = atan(bs_fr_n[27:33])
;magarr[yy,*] = abs(bs_fr_n[27:33])
;print,yy, hpfreq[yy],res
;endfor
;plot, hpfreq,resarr

end