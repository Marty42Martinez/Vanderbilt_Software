;-------------------------------------------------------------
;+
; NAME:
;       LIBR
; PURPOSE:
;       Maintains multiple IDL libraries.
; CATEGORY:
; CALLING SEQUENCE:
;       libr
; INPUTS:
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
;       get_lpath_com
;       libr_com
;       libr_com
;       libr_com
;       libr_com
;       libr_com
;       libr_com
;       libr_com
; NOTES:
;       Notes: the functions are:
;         Add/Update a routine to a library.
;         Move a routine from one library to another.
;         Delete a routine from a library.
;         Examine routines in a library.
;         Search for references to a routine in a library.
;         Check that all library routines are in alph.one & cat.one.
;         Need to set up the file .idl_libs in your home directory:
;         do .run libr
;             get_lpath,/help
;         for .idl_libs file format.
; MODIFICATION HISTORY:
;       R. Sterner, 11 Jan, 1993
;       R. Sterner, 19 May, 1993 --- Added ADD backups.
;       R. Sterner, 23 Jun, 1993 --- Dropped the need for .idl_editor
;       in your HOME directory.  Uses Env. Var. EDITOR instead.
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro get_lpath, lpath, mpath, library=lib, liblist=liblst,$
	  quiet=quiet,  error=err, help=hlp
 
	common get_lpath_com, main, mirror, libs
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Return full library path.'
	  print,' get_lpath, main, mirror'
	  print,'   main = Full path to main library.       out'
	  print,'   mirror = Full path to mirror library.   out'
	  print,' Keywords:'
	  print,'   LIBRARY=lib  specify which library (def=idlusr).'
	  print,'   /QUIET suppress messages.'
	  print,'   LIBLIST=list returns list of all known libraries.'
	  print,'   ERROR=err  0=ok, 1=error.'
	  print,' Notes: needs the file .idl_libs in you home directory.'
	  print,'   Each line contains a main library path and an'
	  print,'   optional mirror library.  Comment lines have ; in column'
	  print,'   1 and are ignored.  Example .idl_libs file:'
	  print,';-------------  Library list  --------------------
	  print,';------ Main library ------   ------  Mirror library  --------
	  print,'/data_bases/idl_libs/idlusr   /users/sterner/idl/mirror/idlusr
	  print,'/data_bases/idl_libs/idlusr2  /users/sterner/idl/mirror/idlusr2
	  print,'/data_bases/idl_libs/idlspec  /users/sterner/idl/mirror/idlspec
	  print,'/data_bases/idl_libs/trash    /users/sterner/idl/mirror/trash
	  return
	endif
 
	err = 1			; Assume error.
 
	;-------  Make sure common is initialized  -----------
	if n_elements(main) eq 0 then begin
	  home = getenv('HOME')
	  libs = filename(home,'.idl_libs',/nosym)
	  txt = getfile(libs, error=err)
	  if err ne 0 then begin
	    print,' Error in get_lpath: the file '+libs+' was not found'
	    print,'   in your home directory.  Create it and try again.'
	    return
	  endif
	  w = where(strmid(txt,0,1) ne ';', c)
	  if c eq 0 then begin
	    print,' Error in format of '+libs
	    return
	  endif
	  txt = txt(w)		; Drop comments.
	  n = n_elements(txt)	; Number of main libraries.
	  main = strarr(n)
	  mirror = main
	  libs = main		; List of libraries is based on main libs.
	  tmp = filename('tmp','tmp',/nosym,delim=pdel)	; Get del. (like /).
	  for i = 0, n-1 do begin
	    main(i) = getwrd(txt(i),0)
	    mirror(i) = getwrd('',1)
	    libs(i) = getwrd(main(i),delim=pdel,/last)
	  endfor
	endif
 
	;-------  Return lib list  -----------
	liblst = libs
 
	;-------  Make sure requested library is defined  ---------
	if n_elements(lib) eq 0 then lib = libs(0)	; First in list is def.
 
	;-------  Which lib was requested  -------------
	w = where(lib eq libs, cnt)
	if cnt eq 0 then begin
	  print,' Error in get_lpath: requested library not in list:'
	  print,' '+lib
	  return
	endif
	in = w(0)	; Index of requested library.
 
	;-------  Full path to main library  ---------
	lpath = main(in)
	if not keyword_set(quiet) then print,'    Main library = '+lpath
	
	;-------  Full path to mirror library  ---------
	if mirror(in) eq '' then begin
	  if not keyword_set(quiet) then print,'    Mirror lib path not set.'
	  mpath = ''
	endif else begin
	  mpath = mirror(in)
	  if not keyword_set(quiet) then print,'    Mirror library = '+mpath
	endelse
 
	err = 0
	return
	end
 
 
;********  Handle alph.one  *******************************
;**********************************************************
	;================================================
	;  add_alph = add an entry to the alph.one file
	;    Files read from main lib, written to both
	;    main and mirror libs.
	;================================================
	pro add_alph, one, main=main, mirror=mirror, error=err
 
	;------  Help  --------------
	if n_params(0) lt 1 then begin
	  print,' Add an entry to an alph.one file'
	  print,' add_alph, one'
	  print,'   one = one liner text string.       in'
	  print,'     Like drawpoly = Draw a polygon using mouse.'
	  print,' Keywords:'
	  print,'   MAIN=main      full path to main IDL library.'
	  print,'   MIRROR=mirror  full path to mirror IDL library.'
	  print,'   ERROR=err  error flag: 0=ok, 1=not added.'
	  return
	endif
 
	;------  Get entry name  -------
	item = getwrd(one,delim=':')
	equ = getwrd(getwrd('',1))
	if (equ ne 'P') and (equ ne 'F') then begin
	  print,' Error in add_alph: one liner invalid:'
	  print,' '+one
	  err = 1
	  return
	endif
 
	;-------  Read in alph.one file from main lib  -----------
	mnfile = filename(main,'alph.one',/nosym)	   ; Main lib path.
	a = getfile(mnfile,error=err)			   ; Read alph.one
	if err ne 0 then a = ''				   ; Make it.
	b = a						   ; Names array.
	for i = 0, n_elements(a)-1 do begin		   ; Pick off names.
	  b(i) = getwrd(a(i),delim=':')
	endfor
 
	;-------  Make backup copy  -----------
	mnbak = filename(main,'alph.bak',/nosym)	   ; Main backup.
	putfile, mnbak, a				   ; Write out.
	if mirror ne '' then begin
	  mrbak = filename(mirror,'alph.bak',/nosym)	   ; Mirror backup.
	  putfile, mrbak, a				   ; Write out.
	endif
 
	;-------  Look for item  -------------
	w = where(b eq item, cnt)	; Where and how many times (0 or 1).
 
	;-------  Add  --------------
	if cnt gt 0 then begin		; Already there.
	  a(w(0)) = one			; Overwrite.
	  print,'    Overwrote alph.one entry.   '
	endif else begin		; New.
	  a = [a,one]			; Put one at end of a (=alph.one).
	  b = [b,item]			; Put item at end of b (=names).
	  is = sort(b)			; Sort on names.
	  a = a(is)			; Sort alph.
	  print,'    Added entry to alph.one and sorted.   '
	endelse
 
	;-------  Write back out  --------
	print,'    Writing alph.one . . .'
	putfile, mnfile, a		; Updated main lib alph.one file.
	if mirror ne '' then begin
	  mrfile = filename(mirror,'alph.one',/nosym)  ; Mirror lib path.
	  putfile, mrfile, a		; Updated mirror lib alph.one file.
	endif
 
	err = 0				; OK.
 
	return
	end
 
 
;**********************************************************
	;================================================
	;  drop_alph = drop an entry from the alph.one file
	;    Files read from main lib, written to both
	;    main and mirror libs.
	;================================================
	pro drop_alph, item, main=main, mirror=mirror, error=err
 
	;------  Help  --------------
	if n_params(0) lt 1 then begin
	  print,' Drop an entry from an alph.one file'
	  print,' drop_alph, item'
	  print,'   item = name of routine to drop.       in'
	  print,' Keywords:'
	  print,'   MAIN=main       full path to main IDL library.'
	  print,'   MIRROR=mirror   full path to mirror IDL library.'
	  print,'   ERROR=err  error flag: 0=ok, 1=not dropped.'
	  return
	endif
 
	;------  Get entry name  -------
	itm = getwrd(item, delim=':')
 
	;-------  Read in alph.one file  -----------
	mnfile = filename(main,'alph.one',/nosym)  ; Main lib full path.
	a = getfile(mnfile,error=err)		   ; Read alph.one
	if err ne 0 then begin			   ; No such file.
	  err = 1
	  return
	endif
	b = a					   ; Names array.
	for i = 0, n_elements(a)-1 do begin	   ; Pick off names.
	  b(i) = getwrd(a(i),delim=':')
	endfor
 
	;-------  Make backup copy  -----------
	mnbak = filename(main,'alph.bak',/nosym)	; Main lib backup.
	putfile, mnbak, a				; Write out.
	if mirror ne '' then begin
	  mrbak = filename(mirror,'alph.bak',/nosym)	; Mirror lib backup.
	  putfile, mrbak, a				; Write out.
	endif
 
	;-------  Look for line without item  -------------
	w = where(b ne itm, cnt)	; Where and how many times.
 
	;-------  Drop  --------------
	nbefore = n_elements(a)
	if cnt gt 0 then a = a(w)	; Pull out only lines without item.
	nafter = n_elements(a)
	d = nbefore-nafter
	print,'    Dropped '+strtrim(d,2)+$
	  ' occurance'+(['s','','s'])(d<1>0)+' from alph.one   '
 
	;-------  Write back out  --------
	putfile, mnfile, a		; Updated main lib alph.one file.
	if mirror ne '' then begin
	  mrfile = filename(mirror,'alph.one',/nosym)  ; Mirror lib full path.
	  putfile, mrfile, a		; Updated mirror lib alph.one file.
	endif
 
	err = 0				; OK.
 
	return
	end
 
 
;********  Handle newlist.txt  ****************************
;**********************************************************
	;================================================
	;  add_new = Add a routine name to the newlist.txt file
	;    Files read from main lib, written to both
	;    main and mirror libs.
	;================================================
	pro add_new, item, main=main, mirror=mirror, error=err
 
	if n_params(0) lt 1 then begin
	  print,' Add a routine name to the newlist.txt file.'
	  print,' add_new, item'
	  print,'   item = routine name.            in'
	  print,' Keywords:'
	  print,'   MAIN=main       full main library path.'
	  print,'   MIRROR=mirror   full mirror library path.'
	  return
	endif
 
	;------  Get entry name  -------
	itm = getwrd(item,delim=':')
 
	;------  read in newlist.txt file  ---------
	mnfile = filename(main, 'newlist.txt', /nosym)
	a = getfile(mnfile, /quiet, error=err)
	if err ne 0 then a = ''	; No such file, make one.
	a(0) = systime()	; Set line 1 to current time.
 
	;-----  Make backup  ---------
	mnbak = filename(main, 'newlist.bak', /nosym)
	putfile, mnfile, a
	if mirror ne '' then begin
	  mrbak = filename(mirror, 'newlist.bak', /nosym)
	  putfile, mrbak, a
	endif
	
	;-----  Update list  --------
	w = where(a eq itm, cnt)	; Already in list?
	if cnt eq 0 then begin
	  a = [a,itm]			; If not, add it.
	  print,'    Added '+itm+' to newlist.txt.   '
	endif
 
	;-----  Write new list  -------
	putfile, mnfile, a
	if mirror ne '' then begin
	  mrfile = filename(mirror, 'newlist.txt', /nosym)
	  putfile, mrfile, a
	endif
 
	err = 0
	return
	end 
 
;**********************************************************
	;================================================
	;  drop_new = Drop a routine name from the newlist.txt file
	;    Files read from main lib, written to both
	;    main and mirror libs.
	;================================================
	pro drop_new, item, main=main, mirror=mirror, error=err
 
	;------  Get entry name  -------
	itm = getwrd(item,delim=':')
 
	;------  Fix mirror directory  -------
	if n_elements(mirror) eq 0 then mirror = ''
 
	;------  read in newlist.txt file  ---------
	mnfile = filename(main, 'newlist.txt', /nosym)
	a = getfile(mnfile, /quiet, error=err)
	if err ne 0 then return		; No such file, return.
	a(0) = systime()		; Set line 1 to current time.
 
	;-----  Make backup  ---------
	mnbak = filename(main, 'newlist.bak', /nosym)
	putfile, mnbak, a
	if mirror ne '' then begin
	  mrbak = filename(mirror, 'newlist.bak', /nosym)
	  putfile, mrbak, a
	endif
	
	;-----  Look for line without item  --------
	w = where(a ne itm, cnt)	; Already in list?
 
	;------  Drop  -----------
	nbefore = n_elements(a)
	a = a(w)
	nafter = n_elements(a)
	d = nbefore-nafter
	print,'    Dropped '+strtrim(d,2)+$
	  ' occurance'+(['s','','s'])(d<1>0)+' from newlist.txt   '
 
	;-----  Write new list  -------
	putfile, mnfile, a
	if mirror ne '' then begin
	  mrfile = filename(mirror, 'newlist.txt', /nosym)
	  putfile, mrfile, a
	endif
 
	err = 0
	return
	end 
 
 
;********  Handle cat.one  ********************************
;**********************************************************
	;================================================
	;  add_cat = add an entry to the cat.one file
	;    Files read from main lib, written to both
	;    main and mirror libs.
	;================================================
	pro add_cat, one, main=main, mirror=mirror, error=err
 
	;------  Help  --------------
	if n_params(0) lt 1 then begin
	  print,' Add an entry to an cat.one file'
	  print,' add_cat, one'
	  print,'   one = one liner text string.       in'
	  print,'     Like drawpoly = Draw a polygon using mouse.'
	  print,' Keywords:'
	  print,'   MAIN=main      full path to main IDL library.'
	  print,'   MIRROR=mirror  full path to mirror IDL library.'
	  print,'   ERROR=err  error flag: 0=ok, 1=not added.'
	  return
	endif
 
	;------  Get entry name  -------
	item = getwrd(one,delim=':')
	equ = getwrd(getwrd('',1))
	if (equ ne 'P') and (equ ne 'F') then begin
	  print,' Error in add_alph: one liner invalid:'
	  print,' '+one
	  err = 1
	  return
	endif
 
	;-------  Read in cat.one file  -----------
	mnfile = filename(main,'cat.one',/nosym)	   ; Main lib path.
	a = getfile(mnfile,error=err)			   ; Read alph.one
	if err ne 0 then a = ''				   ; Make it.
	b = a						   ; Names array.
	lookup = lindgen(n_elements(a))			   ; Index into a.
 
	;-------  Fix any null lines  --------------
	w = where(a eq '', cnt)				   ; Convert NULL lines
	if cnt gt 0 then a(w) = ' '			   ; to space.
 
	;-------  Copy from array a to array b picking off names.  --------
	j = -1						; Index into names.
	for i = 0, n_elements(a)-1 do begin
	  t = a(i)					; Old cat entry.
	  p = strpos(getwrd(t),':')			; Look for new format.
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
 
	;-------  Make backup copy  -----------
	mnbak = filename(main,'cat.bak',/nosym)		   ; Main backup.
	putfile, mnbak, a				   ; Write out.
	if mirror ne '' then begin
	  mrbak = filename(mirror,'cat.bak',/nosym)	   ; Mirror backup.
	  putfile, mrbak, a				   ; Write out.
	endif
 
	;-------  Look for item  -------------
	w = where(b eq item, cnt)	; Where and how many times (0 or 1).
	if cnt gt 0 then w=lookup(w)
 
	;-------  Add  --------------
	case cnt of
0:	begin				; Item not found.
	  flag = 0			; Clear found flag.
	end
1:	begin				; Item occurs one time.
	  a(w(0)) = one			; Overwrite.
	  flag = 1			; Set found flag.
	end
else:	begin				; Item occurs more than once.
	  flag = 0			; Found flag.
	  for i = 0, cnt-1 do begin	; Look at all occurances of item.
	    if strmid(a(w(i)),strlen(item),1) eq ':' then begin  ; Look for :.
	      a(w(i)) = one		; Found, overwrite.
	      flag = flag + 1		; Set found flag.
	    endif
	  endfor			; Keep looking, may have several.
	end
	endcase
 
	if flag eq 0 then begin	; Not found, add to front.
	  a = [one,a]
	  print,'    Added one liner to front of cat.one.   '
	  if txtyesno(['One liner added to front of cat.one.',$
	        'Edit cat.one?']) then begin
	    ;------  Edit it.  First read editor file  ---------
	    editor = getenv('EDITOR')
	    if editor eq '' then begin
	      print,' Warning in LIBR: Environmental variable EDITOR'
	      print,'   not found, defaulting to vi.'
	      editor = 'vi'
	    endif
	    putfile, 'edit.tmp', a
	    spawn,editor+' edit.tmp'		  ; Edit copy file.
	    printat,1,1,/clear
	    a = getfile('edit.tmp')
	  endif
	endif else begin
          print,'    Overwrote one liner in cat.one '+$
	    strtrim(flag,2)+' times.   '
	endelse
 
	;-------  Write back out  --------
	putfile, mnfile, a		; Updated main cat.one file.
	if mirror ne '' then begin
	  mrfile = filename(mirror,'cat.one',/nosym) ; Mirror lib path.
	  putfile, mrfile, a		; Updated mirror cat.one file.
	endif
 
	err = 0				; OK.
 
	return
	end
 
 
;**********************************************************
	;================================================
	;  drop_cat = drop an entry from the cat.one file
	;    Files read from main lib, written to both
	;    main and mirror libs.
	;================================================
	pro drop_cat, item, main=main, mirror=mirror, error=err
 
	;------  Help  --------------
	if n_params(0) lt 1 then begin
	  print,' Drop an entry from an cat.one file'
	  print,' drop_cat, item'
	  print,'   item = name of routine to drop.       in'
	  print,' Keywords:'
	  print,'   MAIN=main      full path to main IDL library.'
	  print,'   MIRROR=mirror  full path to mirror IDL library.'
	  print,'   ERROR=err  error flag: 0=ok, 1=not dropped.'
	  return
	endif
 
	;------  Get entry name  -------
	itm = getwrd(item)+':'
 
	;-------  Read in alph.one file  -----------
	mnfile = filename(main,'cat.one',/nosym)	   ; Main lib path.
	a = getfile(mnfile, error=err)			   ; Read cat.one
	if err ne 0 then begin				   ; No such file.
	  err = 0
	  return
	endif
	b = a						   ; Names array.
	for i=0, n_elements(a)-1 do begin		   ; Get names & :.
	  t = strpos(a(i),':')
	  b(i)=strmid(a(i),0,t)
	endfor
 
	;-------  Make backup copy  -----------
	mnbak = filename(main,'cat.bak',/nosym)		   ; Main lib backup.
	putfile, mnbak, a				   ; Write out.
	if mirror ne '' then begin
	  mrbak = filename(mirror,'cat.bak',/nosym)	   ; Mirror lib backup.
	  putfile, mrbak, a				   ; Write out.
	endif
 
	;-------  Look for line without item  -------------
	w = where(b ne itm, cnt)	; Where and how many times.
 
	;-------  Drop  --------------
        nbefore = n_elements(a)
	if cnt gt 0 then a = a(w)	; Pull out only lines without item.
        nafter = n_elements(a)
	d = nbefore-nafter
	print,'    Dropped '+strtrim(d,2)+$
	  ' occurance'+(['s','','s'])(d<1>0)+' from cat.one   '
 
	;-------  Write back out  --------
	putfile, mnfile, a		; Updated main cat.one file.
	if mirror ne '' then begin
	  mrfile = filename(mirror,'cat.one',/nosym)  ; Mirror lib path.
	  putfile, mrfile, a		; Updated mirror cat.one file.
	endif
 
	err = 0				; OK.
 
	return
	end
 
 
;********  Handle release_notes.txt  **********************
;**********************************************************
	;================================================
	;  add_notes = edit release_notes.txt
	;================================================
	pro add_notes, item, main=main, mirror=mirror
 
	if n_params(0) lt 1 then begin
	  print,' Update release_notes.txt.'
	  print,' add_notes, item'
	  print,'   item = routine name.    in'
	  print,' Keywords:'
	  print,'   MAIN=main      full path to main lib.'
	  print,'   MIRROR=mirror  full path to mirror lib.'
	  return
	endif
 
	;-----  Pick off just routine name  ---------
	itm = getwrd(item,delim=':')
	;-----  Read in current release_notes.txt from main lib  -------
	mnfile = filename(main,'release_notes.txt',/nosym)
	b = getfile(mnfile,error=err,/quiet)
	if err ne 0 then b = ''		; Create release_notes.txt
	;-----  Make backup copies in main and mirror  --------
	mnbak = filename(main,'release_notes.bak',/nosym)
	putfile, mnbak, b
	if mirror ne '' then begin
	  mrbak = filename(mirror,'release_notes.bak',/nosym)
	  putfile, mrbak, b
	endif
	;-----  Add date and routine name to an edit copy -------
	txt = [wordorder(systime(),[2,1,4]),'  '+strupcase(itm)+': ', b]
	putfile,'edit.tmp',txt
	;------  Edit it.  First read editor file  ---------
	editor = getenv('EDITOR')
	if editor eq '' then begin
	  print,' Warning in LIBR: Environmental variable EDITOR'
	  print,'   not found, defaulting to vi.'
	  editor = 'vi'
	endif
	spawn,editor+' edit.tmp'		  ; Edit copy file.
	;-------  Update release_notes.txt ?  -------------
	a = getfile('edit.tmp')
	putfile, mnfile, a
	if mirror ne '' then begin
	  mrfile = filename(mirror,'release_notes.txt',/nosym)
	  putfile, mrfile, a
	endif
 
	return
	end
 
;********  Initialize libr common  ************************
;**********************************************************
	;================================================
	;  init_librcom = make sure internal common is ok.
	;================================================
	pro init_librcom
 
	common libr_com, last_libnum, last_file, last_wild, last_dir, $
	  last_fromnum, last_tonum, last_addnum
 
	if n_elements(last_libnum) eq 0 then last_libnum = 2
	if n_elements(last_fromnum) eq 0 then last_fromnum = 2
	if n_elements(last_addnum) eq 0 then last_addnum = 2
	if n_elements(last_tonum) eq 0 then last_tonum = 2
	if n_elements(last_file) eq 0 then last_file = 'none'
	if n_elements(last_wild) eq 0 then last_wild = '*.pro'
	if n_elements(last_dir) eq 0 then cd,curr=last_dir
 
	return
	end
 
 
;********  File utilities   *******************************
;**********************************************************
	;================================================
	;  write_file = write text array to main and mirror files.
	;================================================
	pro write_file, txtarr, name, main=main, mirror=mirror
 
	mnfile = filename(main, name, /nosym)	; Name of file to overwrite.
	old = getfile(mnfile,error=err,/quiet)	; Try to read old version 1st.
	if err eq 0 then begin			; If it was read, make backup
	  mnbak = filename(main,'routine_old.bak',/nosym)  ; in routine_old.bak
	  putfile,mnbak,old, error=err		; before writing new.
	endif
	putfile,mnfile,txtarr, error=err	; Write new version.
	if err ne 0 then begin
	  print,' Error writing '+mnfile
	  stop,' Debug stop in WRITE_FILE.'
	endif
 
	if mirror ne '' then begin
	  mrfile = filename(mirror, name, /nosym)
	  old = getfile(mrfile,error=err,/quiet)  ; Try to read old version 1st.
	  if err eq 0 then begin		  ; If it was read, make backup
	    mrbak=filename(mirror,'routine_old.bak',/nosym) ; in routine_old.bak
	    putfile,mrbak,old, error=err		; before writing new.
	  endif
	  putfile,mrfile,txtarr, error=err
	  if err ne 0 then begin
	    print,' Error writing '+mrfile
	    stop,' Debug stop in WRITE_FILE.'
	  endif
	endif
 
	return
	end
 
;**********************************************************
	;================================================
	;  delete_file = Delete a file from main and mirror libs.
	;     No backup copies made by this routine.
	;================================================
	pro delete_file, name, main=main, mirror=mirror
 
	mnfile = filename(main, name, /nosym)
	on_ioerror, j1
	openr,lun,mnfile,/get_lun, /delete
	close, lun
j1:	free_lun, lun
	on_ioerror, null
 
	if mirror ne '' then begin
	  mrfile = filename(mirror, name, /nosym)
	  on_ioerror, j2
	  openr,lun,mrfile,/get_lun, /delete
	  close, lun
j2:	  free_lun, lun
	  on_ioerror, null
	endif
 
	return
	end
 
 
;********  Main routines  *********************************
;**********************************************************
	;================================================
	;  add = add or update a routine
	;================================================
	pro add
 
	common libr_com, last_libnum, last_file, last_wild, last_dir, $
	  last_fromnum, last_tonum, last_addnum
 
	init_librcom
 
	;------  Select library  --------
	get_lpath, tmp, liblist=liblist, /quiet	; List of libs.
	txtpick,liblist,lib,title='ADD: select library',$
	  selection=last_libnum, abort='  QUIT'
	if lib eq 'none' then return
	get_lpath,main,mirror,library=lib,/quiet
	;------  Select target file  -------
	file = last_file
	txtgetfile,file,title='ADD: select routine to add or update',$
	  wild=last_wild, directory=last_dir,def_extension='pro', $
	  option1=['Display file','morefile'], numdef=last_addnum
	last_file = file
	if file eq 'none' then return
	printat,1,1,/clear
	printat,2,2,'Adding routine '+file
	printat,2,3,'  to library '+lib
	filebreak,file,nvfile=name
	;------  Add template  -------
	printat,2,5,'Updating template . . .'
	add_template, file
	;------  Extract one liner  -----------
	printat,2,7,'Extracting one liner . . .'
	extracthlp,file,/arr,/liner,one, error=helperr
	one = one(0)
	printat,2,8,one
	;------  Copy file to main and mirror libraries  --------
	printat,2,10,'Copying routine to main and mirror libraries . . .'
	txt = getfile(file)
	write_file, txt, name, main=main, mirror=mirror
	if helperr eq 0 then begin
	  ;------  update alph.one  ---------
	  printat,2,11,'Updating alph.one . . .'
	  printat,2,12,''
	  add_alph, one, main=main, mirror=mirror
	  ;------  update cat.one  ---------
	  printat,2,13,'Updating cat.one . . .'
	  printat,2,14,''
	  add_cat, one, main=main, mirror=mirror
	endif
	;------  update newlist.txt  ---------
	printat,2,15,'Updating newlist.txt . . .'
	printat,2,16,''
	add_new, one, main=main, mirror=mirror
	;------  update release_notes.txt  ---------
	txtmess,'Press RETURN to update release_notes.txt',x=2,y=18,/noclear
	add_notes, one, main=main, mirror=mirror
	
	return
	end
 
;**********************************************************
	;================================================
	;  move = move a routine
	;    /TRASH means move a routine to trash directory.
	;    That is how routines are deleted from a library.
	;================================================
	pro move, trash=trash
 
	common libr_com, last_libnum, last_file, last_wild, last_dir, $
	  last_fromnum, last_tonum, last_addnum
 
	init_librcom
 
	;------  Select old library  --------
	get_lpath, tmp, liblist=liblist, /quiet	; List of libs.
	if keyword_set(trash) then begin
	  txtpick,liblist,old_lib,title='DELETE: select library',$
	    selection=last_fromnum, abort='  QUIT'
	  if old_lib eq 'none' then return
	endif else begin
	  txtpick,liblist,old_lib,title='MOVE: select FROM library',$
	    selection=last_fromnum, abort='  QUIT'
	  if old_lib eq 'none' then return
	endelse
	get_lpath,old_main,old_mirror,library=old_lib,/quiet
	;------  Select new library  --------
	if keyword_set(trash) then begin
	  new_lib='trash'
	endif else begin
	  txtpick,liblist,new_lib,title='MOVE: select TO library',$
	    selection=last_tonum, abort='  QUIT'
	  if new_lib eq 'none' then return
	endelse
	get_lpath,new_main,new_mirror,library=new_lib,/quiet
	;------  Select target file  -------
	file = 'none'
	if keyword_set(trash) then begin
	  txtgetfile,file,title='DELETE: select routine to delete',$
	    wild=last_wild, directory=old_main,$
	    option1=['Display file','morefile']
	endif else begin
	  txtgetfile,file,title='MOVE: select routine to move',$
	    wild=last_wild, directory=old_main,$
	    option1=['Display file','morefile']
	endelse
	last_file = file
	if file eq 'none' then return
	printat,1,1,/clear
	if keyword_set(trash) then begin
	  printat,2,2,'Deleting routine '+file
	  printat,2,3,'  from library '+old_lib
	  printat,2,4,'  (moving to trash: '+new_lib+')'
	endif else begin
	  printat,2,2,'Moving routine '+file
	  printat,2,3,'  from library '+old_lib
	  printat,2,4,'  to library '+new_lib
	endelse
	filebreak,file,nvfile=name
	;------  Add template  -------
	printat,2,5,'Updating template . . .'
	add_template, file
	;------  Extract one liner  -----------
	printat,2,6,'Extracting one liner . . .'
	extracthlp,file,/arr,/liner,one,error=helperr
	one = one(0)
	printat,2,7,one
	;------  Copy to new main and mirror directories  --------
	printat,2,8,'Copying routine to new main and mirror libraries . . .'
	txt = getfile(file)
	write_file, txt, name, main=new_main, mirror=new_mirror
	;------  Make old lib backups  ---------
	printat,2,9,'Making backups in old libraries (backup.bak) . . .'
	write_file, txt, 'routine_del.bak', main=old_main, mirror=old_mirror
	;------  Delete routine from old main and mirror libraries  ---
	printat,2,10,'Deleting routines from old libraries . . .'
	delete_file, name, main=old_main, mirror=old_mirror
	if helperr eq 0 then begin
	  ;------  update alph.one  ---------
	  printat,2,11,'Updating alph.one (old main,mirror,new main,mirror) ...'
	  printat,2,12,''
	  add_alph, one, main=new_main, mirror=new_mirror
	  drop_alph, one, main=old_main, mirror=old_mirror
	  ;------  update cat.one  ---------
	  printat,2,13,'Updating cat.one (old main,mirror,new main,mirror) ...'
	  printat,2,14,''
	  add_cat, one, main=new_main, mirror=new_mirror
	  drop_cat, one, main=old_main, mirror=old_mirror
	endif
	;------  update newlist.txt  ---------
	printat,2,15,$
	  'Updating newlist.txt (old main,mirror,new main,mirror) . . .'
	printat,2,16,''
	add_new, one, main=new_main, mirror=new_mirror
	drop_new, one, main=old_main, mirror=old_mirror
	;------  update release_notes.txt  ---------
	txtmess,'Press RETURN to update OLD release_notes.txt',x=2,y=18,/noclear
	add_notes, one, main=old_main, mirror=old_mirror
	if keyword_set(trash) then begin
	  txtmess,'Press RETURN to update TRASH release_notes.txt',x=2,y=18
	endif else begin
	  txtmess,'Press RETURN to update NEW release_notes.txt',x=2,y=18
	endelse
	add_notes, one, main=new_main, mirror=new_mirror
	
	return
	end
 
;**********************************************************
	;================================================
	;  exam = Examine a library
	;================================================
	pro exam
 
	common libr_com, last_libnum, last_file, last_wild, last_dir, $
	  last_fromnum, last_tonum, last_addnum
 
	init_librcom
 
	;------  Select library  --------
	get_lpath, tmp, liblist=liblist, /quiet	; List of libs.
	txtpick,liblist,lib,title='Select library to EXAMINE',$
	  selection=last_libnum, abort='  QUIT'
	if lib eq 'none' then return
	get_lpath,main,mirror,library=lib,/quiet
 
	;------  Select target file  -------
	file = last_file
loop:	txtgetfile,file,title='Select text file to EXAMINE',$
	  wild=last_wild, directory=main, numdef=last_libnum
	if file eq 'none' then return
	last_file = file
	morefile, file
	goto, loop
	return
	end
 
;**********************************************************
	;================================================
	;  refs = Find references to a routine
	;================================================
	pro refs
 
	common libr_com, last_libnum, last_file, last_wild, last_dir, $
	  last_fromnum, last_tonum, last_addnum
 
	init_librcom
 
	;------  Select library  --------
	get_lpath, tmp, liblist=liblist, /quiet	; List of libs.
	txtpick,liblist,lib,title='Find REFERENCES: Select library to search',$
	  selection=last_libnum, abort='  QUIT'
	if lib eq 'none' then return
	get_lpath,main,mirror,library=lib,/quiet
 
	;------  Do a grep  --------
	file = filename(main,'*.pro',/nosym)	; Make wildcard: /.../*.pro.
	printat,1,1,/clear
	printat,1,2,''
	txt = ''
	read,' Enter routine to search for: ',txt
	if txt eq '' then return
	print,' Searching '+main+'
	print,'   for references to '+txt+' . . .'
	spawn,'grep -il '+txt+' '+file, res
	w = where(res ne '', cnt)
	if cnt gt 0 then res = res(w)
	for i = 0, cnt-1 do begin
	  filebreak, res(i), name=tmp
	  res(i) = tmp
	endfor
	print,' Files found referencing '+txt+': '+strtrim(cnt,2)
	print,' '
	more,'    '+res
	print,' '
	read,' Press RETURN to continue',txt
	return
	end
 
;**********************************************************
	;================================================
	;  list_exten = List all unique file extensions
	;================================================
	pro list_exten
 
	common libr_com, last_libnum, last_file, last_wild, last_dir, $
	  last_fromnum, last_tonum, last_addnum
 
	init_librcom
 
	;------  Select library  --------
	get_lpath, tmp, liblist=liblist, /quiet	; List of libs.
	txtpick,liblist,lib,title='List EXTENSIONS: Select library to search',$
	  selection=last_libnum, abort='  QUIT'
	if lib eq 'none' then return
	get_lpath,main,mirror,library=lib,/quiet
 
	;-------  Select main or mirror  ------------
	in = 2
	txtpick,['Main','Mirror'],pck,title='Select Main or Mirror library',$
	  selection=in, abort='  QUIT'
	if pck eq 'none' then return
	pcklib = main
	if pck eq 'Mirror' then pcklib = mirror
 
	get_ext, pcklib
 
	return
	end
 
 
;**********************************************************
	;================================================
	;  check_ones = Check that all routines are in alph.one & cat.one
	;================================================
	pro check_ones
 
	common libr_com, last_libnum, last_file, last_wild, last_dir, $
	  last_fromnum, last_tonum, last_addnum
 
	init_librcom
 
	;------  Select library  --------
	get_lpath, tmp, liblist=liblist, /quiet	; List of libs.
	txtpick,liblist,lib,title=$
	  'CHECK alph.one/cat.one: Select library to search',$
	  selection=last_libnum, abort='  QUIT'
	if lib eq 'none' then return
	get_lpath,main,mirror,library=lib,/quiet
 
	;------  Get a list of all *.pro files in lib  ---------
	file = filename(main,'*.pro',/nosym,delim=dlm)
	list = findfile(file,count=cnt)
 
	if cnt lt 1 then begin
	  txtmess,['No *.pro files found in the following library:',$
	    main]
	  return
	endif
 
	nam = list
	for i = 0, cnt-1 do begin
	  nam(i) = getwrd(getwrd(list(i),/last,delim=dlm),delim='.')
	endfor
 
	printat,1,1,/clear
	printat,5,3,$
	  'Checking for routines not documented in alph.one & cat.one'
	printat,5,5,'Library: '+main
	printat,5,6,'    contains '+strtrim(cnt,2)+' routines.'
 
	errarr = ['']
	alph = filename(main,'alph.one',/nosym)
	cat = filename(main,'cat.one',/nosym)
	numerr = 0
	printat,5,8,'Number of errors found: '+string(numerr)
	printat,5,9,'Last error message: '
	for i = 0, cnt-1 do begin
	  txt = nam(i)
	  printat,5,12,'Checking: ',strtrim(i+1,2)+'  '+txt+spc(70,txt)
	  errtxt ='' 
	  spawn,/noshell,['grep','^'+txt+' = ',alph], res
	  if res(0) eq '' then begin
	    errtxt = txt+': alph.one '
	    numerr = numerr + 1
	    printat,29,8,string(numerr)
	    printat,26,9,errtxt+'            '
	  endif
	  spawn,/noshell,['grep','^'+txt+' = ',cat], res
	  if res(0) eq '' then begin
	    if errtxt eq '' then errtxt = txt+': '
	    errtxt = errtxt+'cat.one '
	    numerr = numerr + 1
	    printat,29,8,string(numerr)
	    printat,26,9,errtxt+'            '
	  endif
	  if errtxt ne '' then errarr = [errarr,errtxt]
	endfor
	if n_elements(errarr) gt 1 then begin
	  errarr(0) = 'aplh/cat missing routines for lib '+main+':'
	  putfile,'ones_error.tmp',errarr
	  txtmess,'Errors listed in ones_errors.tmp',/noclear,x=5,y=16
	endif else begin
	  txtmess,'No missing routines found.',/noclear,x=5,y=16
	endelse
 
	return
	end
 
;**********************************************************
	;================================================
	;  help = Display help text
	;================================================
	pro libr_help
 
	;-------  Try to IDL_IDLDOC directory   --------
	docdir = getenv('IDL_IDLDOC')
	if docdir eq '' then begin
	  printat,1,1,/clear
	  print,' Error in libr_help: the unix environmental variable'
	  print,'   IDL_IDLDOC was not found. This points to one of the' 
	  print,'   local IDL libraries, the one containing the LIBR software.'
	  print,'   Define it and try again (setidl will define it).'
	  txt = ''
	  read,' Press RETURN to continue',txt
	  return
	endif
 
	;-------  Now dump help file  ---------
	printat,1,1,/clear
	helpfile, /txtmenu, 'libr.hlp', dir=docdir
	txt = ''
	read,' Press RETURN to continue',txt
 
	return
	end
 
 
;********  Main program  ********************************** 
;**********************************************************
	;================================================
	;  libr = Main librarian routine
	;================================================
	pro libr, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Maintains multiple IDL libraries.'
	  print,' libr'
	  print,'   No args.  Gives a menu screen.'
	  print,' Notes: the functions are:'
	  print,'   Add/Update a routine to a library.'
	  print,'   Move a routine from one library to another.'
	  print,'   Delete a routine from a library.'
	  print,'   Examine routines in a library.'
	  print,'   Search for references to a routine in a library.'
	  print,'   Check that all library routines are in alph.one & cat.one.'
	  print,'   Need to set up the file .idl_libs in your home directory:'
	  print,'   do .run libr'
	  print,'       get_lpath,/help'
	  print,'   for .idl_libs file format.'
	  return
	endif
 
	menu = ['|10|2|LIBR --- IDL librarian|||',$
		'|10|5|QUIT| |QUIT|',$
		'|10|7|ADD or update a routine| |ADD|',$
		'|10|9|MOVE a routine from one library to another| |MOV|',$
		'|10|11|DELETE a routine from a library| |DEL|',$
		'|10|13|EXAMINE a library| |EXAM|',$
		'|10|15|SEARCH for references to a routine| |REFS|',$
		'|10|17|CHECK that all routines are in alph.one & '+$
		  'cat.one| |CHK|',$
		'|10|19|EXTENSION, list file types| |EXT|',$
		'|10|21|HELP| |HELP|']
 
	opt = 'ADD'
 
mloop:	txtmenu, init=menu
 
	txtmenu, select=opt, uval=uval
 
	case uval of
'QUIT':	begin
	  printat,1,1,/c
	  return
	end
'ADD':	begin
	  add
	  goto, mloop
	end
'MOV':	begin
	  move
	  goto, mloop
	end
'DEL':	begin
	  move, /trash
	  goto, mloop
	end
'EXAM':	begin
	  exam
	  goto, mloop
	end
'REFS':	begin
	  refs
	  goto, mloop
	end
'CHK':	begin
	  check_ones
	  goto, mloop
	end
'EXT':	begin
	  list_exten
	  goto, mloop
	end
'HELP':	begin
	  libr_help
	  goto, mloop
	end
	endcase
 
	end
