function bindata_weight, data, nbins, sd, binsizes, sdom=sdom, nomean=nomean, avdev=avdev, weights=weights

; INPUTS
;	data : array of #s
;	nbins : # of bins to bin to.  bins <= n_elements(data)
;
; OUTPUTS
;	return value: array of nbins #s (data averaged into bins)
;	sd	: 	the standard dev. of points that went into the binned data
;	binsizes: the # of data points that went into each bin
;
; KEYWORDS
;	nomean : removes the mean of the data from the binned data
;   sdom : the standard dev. of the mean
;   avdev : the rms deviation within a bin from the OVERALL mean (a weird quantity)
;   weights : optional weights with which to determine averages and standard deviations of binned data
;			  (should ideally weight as 1/sigma^2)

av = fltarr(nbins)
sd = fltarr(nbins)
avdev = fltarr(nbins)
binsizes = fltarr(nbins)

w = weights/norm ; (weights are now normalized)

if not(keyword_set(nomean)) then m=0.

p = n_elements(data)
BP = round(indgen(nbins+1)/float(nbins) * p) ;starting element # of each bin
if n_elements(weights) eq 0 then weights = fltarr(p) + 1.0


for bin=0,nbins-1 do begin
  n = BP(bin+1) - BP(bin)				; # of data points falling in this bin
  binsizes[bin] = n
  relevant = data(BP(bin):BP(bin+1)-1)	; data for this bin
  wb       = weights(BP(bin):BP(bin+1)-1)   	; weights for this bin
  w = wb/total(wb)
  av[bin] = total(w * relevant)
  sd[bin] = total(w * (relevant - av[bin])^2)
endfor

if keyword_set(nomean) then av = av - m
sdom = sd/sqrt(binsizes)
return, av

END