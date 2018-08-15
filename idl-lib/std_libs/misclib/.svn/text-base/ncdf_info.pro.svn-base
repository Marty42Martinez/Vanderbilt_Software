pro ncdf_info,file,dir=dir,noless=noless,names=names
;+
;
;ROUTINE: NCDF_INFO
;
;PURPOSE: Summarize the information from a NetCDF file
;
;USEAGE:  NCDF_INFO, File
;
;INPUT:
;
; file    A string containing the name of an existing NetCDF file.
;
;KEYWORD_INPUT:
;
; dir     if set to one (an integer) the current directory is scanned
;         for any files with a .cdf suffix.  If instead dir is set to
;         a directory name (a string) then that directory is scanned
;         for NetCDF files.  The list of files is presented as a menu,
;         and information for a selected file is displayed.  If
;         present, the command line argument, FILE, is set to the
;         selected file, and can be used in subsequent commands.
;
; noless  0 view info file with less (default)
;         1 do not view info file with less
;         2 view info file with xless
;
; Keyword OUTPUT:
;
; names   array of variable names
;
;Example
;
;; Review information for a specific netcdf file
;
;    ncdf_info,'stuff.cdf'
;
;
;; Review information for one of many files in a directory
;
;    ncdf_info,file,/dir            ; defines file on output
;
;; Retrieve a list of variable names and use in a menu to retrieve values
;
;    ncdf_info,file,/dir,/no,na=n & ncdf_get_1field,file,n(wmenu(n)),z
;
;Bugs:
;
;    Although this algorithm follows NetCDF conventions, it is inappropriate
;    for irregularly gridded data.
;
;Author:
;
;        William Weibel, Department of Atmospheric Sciences, UCLA
;
;
;Revisions:
;
; may98:PJR correct do loop index range (WW forgot to start at 0)
; may98:PJR return variable names to caller
; apr98:PJR pipe info into less
; apr93:WW  Summarize the information from a NetCDF file
;
;
; Bugs:
;
;    Although this algorithm follows NetCDF conventions, it is inappropriate
;    for irregularly gridded data.
;-
ndir=n_elements(dir)
if ndir gt 0 then begin
  dr=""
  sz=size(dir)
  if (sz)(n_elements(sz)-2) eq 7 then begin
    dr=dir
    if strmid(dir,strlen(dir)-1,1) ne "/" then dr=dr + "/"
  endif
  files=findfile(dr+"*.cdf")
  file=files(menuw(menuw(files)))
endif

if not keyword_set(noless) then noless=0
if noless ge 0 then vu=1

if vu then begin
  ofile='/tmp/'+strip_fn(file)+'_info'
endif else begin
  ofile=0
endelse

if vu then begin
  openw,lun,/get_lun,ofile
  printf,lun
  printf,lun,"Contents of ",file
  printf,lun
endif

fid = ncdf_open(file)
q = ncdf_inquire(fid)

; list the global attributes of the file

for attnum = 0, q.ngatts-1 do begin
  att_descrip = ncdf_attname( fid, attnum, /GLOBAL )
  ncdf_attget, fid, att_descrip, value, /GLOBAL
  if vu then printf,lun, att_descrip, " = ", string(value)
endfor

; list dependent variables, their dimensions, and their attributes.
; Variables which are synonymous with "dimensions" in the NetCDF are
; considered independent

if vu then begin
  printf,lun,"Variables"
  printf,lun
endif

names=strarr(q.nvars)

for i = 0, q.nvars-1 do begin
  var = ncdf_varinq( fid, i )
  ncdf_control, fid, /NOVERBOSE
  names(i)=var.name
  if ncdf_dimid( fid, var.name ) eq -1 then begin
    if vu then printf,lun," Name: ",var.name,",  data type: ",var.datatype
    for attnum = 0, var.natts-1 do begin
      att_descrip = ncdf_attname( fid, i, attnum )
      ncdf_attget, fid, i, att_descrip, value
      if vu then printf,lun, "  ", att_descrip, " = ", string(value)
    endfor
    if vu then printf,lun, "  Dimensions:"
    outstring = "    "
    for j = 0,var.ndims-1 do begin
      ncdf_diminq, fid, var.dim(j), name, size
      outstring = outstring +  $
         strcompress(string(name, "[", size, "]"), /REMOVE_ALL)
      if (j lt var.ndims-1) then outstring = outstring + ", "
    endfor
    if vu then printf,lun, outstring
    if vu then printf,lun
  endif
  ncdf_control, fid, /VERBOSE
endfor
;
ncdf_close,fid


if vu then begin
  free_lun,lun
  if noless eq 0 then begin
    spawn,"less "+ofile+" ; rm "+ofile
  endif else begin
    xless,file=ofile,/unmanaged
    spawn,"rm "+ofile
  endelse
endif

return
end



