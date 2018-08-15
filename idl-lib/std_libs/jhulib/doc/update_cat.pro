;**********************************************************
	;================================================
	;  add_cat = add an entry to the cat.one file
	;    Files read from main lib, written to both
	;    main and mirror libs.
	;================================================
	pro update_cat
 
	;-------  Read in cat.one file  -----------
	print,' Reading in cat.one . . .'
	a = getfile('cat.one',error=err)		   ; Read cat.one
	b = a						   ; Names array.
	lookup = lindgen(n_elements(a))			   ; Index into a.
 
	;-------  Fix any null lines  --------------
	w = where(a eq '', cnt)				   ; Convert NULL lines
	if cnt gt 0 then a(w) = ' '			   ; to space.
 
	;-------  Copy from array a to array b picking off names.  --------
	print,' Picking off routine names . . .'
	j = -1						; Index into names.
	for i = 0, n_elements(a)-1 do begin
	  t = a(i)					; Old cat entry.
	  p = strpos(t,':')				; Look for new format.
	  if p gt 0 then begin
	    if strmid(t,p+1,1) ne ' ' then begin
	      t2=getwrd(t,delim=':')			; as of 94/5/31.
	      j = j + 1					; Found a routine name.
	      b(j) = t2
	      lookup(j) = i
	    endif
	  endif
	  if strpos(t,'=') gt 0 then begin		; Look for old format.
	    t2=getwrd(t,delim='=')			; Only one will occur.
	    j = j + 1
	    b(j) = t2					; Found a routine name.
	    lookup(j) = i
	  endif
	endfor
	if j gt 0 then b = b(0:j)			; Trim.
 
	;-------  Loop through all routines  -------------
	for j=0, n_elements(b)-1 do begin
	  f = b(j)+'.pro'
	  ff = findfile(f,count=cnt)
	  if cnt eq 0 then begin
	    print,' Obsolete routine: '+f
	    bell
	    txt = ''
	    read,' Press RETURN to continue',txt
	  endif else begin
	    extracthlp,f,/liner,/array, t
	    print,t(0)
	    a(lookup(j)) = t(0)
	  endelse
	endfor

	;-------  Write back out  --------
	putfile, 'cat_new.tmp', a		; Updated main cat.one file.
	print,' '
	print,' Updated cat.one is in cat_new.tmp'
 
	return
	end
