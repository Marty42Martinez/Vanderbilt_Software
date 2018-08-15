FUNCTION read_infofile,file


   obs = { $
           number  : 0L , $
           icam    : 0  , $
           jul     : 0D , $
           imgfile : ''   $
          } 
          
   out = LIST()       
   s = ''
   OPENR,1,file
   
   m= 0
   y=0
   d=0
   hh=0
   mm=0
   ss=0.0
   
   WHILE NOT(EOF(1)) DO BEGIN
      READF,1,s
      x = STRCOMPRESS(STRSPLIT(s,/EXTRACT),/REMOVE)
      IF x[0] EQ 'snowflake' OR x[0] EQ 'flake' THEN CONTINUE
      
      
      READS,x[2],FORM = '(I2,1X,I2,1X,I4)'  ,m,d,y
      READS,x[3],FORM = '(I2,1X,I2,1X,F9.6)',hh,mm,ss
      obs.number  = LONG(x[0])
      obs.icam    = FIX(x[1])
      obs.jul     = JULDAY(m,d,y,hh,mm,ss)
      obs.imgfile = x[4]
      
      out.add,obs
   
   ENDWHILE

   CLOSE,1
   
   out=out.toarray()

   RETURN,out
   
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION read_datafile,file


   obs = { $
           dir       : FILE_DIRNAME (file,/MARK_DIR), $
           file      : FILE_BASENAME(file), $
           number    : 0L , $
           jul       : 0D , $
           fallspeed : 0.0, $
           imgfile   : STRARR(3), $
           imgjul    : DBLARR(3)  $
          } 
          
   out = LIST()       
   s = ''
   OPENR,1,file
   
   m= 0
   y=0
   d=0
   hh=0
   mm=0
   ss=0.0
   
   WHILE NOT(EOF(1)) DO BEGIN
      READF,1,s
      x = STRCOMPRESS(STRSPLIT(s,/EXTRACT),/REMOVE)
      
      IF x[0] EQ 'snowflake' OR x[0] EQ 'flake' THEN CONTINUE
      
      
      READS,x[1],FORM   = '(I2,1X,I2,1X,I4)' ,m,d,y
      READS,x[2],FORM   = '(I2,1X,I2,1X,F9.6)',hh,mm,ss

      obs.number    = LONG(x[0])
      obs.jul       = JULDAY(m,d,y,hh,mm,ss)
      obs.fallspeed = FLOAT(x[3])
      
      out.add,obs
   
   ENDWHILE

   CLOSE,1
   
   out=out.toarray()

   RETURN,out
   
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION read_masc_dir,dir=dir
 
 KEYWORD_DEFAULT,dir,'/Users/ralf/Desktop/MASC/BOULDER/1BASE_2014.04.03_Hr_01/'
 
 infofile = (FILE_SEARCH (dir,'imgInfo.txt' ))[0]
 datafile = (FILE_SEARCH (dir,'dataInfo.txt'))[0]
 
 IF infofile EQ '' THEN BEGIN
   PRINT,'info file missing'
   PRINT,'Directory : ', dir
   RETURN,[-1]
 ENDIF
 
 IF datafile EQ '' THEN BEGIN
   PRINT,'data file missing'
   PRINT,'Directory : ', dir
   RETURN,[-1]
 ENDIF
 
 inf = read_infofile(infofile)
 dat = read_datafile(datafile)
 
 IF N_ELEMENTS(dat) EQ 0 THEN RETURN,[-1]
 IF N_ELEMENTS(inf) EQ 0 THEN RETURN,[-1]
 
 
 FOR i=0,N_ELEMENTS(dat)-1 DO BEGIN
   
      ; find corresponding images...
      ind = WHERE(inf.number EQ dat[i].number)
      IF N_ELEMENTS(ind) NE 3 THEN CONTINUE

      ; see if ongs exist.....
      f1=QUERY_PNG(dir+inf[ind[0]].imgfile)    
      f2=QUERY_PNG(dir+inf[ind[1]].imgfile)    
      f3=QUERY_PNG(dir+inf[ind[2]].imgfile)       
      IF f1 EQ 0 OR f2 EQ 0 OR f3 EQ 0 THEN CONTINUE

      dat[i].imgjul         = inf[ind].jul
      isort                 = inf[ind].icam
      dat[i].imgfile[isort] = inf[ind].imgfile
   
 ENDFOR

 ; no files found...
 IF N_ELEMENTS(dat) EQ 1 AND dat[0].imgfile[0] EQ '' THEN RETURN,[-1]
 
 RETURN,dat
 

END
