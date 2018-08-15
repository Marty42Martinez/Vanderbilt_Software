function dedrift, data, doffset,hour=hour, nbins=nbins

Q = 9000L

if n_elements(hour) eq 0 then begin
	N = N_ELEMENTS(data)
	if n_elements(nbins) eq 0 then nbins=10L
	Nbins = long(Nbins)
	binsize= N/float(Nbins) ; real
	ddrifted = fltarr(N)
	doffset = fltarr(N)
	for i = 0L,Nbins-1 do begin
	    e0 = round(i*binsize)
	    e1 = round((i+1)*binsize)-1
		drift = data[e0:e1]
		t = lindgen(e1-e0+1)
		res = linfit(t,drift)
		ddrifted[e0:e1] = drift - res[0] - res[1]*t
		doffset[e0:e1] = drift-ddrifted[e0:e1]
	endfor
endif else begin
	hf = nel(data(0,*))
	ddrifted = data
	doffset = data
	for i=0,hf-1 do begin
		t = lindgen(Q)
		res = linfit(t,data(*,i))
		ddrifted[*,i] = data(*,i) - res[0] - res[1]*t
		doffset[*,i] = data(*,i) - ddrifted[*,i]
	endfor
endelse

return, ddrifted
end
