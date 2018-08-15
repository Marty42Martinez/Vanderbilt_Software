; this is a reader for Excel .csv files. It has not been tested much, 
; so when you use it, make sure it is doing things right.....
; the main program is read_csv 
;
;  call: IDL> read_csv,'file.csv',data
;
;  returns two dimensional data field of type STRING with column entries
;
FUNCTION parse_one_line,a

     ; first get all comma delimited columns
    s = STRSPLIT(a,',',/EXTRACT)
    
    ; now make sure that commas in column entryies are treated corretly...
    ncols = N_ELEMENTS(s)
    i = 0
    REPEAT BEGIN
       ; search for strings that hold exatly one " (otherwise expression is 
       a1 = STRPOS(s[i],'"') ;'
       a2 = STRPOS(s[i],'"',/REVERSE_SEARCH) ; '
       
       IF a1 GE 0 AND a2 EQ a1 THEN BEGIN 
          
          ; now add all folliwng strings to s[i] until the match " is found....
          j=i 
          REPEAT BEGIN
            j     = j + 1
            ncols = ncols - 1
            s[i]  = s[i]+s[j]
          ENDREP UNTIL STRPOS(s[j],'"') GE 0 ;'
          
          ; shrink s.....
          IF j LT ncols -1 THEN s = [s[0:i],s[j+1:*]] ELSE s=s[0:i]
          
       ENDIF
       i = i + 1  
    ENDREP UNTIL i GE ncols 

   RETURN,s
END


PRO read_csv,filename,xout,n_lines_head=n_lines_head

  
  IF N_ELEMENTS(n_lines_head) EQ 0 THEN  n_lines_head=0
  
  a = ''
  
  OPENR,lun,filename,width=1000,/GET

  FOR line=1,n_lines_head DO READF,lun,a
  
  WHILE NOT(EOF(lun)) DO BEGIN
  
    line = line + 1
    READF,lun,a
    
    s = STRSPLIT(a,',',/EXTRACT)
    s = parse_one_line(a)
    
    IF a NE '' AND NOT ((N_ELEMENTS(s) EQ 1 and s[0] EQ '')) THEN BEGIN
       IF N_ELEMENTS(xxx) EQ 0 THEN BEGIN
           ncols = N_ELEMENTS(s)
           xxx = s
        ENDIF ELSE BEGIN

           IF N_ELEMENTS(s) EQ ncols THEN BEGIN
              xxx = [[xxx],[s]]
           ENDIF ELSE BEGIN
                IF N_ELEMENTS(s) GT ncols THEN BEGIN 
                   ; if rightmost columns are empty csv files do not give commas,
                   ; thus the entire field needs to be expanded, if a line with more columns 
                   ; is encountered.
                   xlin  = N_ELEMENTS(xxx)/ncols
                   yyy   = STRARR(N_ELEMENTS(s),xlin+1)
                   FOR i = 0,xlin-1 DO yyy[0:ncols-1,i] = xxx[*,i]
                   ; now add the new element
                   yyy[*,xlin]    = s
                   ; now make sure xxx and ncols are up to date
                   xxx            = yyy
                   ncols          = N_ELEMENTS(s)
                ENDIF ELSE BEGIN
                  PRINT,'no of cols does not match, line : ',line
                  STOP
                ENDELSE  
           ENDELSE
        ENDELSE
    ENDIF
  ENDWHILE
  
  
  xout = xxx
  FREE_LUN,lun



END
