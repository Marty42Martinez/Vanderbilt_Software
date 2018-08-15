FUNCTION get_source_path,routine_name=routine_name

 ; finds the path to the source of a compiled function.
 ; uses the help command (not recommended by ITT
 ;
 IF NOT(KEYWORD_SET(routine_name)) THEN routine_name='WIS_IMAGE'

 help,/source,out=out
 
 ind = STREGEX(out,STRUPCASE(routine_name))
 
 i = WHERE(ind GE 0)
 
 IF i[0] NE -1 THEN BEGIN
   
  path = (STRCOMPRESS(STRSPLIT(out[i[0]],' ',/EXTRACT),/REMOVE))[1]
  path = FILE_DIRNAME(path)+'/'
  
 ENDIF ELSE BEGIN
   path='' 
 ENDELSE
 
 RETURN,path
 
END 
