PRO COLLOCATE, AIRS_FILE, MODIS_FILE, INDEX_FILE, PLOT=PLOT

;+
; Purpose:
;     Given an AIRS L1B radiance file and a MODIS MYD03 geolocation file,
;     determine the indices of the MODIS pixels that lie within each AIRS FOV.
;
; Usage:
;     COLLOCATE, AIRS_FILE, MODIS_FILE, INDEX_FILE
;
; Input:
;     AIRS_FILE     Name of input AIRS L1B radiance file
;     MODIS_FILE    Name of input MODIS MYD03 geolocation file
;     INDEX_FILE    Name of output AIRS/MODIS collocation index file
;
; Notes:
;     The output file will be in HDF4 Scientific Data Set (SDS) format.
;     The collocation indices are stored in an array named "Collocation_Index"
;     as signed long integers. Valid indices have values of zero or greater.
;     The indices are stored as one-dimensional subscripts into the
;     two-dimensional array of MODIS pixels. To convert from a one dimensional
;     subscript to MODIS row (line) and column (pixel) numbers:
;     
;     row = index / 1354L
;     col = index mod 1354L
;-

compile_opt idl2

;-------------------------------------------------------------------------------
;- CHECK ARGUMENTS
;-------------------------------------------------------------------------------

if (n_elements(airs_file) eq 0) then message, 'Argument AIRS_FILE is undefined'
if (n_elements(modis_file) eq 0) then message, 'Argument MODIS_FILE is undefined'
if (n_elements(index_file) eq 0) then message, 'Argument INDEX_FILE is undefined'

;-------------------------------------------------------------------------------
;- DEFINE CONSTANTS
;-------------------------------------------------------------------------------

;- General constants
earth_radius = 6378.0    ; radius of Earth (km)
sat_altitude = 705.0     ; satellite altitude (km)

;- AIRS constants
airs_fov_arc = 1.1       ; AIRS nadir FOV angular size (deg)
airs_fov_size = sat_altitude * airs_fov_arc * !dtor   ; AIRS nadir FOV size (km)

;- MODIS constants
modis_swath = 110.0      ; MODIS swath width (deg)

;-------------------------------------------------------------------------------
;- GET AIRS DATA
;-------------------------------------------------------------------------------

;- Get data from AIRS L1B file (AIRS.YYYY.MM.DD.GGG.L1B.AIRS_Rad.*.hdf)
print, '(Reading AIRS data)'
hdfid = hdf_sd_start(airs_file)
hdf_sd_varread, hdfid, 'Latitude', airs_lat    ; latitude (deg)
hdf_sd_varread, hdfid, 'Longitude', airs_lon   ; longitude (deg)
hdf_sd_varread, hdfid, 'Time', airs_time       ; time (TAI sec)
hdf_sd_varread, hdfid, 'scanang', airs_scan    ; scan angle (deg)
hdf_sd_end, hdfid
airs_dims = size(airs_lat, /dimensions)
airs_num = n_elements(airs_lat)

;- Compute AIRS FOV slant range and size (X and Y)
airs_range = slant_range(earth_radius, sat_altitude, abs(airs_scan))
result = fov_size(airs_fov_size, sat_altitude, airs_range, abs(airs_scan))
airs_fov_xsize = reform(result[*, *, 0])
airs_fov_ysize = reform(result[*, *, 1])

;- Create the output index array
airs_index = replicate(-1L, 300, 90, 135)

;-------------------------------------------------------------------------------
;- GET MODIS DATA
;-------------------------------------------------------------------------------

;- Get data from MODIS geolocation file (MYD03.AYYYYDDD.HHMM.*.hdf)
print, '(Reading MODIS data)'
hdfid = hdf_sd_start(modis_file)
hdf_sd_varread, hdfid, 'Latitude', modis_lat         ; latitude (deg)
hdf_sd_varread, hdfid, 'Longitude', modis_lon        ; longitude (deg)
hdf_sd_varread, hdfid, 'EV start time', modis_time   ; scan start time (TAI sec)
hdf_sd_end, hdfid
modis_dims = size(modis_lat, /dimensions)
modis_num = n_elements(modis_lat)

;- Convert MODIS time from per-scan to per-row
modis_time = rebin(modis_time, modis_dims[1], /sample)

;- Compute MODIS scan angle per row (goes from 55 to -55 degrees)
modis_scan = modis_swath * findgen(1354) / 1353.0
modis_scan = -(modis_scan - 0.5 * modis_swath)
modis_scan = rebin(modis_scan, 1354, modis_dims[1], /sample)

;- Create MODIS index array to track output MODIS pixel locations
modis_index = lindgen(1354, modis_dims[1])

;- Plot map with granule boundaries
if keyword_set(plot) then begin
  loadcolors
  map_set, airs_lat[45, 135/2], airs_lon[45, 135/2], scale=4e6, /ortho, /cont
  outline_plot, modis_lat, modis_lon, color=1
  outline_plot, airs_lat, airs_lon, color=2
endif

;-------------------------------------------------------------------------------
;- LOOP OVER AIRS SCANS
;-------------------------------------------------------------------------------

for row = 0, airs_dims[1] - 1 do begin

  if ((row mod 10) eq 0) then print, '(Scan', strcompress(row), ')'
  
  ;- Gross check on AIRS scan time vs. MODIS granule boundaries
  if (airs_time[45, row] lt (min(modis_time) - 5.0)) then goto, next_scan
  if (airs_time[45, row] gt (max(modis_time) + 5.0)) then goto, next_scan

  ;- Find MODIS rows close to this AIRS scan
  time_diff = abs(airs_time[45, row] - modis_time)
  modis_row = where(time_diff lt 5.0, count)
  if (count eq 0) then goto, next_scan

  ;- Get MODIS lat/lon for this AIRS scan
  modis_lat_row = modis_lat[*, modis_row]
  modis_lon_row = modis_lon[*, modis_row]
  modis_ind_row = modis_index[*, modis_row]
  
;-------------------------------------------------------------------------------
;- LOOP OVER AIRS FOVs
;-------------------------------------------------------------------------------

  for col = 0, airs_dims[0] - 1 do begin

    ;- Find MODIS columns close to this AIRS FOV
    scan_diff = abs(modis_scan[*, modis_row[0]] - airs_scan[col, row])
    modis_col = where(scan_diff lt 1.0, count)
    if (count eq 0) then goto, next_fov

    ;- Get MODIS lat/lons close to this AIRS_FOV
    modis_lat_col = modis_lat_row[modis_col, *]
    modis_lon_col = modis_lon_row[modis_col, *]
    modis_ind_col = modis_ind_row[modis_col, *]
    
    ;- For each MODIS pixel, compute distance from
    ;- center of AIRS FOV to MODIS pixel
    compass, airs_lat[col, row], airs_lon[col, row], $
      modis_lat_col, modis_lon_col, modis_range, modis_azimuth
    
    ;- Find MODIS pixels within this AIRS FOV
    ;- (first guess, assuming circular FOV)
    rmax = airs_fov_xsize[col, row] * 0.5
    rmin = airs_fov_ysize[col, row] * 0.5
    loc = where(modis_range lt rmax, count)
    if (count eq 0) then goto, next_fov

    ;- Get MODIS pixels for this FOV (first guess)
    modis_lat_fov = modis_lat_col[loc]
    modis_lon_fov = modis_lon_col[loc]
    modis_ind_fov = modis_ind_col[loc]
    modis_range_fov = modis_range[loc]
    modis_azimuth_fov = modis_azimuth[loc]
    
    ;- Compute rotation angle of this AIRS FOV (assuming elliptical FOV)
    if (row lt (airs_dims[1] - 1)) then begin
      row1 = row
      row2 = row + 1
    endif else begin
      row1 = row - 1
      row2 = row
    endelse
    compass, airs_lat[col, row1], airs_lon[col, row1], $
      airs_lat[col, row2], airs_lon[col, row2], rng, fov_rotation
    
    ;- For each MODIS pixel, compute distance from center to edge of AIRS FOV
    ;- (assuming elliptical FOV)
    edge_range = ellipse_dist(rmin, rmax, modis_azimuth_fov, fov_rotation)

    ;- Find MODIS pixels within AIRS FOV (assuming elliptical FOV)
    loc = where(modis_range_fov lt edge_range, count)
    if (count eq 0) then goto, next_fov
    modis_index_final = modis_ind_fov[loc]
    
    ;- Save the MODIS pixel indices in the output array
    airs_index[0, col, row] = modis_index_final
    
    ;- Plot center and edges of AIRS FOV
    if keyword_set(plot) then begin
      phi = [findgen(36) * 10.0, 0.0]
      pos = fov_rotation
      edge_range = ellipse_dist(rmin, rmax, phi, pos)
      latcen = airs_lat[col, row]
      loncen = airs_lon[col, row]
      compass, latcen, loncen, edge_range, phi + pos, $
        lat_edge, lon_edge, /to_latlon
      plots, loncen, latcen, psym=3, color=2
      plots, lon_edge, lat_edge
      plots, modis_lon[modis_index_final], modis_lat[modis_index_final], $
        psym=6, symsize=0.1, color=1
    endif
        
    ;- Skip to next AIRS FOV
    next_fov:
    
  endfor

;-------------------------------------------------------------------------------
;- END OF AIRS FOV LOOP
;-------------------------------------------------------------------------------

  ;- Skip to next AIRS scan
  next_scan:
  
endfor

;-------------------------------------------------------------------------------
;- END OF AIRS SCAN LOOP
;-------------------------------------------------------------------------------

;- Write the output file if collocations were found
loc = where(airs_index ge 0, count)
if (count gt 0) then begin
  airs_tail = strmid(airs_file, max(strsplit(airs_file, '/')))
  modis_tail = strmid(modis_file, max(strsplit(modis_file, '/')))
  write_index, index_file, airs_tail, modis_tail, airs_index
  print, 'Collocated pixels were found; wrote output file ', index_file
endif else begin
  print, 'No collocated MODIS pixels were found; output file not written'
endelse
    
END
