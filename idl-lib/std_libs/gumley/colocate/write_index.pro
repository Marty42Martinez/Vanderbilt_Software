PRO WRITE_INDEX, OUT_FILE, AIRS_FILE, MODIS_FILE, AIRS_INDEX

;- Write AIRS/MODIS collocation index to HDF file

;- Create the HDF file
hdfid = hdf_sd_start(out_file, /create)

;- Create the output array (long integer)
dims = size(airs_index, /dimensions)
varid = hdf_sd_create(hdfid, 'Collocation_Index', dims, /long)

;- Name the dimensions
dimid = hdf_sd_dimgetid(varid, 0)
hdf_sd_dimset, dimid, name='modis_index'
dimid = hdf_sd_dimgetid(varid, 1)
hdf_sd_dimset, dimid, name='airs_fov'
dimid = hdf_sd_dimgetid(varid, 2)
hdf_sd_dimset, dimid, name='airs_scan'

;- Write the index data
hdf_sd_adddata, varid, airs_index
hdf_sd_endaccess, varid

;- Write the global attributes
hdf_sd_attrset, hdfid, 'Creation_Date', systime()
hdf_sd_attrset, hdfid, 'AIRS_File', airs_file
hdf_sd_attrset, hdfid, 'MODIS_File', modis_file
loc = where(airs_index ge 0, count)
hdf_sd_attrset, hdfid, 'Number_Of_Collocations', count

;- Close the file
hdf_sd_end, hdfid

END
