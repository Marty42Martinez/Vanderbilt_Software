FUNCTION BinAv, Dataarr, startrot, stoprot, bins

dataav = fltarr(bins)
datasd = fltarr(bins)

if (stoprot - startrot) gt 0 then begin
	for j = 0,bins-1 do begin
		dataav[j] =  mean(dataarr(j,startrot:stoprot))
		datasd[j] =  stddev(dataarr(j,startrot:stoprot));/sqrt(stoprot-startrot)
	endfor
endif

return, dataav

end