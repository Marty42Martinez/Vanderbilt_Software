; stupid fucking test to make pixels feature work of qe_compute2 program.

npix = 5 ;!!!
lmax = 50
bands = [[2,10],[11,20],[21,30]]
restore, 'z:\polar_analysis\work\may02\angelica_test\noise_covar.var'
pixels = [1,2,3] ; measure middle 3 pixels
qcov = [[3., -0.5,.1],[-.4, 2.4, -.4], [.1,-.6,3.3]] + 2
ucov = [[3.3, -0.4,.1],[-.4, 2.7, -.5], [.1,-.6,3.3]] + 2
noise = identity(2*npix,/double)*1e6
noise = matrix_insert(qcov,noise,pixels)
noise = matrix_insert(ucov,noise,pixels+npix)
pixels = findgen(npix)

;npix2 = n_elements(pixels)
;noise = dblarr(2*npix2,2*npix2)
;noise = matrix_insert(qcov,noise,pixels-1)
;noise = matrix_insert(ucov,noise,pixels-1+npix2)

clfile = 'z:\polar_analysis\work\may02\fiducial_angelica.var'
outfile = 'z:\polar_analysis\work\may02\angelica_test\qe_out_good_big.var'
checkdir, outfile
qe_bandpower2, noise, ucov, pixels, npix=npix,lmax=lmax, /verb,  /double, $
	outfile = outfile, clfile=clfile, bands=bands, /singlecov
END

