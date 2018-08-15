
pro Gr_split_dir, file, dir

;+
; GR_SPLIT_DIR
;	Separate a file name into a directory and a file name.
;
; Usage:
;	gr_split_dir, file, dir
;
; Arguments:
;	file	string	in/out	On entry the full filename, on exit
;				the filename part.
;	dir	string	output	The directory name.
;
; History:
;	Original: 18/8/95; SJT
;	Rename as GR_SPLIT_DIR (was split_dir): 18/9/96; SJT
;-

if (n_elements(dir) eq 0) then dir = ''

case !Version.os of
    'vms':      separator = ']'
    'windows':  separator = '\'
    'MacOS':    separator = "\"
    'Win32': 	 separator = '\'
    Else:       separator = '/' ; Unixen
endcase

sp = rstrpos(file, separator)+1

fdir = strmid(file, 0, sp)
file = strmid(file, sp, strlen(file))

if (fdir eq '') then begin
    if (dir eq '') then cd, current = fdir $
    else fdir = dir
    if (rstrpos(fdir, separator) ne strlen(fdir)-1) then $
      fdir = fdir+separator
endif
dir = fdir

end

