pro dbopen,name,update,UNAVAIL=unavail   
;+
; NAME:
;	DBOPEN
; PURPOSE:
;	Routine to open an IDL database
;
; CALLING SEQUENCE:
;	dbopen, name, update
;
; INPUTS:
;	name - (Optional) name or names of the data base files to open.
;		It has one of the following forms:
;
;		'name'		-open single data base file
;		'name1,name2,...,nameN' - open N files which are
;				connected via pointers.
;		'name,*'	-Open the data base with all data
;				bases connected via pointers
;		''		-Interactively allow selection of
;				the data base files.
;
;		If not supplied then '' is assumed.
;		name may optionally be a string array with one name
;		per element.
;
;	update - (Optional) Integer flag specifing openning for update.
;		0 	- Open for read only
;		1	- Open for update
;		2	- Open index file for update only
;		!PRIV must be 2 or greater to open a file for update.
;		If a file is opened for update only a single data base
;		can be specified.
;
; OUTPUTS:
;	none
;
; KEYWORDS:
;	UNAVAIL - If present, a "database doesn't exit" flag is returned
;	          through it.  0 = the database exists and was opened (if
;	          no other errors arose).  1 = the database doesn't exist.
;	          Also if present, the error message for non-existent databases
;	          is suppressed.  The action, however, remains the same.  If
;	          specifiying this, be sure that the variable passed exists
;	          before the call to DBOPEN.
; SIDE EFFECTS:
;	The .DBF and .dbx files are opened using unit numbers obtained by
; 	GET_LUN.  Descriptions of the files are placed in the common block
; 	DB_COM.
;
; HISTORY:
;	Version 2, D. Lindler, Nov. 1987
;       For IDL Version 2  W. Landsman May 1990 -- Will require further 
;           modfication once SCREEN_SELECT is working
;	Modified to work under Unix, D. Neill, ACC, Feb 1991.
;	UNAVAIL keyword added.  M. Greason, Hughes STX, Feb 1993.
;	William Thompson, GSFC/CDS (ARC), 1 June 1994
;		Added support for external (IEEE) representation.
;	William Thompson, GSFC, 3 November 1994
;			Modified to allow ZDBASE to be a path string.
;	8/29/95	JKF/ACC	- forces lowercase for input database names.
;	W. Landsman, Use CATCH to catch errors    July, 1997
;	Converted to IDL V5.0   W. Landsman   September 1997
;-
;
;------------------------------------------------------------------------
On_error,2
;
; data base common block
;
common db_com,QDB,QITEMS,QDBREC
;
; QDB(*,i) contains the following for each data base opened
;
;	bytes
;	  0-18   data base name character*19
;	  19-79  data base title character*61
;	  80-81  number of items (integer*2)
;	  82-83  record length of DBF file (integer*2)
;	  84-87  number of entries in file (integer*4)
;	  88-89  position of first item for this file in QITEMS (I*2)
;	  90-91  position of last item for this file (I*2)
;	  92-95  Last Sequence number used (item=SEQNUM) (I*4)
;	  96	 Unit number of .DBF file
;	  97	 Unit number of .dbx file (0 if none exists)
;	  98-99  Index number of item pointing to this file (0 for first db)
;	  100-103 Number of entries with space allocated
;	  104	 Update flag (0 open for read only, 1 open for update)
;	  119	 Equals 1 if external data representation (IEEE) is used
;
;  QITEMS(*,i) contains decription of item number i with following
;  byte assignments:
;
;	0-19	item name (character*20)
;	20-21   IDL data type (integer*2)
;	22-23 	Number of values for item (1 for scalar) (integer*2)
;	24-25	Starting byte position in original DBF record (integer*2)
;	26-27	Number of bytes per data value (integer*2)
;	28	Index type
;	29-97	Item description
;	98-99	print format field length
;	100	flag (1 if this items points to a data base)
;	101-119 Data base this item points to
;	120-125 Print format
;	126-170 Print headers
;	171-172 Starting byte in record returned by DBRD
;	173-174 Data base number in QDB
;	175-176 Data base number this item points to
;	177-178 Item number within the specific data base
;
;-------------------------------------------------------------------------
;
;
; check for valid input parameters
;
if n_params(0) lt 1 then name=''
if n_params(0) lt 2 then update=0
 catch, error_status
 if error_status NE 0 then begin 
       print,!ERR_STRING
       return
  endif

zparcheck,'DBOPEN',name,1,7,[0,1],'Data base name[s]'
zparcheck,'DBOPEN',update,2,[1,2,3,4,5],0,'Update flag'
;
; check privilege
;
if update and (!priv lt 2) then  $
	message,'!PRIV must be 2 or greater to open with update'
;
; check UNAVAIL
;
if n_elements(unavail) gt 0 then unav_flg = 1 $
                            else unav_flg = 0
unavail = 0
totret = 1
;---------------------------------------------------------------------
; 	PROCESS INPUT NAMES (CREATE STRING ARRAY)
;
; Process scalar name
;
s=size(name) & ndim=s[0]
if ndim eq 0 then begin
;
; process name=''
;
    if strtrim(name) EQ '' then begin
	names = list_with_path('*.dbh', 'ZDBASE')
	n = N_elements(names)
	fnames = strarr(n)
	for i=0,n-1 do begin
	   fdecomp,names[i],disk,dir,nam,qual,ver
	   fnames[i]=nam
	end
	screen_select,fnames,isel,'db_titles', $
		'Select data base file to open',1
	fnames=fnames[intarr(1)+isel]
      end else begin
;
; separate names into string array
;
	fnames=strarr(20)
	st=strlowcase(strtrim(name,2))
	num=0
	while st ne '' do begin
		fnames[num]=strtrim(gettok(st,','),2)
		st=strtrim(st,2)
		num=num+1
	end
	fnames=fnames[0:num-1]
    end
  end else begin
;
; name is already a string vector
;
    fnames=name
end
;
; if update, only one data base can be opened
;
if update then if N_elements(fnames) gt 1 then $
	message,'Only one file can be specified if mode is update'
;
;---------------------------------------------------------------
;
;	LOOP AND OPEN EACH DATA BASE
;
; close any data bases already open
;
dbclose
;
;
offset=0		;byte offset in dbrd record for data base
tot_items=0		;total number of items all opened data bases
get_lun,unit		;get unit number to use for .dbh files
dbno=0			;present data base number
while dbno lt n_elements(fnames) do begin
    dbname=strtrim(fnames[dbno])
;
; process * if second in list  -----------------------
;
    if dbname eq '*' then begin		;get data base names from pointers
	if dbno ne 1 then begin		;* must be second data base
	    message,'Invalid use of * specification',/continue
	    goto,ABORT   
	endif
	pointers=qitems[100,*]		;find pointer items
	good=where(pointers,n)
	if n eq 0 then goto,done	;no pointers
	pnames=string(qitems[101:119,*]);file names for pointers
	fnames=[fnames[0],pnames[good]] ;new file list
	dbname=strtrim(fnames[1])	;new second name
    end
;
; open .dbh file and read contents ------------------------
;
    dbhname = find_with_def(dbname+'.dbh', 'ZDBASE')
    openr,unit,dbhname,ERROR=err,/SEGMENTED     
;
;  If /SEGMENTED doesn't work, then maybe the file was written in external
;  format.  Try /BLOCK instead.
;
    if err NE 0 then openr,unit,dbhname,ERROR=err,/BLOCK
    if err NE 0 then begin
	if unav_flg EQ 0 then begin
		message,'Error opening .dbh file '+ dbname,/CONTINUE
        	print,!SYSERR_STRING
	endif else totret = 0
	unavail = 1
	goto, ABORT 
    end
    db=bytarr(120)
    readu,unit,db
    external = db[119] eq 1	;Is external data rep. being used?
    totbytes=fix(db,82,1) & totbytes=totbytes[0]
    nitems=fix(db,80,1) & nitems=nitems[0] ;number of items or fields in file
    if external then begin
	ieee_to_host, totbytes	&  db[82] = byte(totbytes,0,2)
	ieee_to_host, nitems	&  db[80] = byte(nitems,0,2)
    endif
    items=bytarr(200,nitems)
    readu,unit,items
    close,unit
    if external then begin
	tmp = fix(items[20:27,*],0,4,nitems)
	ieee_to_host,tmp
	items[20,0] = byte(tmp,0,8,nitems)
;
	tmp = fix(items[98:99,*],0,1,nitems)
	ieee_to_host,tmp
	items[98,0] = byte(tmp,0,2,nitems)
;
	tmp = fix(items[171:178,*],0,4,nitems)
	ieee_to_host,tmp
	items[171,0] = byte(tmp,0,8,nitems)
    endif
;
; add computed information to items ---------------------------
;
    sbyte=fix(items[24:25,*],0,nitems)+offset
    for i=0,nitems-1 do begin
	items[171,i]=byte(sbyte[i],0,2)	;starting byte in DBRD record
	items[173,i]=byte(dbno,0,2)	;data base number
	items[177,i]=byte(i,0,2)	;item number
    end
    offset=offset+totbytes
;
; open .dbf file ---------------------------------
;
    get_lun,unitdbf
    dbf_file = find_with_def(dbname+'.dbf', 'ZDBASE')
    if update eq 1 then begin
         openu,unitdbf,dbf_file,/block
    endif else if dbno gt 0 then $ 
;
;  Modified so that file is always opened with /block.  Needed to support
;  external data format.  Also, more consistent with statement above.
;  William Thompson, 1 June 1994.
;
               openr,unitdbf,dbf_file,/block $
           else openr,unitdbf,dbf_file,/block,error=err
    if err ne 0 then begin
	message,'Error opening '+dbname+'.dbf',/continue
	free_lun,unitdbf
	goto,abort
    end
    p=assoc(unitdbf,lonarr(2))
    head = p[0]
    if external then ieee_to_host, head
    db[96]=unitdbf			;unit number of .dbf file
    db[84]=byte(head[0],0,4)		;number of entries
    db[92]=byte(head[1],0,4)		;last seqnum used
    db[88]=byte(tot_items,0,2)		;starting item number for this db
    tot_items=tot_items+nitems		;new total number of items
    db[90]=byte(tot_items-1,0,2)	;last item number for this db
    db[104]=update			;opened for update
;
; open index file if necessary -----------------------------
;
    index=where(items[28,*] gt 0,nindex)	;indexed items
    if nindex gt 0 then begin		;need to open index file.
	get_lun,unitind
	dbx_file = find_with_def(dbname+'.dbx', 'ZDBASE')
	if update gt 0 then $
                  openu,unitind,dbx_file,error=err,/block $
	   else openr,unitind,dbx_file,error=err,/block
	if err ne 0 then begin
		message,'Error opening index file for '+dbname,/continue
		free_lun,unitdbf
		free_lun,unitind
		goto,abort
	endif
	db[97]=unitind			;unit number for index file
    end
;
; add to common block ---------------------
;
    if dbno eq 0 then begin
	qdb=db
	qitems=items
      end else begin
	old=qdb
	qdb=bytarr(120,dbno+1)
        qdb[0,0] = old
        qdb[0,dbno] = db
	old=qitems
	qitems=bytarr(200,tot_items)
        qitems[0,0] = old
        qitems[0,tot_items-nitems] = items
    end
;
    dbno=dbno+1
end; loop on data bases
done: free_lun,unit
;--------------------------------------------------------------------
;		LINK PROCESSING
;
; determine linkages between data bases
;
numdb = N_elements(fnames)
if numdb gt 1 then begin
    pnames=strupcase(qitems[101:119,*])
    for i=1,numdb-1 do begin
	dbname=strupcase(qdb[0:18,i])	;name of the data base
	for j=0,tot_items-1 do if pnames[j] eq dbname then goto,found
;
; if we made it here we can not link the file -----------
;
	message,'Unable to link data base file '+dbname,/continue
	goto,abort
;
; found linkage item ------------------------------------
;
found:
	item_number=j		;number of item supplying link
	item_db=fix(qitems[173:174,item_number],0,1) & item_db=item_db[0]
	if item_db ge i then begin
		message,'Unable to link data base '+dbname + $
                        'to previous data base.',/continue
		print,'	Possible incorrect ordering of input data bases'
		goto,abort
	endif
	qitems[175,item_number]=byte(i,0,2)	;data base number pointed to
	qdb[98,i]=byte(item_number,0,2)		;item number pointing to this db
nextdb:
    endfor
endif
;
; create an assoc variable for the first db
;
unit=db_info('unit_dbf',0)
len=db_info('length',0)
qdbrec=assoc(unit,bytarr(len))
;----------------------------------------------------------------------------
; done
;
return
;
; abort
;
abort:
dbclose				;close any open data bases
free_lun,unit
if (totret NE 0) then retall else return
end
