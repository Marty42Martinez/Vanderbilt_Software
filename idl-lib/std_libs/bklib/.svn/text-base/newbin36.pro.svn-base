PRO Newbin36, dataarr,sdarr,binavarr,binsdarr

;input: dataarr and sdarr [generated from un-weighted mean
;binning into 72], and un-weighted error [just the scatter
;of the ~8 points which go into each of the 72 bins

;output: weighted mean and weighted std dev

nbins = 36
nrots = n_elements(dataarr(0,*))
q = n_elements(dataarr(*,0))
if q NE 72 then message, 'somethings wrong in dataarr'
binsize = 2; takes 72 to 36

binavarr = fltarr(nbins,nrots)
binsdarr = fltarr(nbins,nrots)

for rot = 0, nrots-1 do begin
	for bin = 0, nbins-1 do begin
	    x = dataarr(bin*binsize:(bin+1)*binsize-1,rot)
	    y = sdarr(bin*binsize:(bin+1)*binsize-1,rot)
		nelx = N_ELEMENTS(x)
		nely = N_ELEMENTS(y)
		if nelx NE nely then message,'data length NE sd length'
		wmean, x, y, wmn, wsig

		binavarr(bin,rot) = wmn;weightedmean
		binsdarr(bin,rot) = wsig;sd of weightedmean
		if (binsdarr(bin,rot)) EQ 0. then message,strcompress('Stddev = 0 at Rot #'+string(rot)+'Bin#'+string(bin))

	endfor;bin
endfor; rot


END