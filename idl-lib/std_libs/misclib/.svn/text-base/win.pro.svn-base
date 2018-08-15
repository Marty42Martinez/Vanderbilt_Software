pro win , i,xsize=xsize,ysize=ysize
; sets a window if already exists or creates one
; if device is postscript, nothing happens

if STRLOWCASE(!d.name) eq "ps" then return
;if not (keyword_set (xsize)) then xsize=400
;if not (keyword_set (ysize)) then ysize=300

if (i eq 0) and (!d.window eq -1) then window,i,xsize=xsize,ysize=ysize

catch, errorstat


if errorstat ne 0 then	window,i,xsize=xsize,ysize=ysize else wset,i

end
