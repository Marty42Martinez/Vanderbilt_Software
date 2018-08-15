delt = 0.02	;Sampling period in seconds.
f_low = 15.0	;Frequencies above f_low will be passed.
f_high = 7.0	;Frequencies below f_high will be passed.
nfilt = 31	;The length of the filter.
f_filt = FINDGEN(nfilt/2+1) / (nfilt*delt)
ideal_fr = (f_filt GT f_low) $	;Pass frequencies greater than f_low.
    OR (f_filt LT F_high)	;Pass frequencies less than f_high.
ideal_fr = FLOAT(ideal_fr)	;Convert from byte to floating point.

;Replicate to obtain values for negative frequencies:

ideal_fr = [ideal_fr, REVERSE(ideal_fr[1:*])]

;Now use an inverse FFT to get the impulse response of the ideal filter:

ideal_ir = FLOAT(FFT(ideal_fr, /INVERSE))
;Ideal_fr is an even function, so the result is real.
ideal_ir = ideal_ir / nfilt	;Scale by the # of points.
ideal_ir = SHIFT(ideal_ir, nfilt/2)	;Shift it before applying the window.

;Apply a Hanning window to the shifted ideal impulse response:

bs_ir_n = ideal_ir*HANNING(nfilt)	;These are the coefficients of the filter.

;The frequency response of the filter is the FFT of its impulse response:

bs_fr_n = FFT(bs_ir_n) * nfilt	;Scale by the number of points.

;Create a log plot of magnitude in decibels:

mag = ABS(bs_fr_n(0:nfilt/2))	;Magnitude of Hanning bandstop filter transfer function.
PLOT, f_filt, 20*ALOG10(mag), YTITLE='Magnitude in dB', $
    XTITLE='Frequency in cycles / second', /XLOG, $
    XRANGE=[1.0,1.0/(2.0*delt)], XSTYLE=1, $
    TITLE='Frequency Response for Bandstop!CFIR Filter (Hanning)'

;Alternately, you can run the following batch file to create the plot:
END