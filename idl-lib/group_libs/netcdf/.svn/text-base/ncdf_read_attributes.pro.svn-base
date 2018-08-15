;Usage:
;pro ncdf_read_attributes, filename, output
;	filename     name of the file to read from              INPUT
;	output       structure containing the global attributes OUTPUT
		

pro ncdf_read_attributes, filename, output		

	s=shift(size(filename),2)
	if s(0) eq 0 then begin    ; undefinend
		filename=pickfile(title='Bitte File auswaehlen',filter='*.nc')
	endif	
	
	
	result=findfile(filename, count=c)
	if c ne 1 then begin
		print, 'File existiert nicht: ', filename
		filename=pickfile(title='Bitte File auswaehlen',filter='*.nc')
	endif	
	
	id=ncdf_open(filename)
	
	result = ncdf_inquire(id)
	output = create_struct('filename', filename)
	
	if result.ngatts ge 1 then begin
		for i = 0, result.ngatts -1 do begin
			name = ncdf_attname(id, i, /global)
			ncdf_attget, id, name, value, /global
			name = strtrim(strcompress(name))
			output = create_struct(output, name, value)
		endfor
	endif
		
	ncdf_close,id

end
