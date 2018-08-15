pro checkdir, fullpath, verbose=verbose

; check if a file's directory exists.
; if it doesn't exist, create that directory
; must work recursively?

	dir = file_dirname(fullpath + '*', /mark)
	direxists =  file_test(dir)

	if (direxists eq 0) then begin
		file_mkdir, dir
		if keyword_set(verbose) then print, 'Created directory '+dir
	endif

end
