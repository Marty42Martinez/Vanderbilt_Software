pro read_angel_cov

npix = 181
cth = dblarr(2.*npix,2.*npix)

close,1
openr,1,'d:\brian\data\polar_2000\angelica\v02_14_01\covmtx.dat'
readf,1,cth
close,1
fdsh
save, file = 'd:\brian\data\polar_2000\angelica\v02_14_01\nogal_ra_110_290_covmtx.var',cth

end