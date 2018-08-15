function bindata, data, nbins, sd, ninbin, sdom=sdom, nomean=nomean, $
			errors=errors, werr=werr,center=center, widths=widths

; INPUTS
;	data : array of #s
;	nbins : # of bins to bin to.  bins <= n_elements(data)
;
; OUTPUTS
;	return value: array of nbins #s (data averaged into bins)
;	sd	: 	the standard dev. of points that went into the binned data
;	ninbin: the # of data points that went into each bin
;
; KEYWORDS
;	nomean : removes the mean of the data from the binned data
;   sdom : the standard dev. of the mean
;   avdev : the rms deviation within a bin from the OVERALL mean (a weird quantity)
;   weights: weights to be applied to each parent point (will also weight resulting error)

av = fltarr(nbins)
sd = fltarr(nbins)
ninbin = fltarr(nbins)
widths = fltarr(nbins)

if not(keyword_set(nomean)) then m=0.

p = n_elements(data)
BP = round(lindgen(nbins+1L)/float(nbins) * p) ;starting element # of each bin
center = (BP[1:nbins] + BP[0:nbins-1] - 1)/2.0
m = comean(data)
if n_elements(errors) eq 0 then begin	; NO WEIGHTING
	for bin=0L,nbins-1 do begin
	  n = BP(bin+1) - BP(bin)		; # of data points falling in this bin
	  ninbin[bin] = n
	  relevant = data(BP(bin):BP(bin+1)-1)
	  av[bin] = comean(relevant)
	  if n eq 1 then sd[bin] = av[bin] else sd[bin] = stddev(relevant)
	  widths[bin] = max(relevant) - min(relevant)
	endfor
endif else begin					; WEIGHTING
	werr = sd
	for bin=0,nbins-1 do begin
	  n = BP(bin+1) - BP(bin)		; # of data points falling in this bin
	  ninbin[bin] = n
	  y = data(BP(bin):BP(bin+1)-1)
	  e = errors(BP(bin):BP(bin+1)-1)
	  wi = 1/e^2 /total(1/e^2)
	  av[bin] = total(wi*y)
	  werr[bin] = sqrt(1.0/total(1/e^2))
	  widths[bin] = max(y) - min(y)
	  if n eq 1 then sd[bin] = werr[bin] else sd[bin] = sqrt(total(wi* (y - av[bin])^2))
	endfor
endelse

if keyword_set(nomean) then av = av - m
sdom = sd/sqrt(ninbin)
return, av

END