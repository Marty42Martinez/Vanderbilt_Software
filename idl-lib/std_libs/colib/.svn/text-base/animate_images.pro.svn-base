pro animate_images, filelist, outname, delay=delay

; make an animated gif out of a set of image files
; these files MUST all live in the same directory

; set delay in hundredths of a second between frames
if n_elements(delay) eq 0 then delay = 10

; break filenames into directory plus basenames
files = file_basename(filelist)
dir = (file_dirname(filelist))[0]

; create output file name
pos = strpos(outname, '.')
if pos eq -1 then outfile = outname + '.gif' else begin
	ext = strmid(outname, pos+1, 3)
	outfile = strmid(outname, 0, pos) + '.gif'
	if ext ne 'gif' then begin
		print, 'Non-standard extension .' + ext + ' replaced by .gif'
		print, 'New filename = ' + outfile
	endif
endelse

; create ridiculously huge command
nf = n_elements(files)
com = 'convert ' + ' -delay ' + strcompress(delay, /remove)
for i = 0, nf-1 do com = com + ' -page +0+0 ' + files[i]
com = com + ' ' + outfile
if !version.os_family ne 'Windows' then begin
	print, 'Creating animated gif with ' + strcompress(nf) + ' files.'
	print, com
	cd, dir ; get in the correct directory
	spawn, com
endif else begin
	print, 'This command currently only works in linux!'
endelse

END