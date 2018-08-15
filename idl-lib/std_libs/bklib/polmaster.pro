pro polmaster, col,row, section
section = string(section)
;process data from datafile (binavarr & binsdarr, of size (col X row)) to Q and U vs rot
directory = strcompress('d:\brian\data\polar_2000\april_data\section'+section)

inputfile = strcompress(directory + '\bindata'+section+'.dat',/remove_all)
outputqufile = strcompress(directory + '\outputqufile'+section+'.dat',/remove_all);data destination for q,u and sigmas for all correlators

close,3
openr, 3, inputfile
dataarr = ASSOC(3, fltarr(col,row)); hold binavarr and binsdarrs -- see notebook for order



close,4


openw, 4, outputqufile; 'd:\brian\data\polar_2000\bindata.dat'
print, '***SVDFIT assumes data = weighted mean and weights = weighted std. dev******'

;2,7
for i = 2,7 do begin ; skip tpows
	Newbin36, dataarr[2*i],dataarr[2*i+1],binavarr,binsdarr

	polstrips, binavarr,binsdarr, iunpolarr, qarr,uarr,carr,sarr,slopearr,offsetarr,iunpolsig,qsig,usig,csig,ssig,slopesig, offsetsig, linchisqarr,stokeschisqarr

	writeu,4, iunpolarr, qarr,uarr,carr,sarr,slopearr,offsetarr,iunpolsig,qsig,usig,csig,ssig, slopesig, offsetsig, linchisqarr,stokeschisqarr

;	if i EQ 3 then asdf
endfor
close,4

end

