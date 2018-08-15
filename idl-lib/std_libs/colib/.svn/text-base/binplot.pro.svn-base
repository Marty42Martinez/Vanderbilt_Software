pro binplot, x_, data_, nbins, errors=errors, oplot=oplot, eplot=eplot,$
	 _extra=_extra,werr=werr,sdom=sdom, widths = widths, sort=sort

; Uses BINDATA to bin up the data (will optionally weight)

N = n_elements(x_)
if n_params() eq 2 then begin; called with 2 parameters
	nbins = data_
	data_ = x_
	x = lindgen(N)
endif else  begin ; called with 3 parameters
	x = x_
endelse
if keyword_set(sort) then begin
	s = sort(x)
	x = x[s]
	data = data_[s]
endif else data = data_
y = bindata(data, nbins, errors=errors, sdom=sdom,werr=werr, center=center)
xbin = x[round(center)]
if keyword_set(oplot) then oplot, xbin, y , _extra=_extra $
					  else plot, xbin, y, _extra=_extra
if keyword_set(eplot) then begin
	if n_elements(werr) ne 0 then begin
		eplot, xbin, y, werr, _extra=_extra
		m = bindata(y,1, errors= werr)
		m = m[0]
		rcs = total (   ((y-m)/werr)^2  )/(nbins-1.)
		rcs_0 = total( (y/werr)^2)/float(nbins)
		print, 'RCS of mean hypoth = ', rcs,'   mean = ', m
		print, 'RCS of zero hypoth = ', rcs_0
	endif else begin
		eplot, xbin, y, sdom, _extra=_extra
		m = bindata(y,1, errors= sdom)
		m = m[0]
		rcs = total (   ((y-m)/sdom)^2  )/(nbins-1.)
		rcs_0 = total( (y/sdom)^2)/float(nbins)
		print, 'RCS of mean hypoth = ', rcs, '   mean = ', m
		print, 'RCS of zero hypoth = ', rcs_0
	endelse


endif

END