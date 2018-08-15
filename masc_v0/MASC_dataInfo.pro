FUNCTION MASC_dataInfo, fname,tag
;Below is a rough way to read all files into string array
;Can then separate string for the fall speed
;One problem, must go through many files
;...can either go through every single file>>discard ones that only have one entry
;OR go through the only ones that have files
;nlines=file_lines(f)
;sarr = strarr(nlines)
;print, nlines
;openr, unit, f, /get_lun
;readf, unit, sarr
;free_lun, unit
  fpath = file_search('/Users/Marty/Desktop/MASC/BoulderA/MASC/MascImages','*'+fname)
  ;fpath = file_search('/Users/Marty/Desktop/MASC/MQT/EVENT5','*'+fname)
  ;fpath = file_search('/Users/Marty/Desktop/MASC/drops_Nashville_1.30.2014/control','*'+fname)
  spl = strsplit(fpath,'/',/extract)
  len = n_elements(spl)
  fn = spl[0:len-2]
  f = '/'+strjoin(fn,'/')+'/dataInfo.txt'
  fspeed_arr = read_ascii(f)
  loc = where(fspeed_arr.field1[0,*] eq fix(tag))
  fspeed = fspeed_arr.field1[3,loc]
  return, fspeed
	
  ;endfor
  s = size(f)
  date_arr = []
  for i=0,s[1]-1 do begin
    farr = strsplit(f[i],'/',/extract)
	fdate = farr[7]
	fdate = strsplit(fdate,'_',/extract)
	fdate = strsplit(fdate[1],'.',/extract)
	fdate = fix(fdate[0] + fdate[1])
	date_arr = [date_arr,fdate]
	
  endfor
  srt_dates = date_arr[sort(date_arr)]
  srt_dates = srt_dates[uniq(srt_dates)]
  s2 = size(srt_dates)
  s_flist = []
  for j = 0,s2[1]-1 do begin
    m = string(srt_dates[j]/100)
	d = srt_dates[j] mod 100
	if d lt 10 then begin
	  d = '0'+string(d)
	  d = strcompress(d,/remove_all)
	endif else begin
	  d = string(d)
	endelse
	date = strcompress(m,/remove_all)+'.'+d
	s_flist = [s_flist,f[where(strmatch(f,date) eq 1)]]
	
	;need to find date within f array, then open file and put velocities into array
	;IF ther are velocities!
	;If there are not readf >> sarr[0] = 'snowflake id'
  endfor
  Fspeeds = []
  for i=0,s[1]-1 do begin
    nlines=file_lines(f[i])
	if nlines gt 1 then begin
	  sarr = strarr(nlines)
      openr, unit, f[i], /get_lun
      readf, unit, sarr
      free_lun, unit
	  for j=0,nlines-1 do begin
	    hold = strcompress(sarr[j])
	    split = strsplit(hold,' ',/extract)
	    Fspeeds=[Fspeeds,split[3]]
	  endfor
	endif
  endfor
  return, Fspeeds

;Final output will be string array with all of the fall speeds


end
