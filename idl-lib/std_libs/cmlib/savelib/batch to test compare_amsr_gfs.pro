; batch program to test compare_amsr_gfs

files = findfile('m:\data\amsr\level2_new\l2a\20031129\*_A.hdf')
outfile = 'p:\odell\amsre_validation\amsr2gfs\20031129\compare_test_output.sav'
checkdir, outfile

t0 = (read_amsr_tia93(files[3]))[100]

test = compare_amsr_gfs(t0, files, outfile)
restore, outfile

lat2 = 90. - pix2 / 360
lon2 = pix2 mod 360
 ; OR
 ; a = latlon_gfs()
 ; lat2 = (a.lat)[pix2]
 ; lon2 = (a.lon)[pix2]

END