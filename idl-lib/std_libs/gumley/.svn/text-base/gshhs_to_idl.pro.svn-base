PRO GSHHS_TO_IDL, FILE, NPOINTS=NPOINTS, AREA=AREA, LIMIT=LIMIT

;- Convert GSHHS coastline files to IDL map format

;- Check keywords

if n_elements(limit) eq 0 then limit = 3

;- Open the GSHHS format input file

openr, lun, file, /get_lun

;- Open the IDL format output files

openw, index_lun, 'out.ndx', /get_lun, /xdr
openw, out_lun,   'out.dat', /get_lun, /xdr

;- Initialize output file pointer and segment counter

fptr = 0L
nsegments = 0L
npoints = lonarr(1000000)
area = lonarr(1000000)

;- Read all segments from the input file

while not eof(lun) do begin

  ;- Read the header
  ;- int id;                         /* Unique polygon id number, starting at 0 */
  ;- int n;                          /* Number of points in this polygon */
  ;- int level;                      /* 1 land, 2 lake, 3 island_in_lake, 4 pond_in_island_in_lake */
  ;- int west, east, south, north;   /* min/max extent in micro-degrees */
  ;- int area;                       /* Area of polygon in 1/10 km^2 */
  ;- short int greenwich;            /* Greenwich is 1 if Greenwich is crossed */
  ;- short int source;               /* 0 = CIA WDBII, 1 = WVS */

  header = { id:0L, n:0L, level:0L, west:0L, east:0L, south:0L, north:0L, $
             area:0L, greenwich:0, source:0 }
  readu, lun, header           
  
  ;- Read the data

  data = lonarr(2, header.n)
  readu, lun, data

  ;- Write this segment to output if number of points is sufficient,
  ;- or area is greater than 100 sq. km
  
  if (header.n ge limit) or (header.area ge 1000) then begin

    ;- Save number of points and area for this segment
    
    npoints[nsegments] = header.n
    area[nsegments] = header.area

    ;- Convert microdegrees (LONG) to degrees (FLOAT)

    lon   = reform(data[0,*]) * 1.0e-6
    lat   = reform(data[1,*]) * 1.0e-6
    west  = header.west * 1.0e-6
    east  = header.east * 1.0e-6
    north = header.north * 1.0e-6
    south = header.south * 1.0e-6

    ;- Convert longitude range [0,360] to [-180,180]

    index = where(lon ge 180.0, count)
    if count gt 0 then lon[index] = lon[index] - 360.0

    if west ge 180.0 then west = west - 360.0
    if east ge 180.0 then east = east - 360.0

    ;- Write this segment to the index file

    index = {fptr:fptr, npts:header.n, $
             latmax:north, latmin:south, lonmax:east, lonmin:west}
    writeu, index_lun, index

    ;- Write this segment to the data file

    out = fltarr(2, header.n)
    out[0, *] = lat
    out[1, *] = lon
    point_lun, out_lun, fptr
    writeu, out_lun, temporary(out)

    ;- Update output file pointer

    fptr = fptr + (header.n * 2L * 4L)

    ;- Update the number of segments

    nsegments = nsegments + 1

  endif
      
endwhile

;- Close the GSHHS file

free_lun, lun

;- Close the output files

free_lun, index_lun
free_lun, out_lun

;- Write the number of segments at the start of the index file

openw, lun, 'dummy', /get_lun
writeu, lun, nsegments
free_lun, lun

spawn, 'cat dummy out.ndx > tmp.ndx'
spawn, 'mv tmp.ndx out.ndx'
spawn, 'rm -f dummy'

npoints = npoints[0:nsegments-1]
area = area[0:nsegments-1]

END
