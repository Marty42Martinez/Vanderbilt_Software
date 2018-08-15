pro wmean, datain, sigmain, wmn, wsig

nel = N_ELEMENTS(datain)
wmn =  (total(datain/sigmain^2))/(total(1./sigmain^2))
;READHEAD 4a
num = total( ( (datain - mean(datain))^2. )/sigmain^2.)
den = total(1./sigmain^2.)
wsig = sqrt(num/den/(nel-1))
;stddev of weighted mean READHEAD 4b
end

