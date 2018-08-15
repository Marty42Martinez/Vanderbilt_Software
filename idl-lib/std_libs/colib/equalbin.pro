function equalbin, f, nbins, show=show,newf=newf

; takes a (uniformly?) distributed function
; and calculates an intelligent logarithmic binning.

nf = n_elements(f)
tops = lonarr(nbins)
newf = f[0:nbins-1]*0.

lo = min(f)
hi = max(f)
ran = hi-lo

q = 1e-5
edges = lo + (hi-lo)*(1+q)*(findgen(nbins+1)-q/2)/nbins

if keyword_set(show) then begin
plot, f, yr = [lo-ran*0.1,lo+ran*1.1], $
	xr=[-0.1*nf,nf*1.1], psym = 4
hline, edges
print, edges[0], edges[nbins]
endif

for i = 0,nbins-1 do begin
	w = where( (f GT edges[i]) AND (f LE edges[i+1]) )
	tops[i] = max(w)
	newf[i] = mean(f[w])
endfor
	return, tops
end