pro ftab_ext,file_or_fcb,columns,v1,v2,v3,v4,v5,v6,v7,v8,v9,ROWS=rows, $
        EXTEN_NO = exten_no
;+
; NAME:
;       FTAB_EXT
; PURPOSE:
;       Routine to extract columns from a FITS (binary or ASCII) table
;
; CALLING SEQUENCE:
;       FTAB_EXT, name, columns, v1, [v2,..,v9, ROWS=, EXTEN_NO= ]
; INPUTS:
;       name - name of a FITS file containing a (binary or ASCII) table 
;               extension, scalar string
;       columns - table columns to extract.  Can be either 
;               (1) String with names separated by commas
;               (2) Scalar or vector of column numbers
;
; OUTPUTS:
;       v1,...,v9 - values for the columns
;
; OPTIONAL INPUT KEYWORDS:
;       ROWS -  scalar or vector giving row number(s) to extract
;               Row numbers start at 0.  If not supplied or set to
;               -1 then values for all rows are returned
;       EXTEN_NO - Extension number to process.   If not set, then data is
;               extracted from the first extension in the file (EXTEN_NO=1)
;
; EXAMPLES:
;       Read wavelength and flux vectors from the first extension of a 
;       FITS file, 'spec.fit'.   Using FTAB_HELP,'spec.fit' we find that this
;       information is in columns named 'WAVELENGTH' and 'FLUX' (in columns 1
;       and 2).   To read the data
;
;       IDL> ftab_ext,'spec.fit','wavelength,flux',w,f
;               or
;       IDL> ftab_ext,'spec.fit',[1,2],w,f
;       
; PROCEDURES CALLED:
;       FITS_READ, FITS_CLOSE, FTGET(), GETTOK(), TBINFO, TBGET()
; HISTORY:
;       version 1        W.   Landsman         August 1997
;       Converted to IDL V5.0   W. Landsman   September 1997
;       Improve speed processing binary tables  W. Landsman   March 2000
;-
;---------------------------------------------------------------------
 if N_params() LT 3 then begin
        print,'Syntax - ftab_ext, name, columns, v1, [v2,...,v9, ROWS=, EXTEN=]'
        return
 endif
 n_ext = N_params() - 2
 sz_name = size(columns)
 strng = sz_name[sz_name[0]+1] EQ 7    ;Is colname a string?

 if not keyword_set(exten_no) then exten_no = 1
 sz = size(file_or_fcb)
 if sz[sz[0]+1] NE 8 then fits_open,file_or_fcb,fcb else fcb=file_or_fcb
 if fcb.nextend EQ 0 then $
        message,'ERROR - FITS file contains no table extensions'
 if fcb.nextend LT exten_no then $
        message,'ERROR - FITS file contains only ' + strtrim(fcb.nextend,2) + $
                ' extensions'

 if N_elements(rows) NE 0 then begin
        minrow = min(rows, max = maxrow)
        naxis1 = fcb.axis[0,exten_no]
        first = naxis1*minrow
        last = naxis1*(maxrow+1)-1
        xrow = rows - minrow
        fits_read,fcb,tab,htab,exten_no=exten_no,first=first,last=last,/no_pdu
        tab = reform(tab,naxis1,maxrow-minrow+1)
 endif else begin
        fits_read, fcb, tab, htab, exten_no=exten_no,/no_pdu 
        xrow = -1
 endelse
 fits_close,fcb
 ext_type = fcb.xtension[exten_no]

 case ext_type of
 'A3DTABLE': binary = 1b
 'BINTABLE': binary = 1b
 'TABLE': binary = 0b
 else: message,'ERROR - Extension type of ' + $
                ext_type + 'is not a FITS table format'
 endcase

 colnames= columns
 if binary then tbinfo,htab,tb_str

 for i = 0, N_ext-1 do begin
        if strng then colname = strtrim( GETTOK(colnames,','),2) $
                 else colname = colnames[i]
        if binary then $
                v = TBGET( tb_str,tab,colname,xrow,nulls) else $
                v = FTGET( htab,tab,colname,xrow,nulls)
        command = 'v'+strtrim(i+1,2)+'=v'
        istat = execute(command)
 endfor
 return
 end 


