@masc_find_all_matches

FUNCTION cutflake_internal,flake,xr,yr
  KEYWORD_DEFAULT,edge,10
   
  
  x0=xr[0]-edge
  x1=xr[1]+edge
  y0=yr[0]-edge
  y1=yr[1]+edge
  
  x  = flake[x0:x1,y0:y1]
  s  = SIZE(x)
  x[0:edge-1,       *] = 0
  x[*       ,0:edge-1] = 0
  x[s[1]-edge+1:*,            *] = 0
  x[*            ,s[2]-edge+1:*] = 0
  
  RETURN,x
  
END  

PRO mascobs_container::import_from_raw,_EXTRA=_EXTRA

     q         = read_masc_dir(_EXTRA=_EXTRA)
     IF SIZE(q,/TYPE) NE 8 THEN RETURN
     
     n_eval    = N_ELEMENTS(q)
     IF N_Eval EQ 0 THEN RETURN
     
     errorcode = FLTARR(11)
     l         = LIST()

     ismulti   = FLTARR(n_Eval)
     FOR i=0,n_eval-1 DO BEGIN
     
        r=find_match(q[i],match,_EXTRA=_EXTRA,img0,img1,img2)
        IF r EQ 0 THEN BEGIN
           
           im0 = cutflake_internal(img0,match.reg0.xr,match.reg0.yr)
           im1 = cutflake_internal(img1,match.reg1.xr,match.reg1.yr)
           im2 = cutflake_internal(img2,match.reg2.xr,match.reg2.yr)
           
           xxx = STRSPLIT(q[i].imgfile[0],'_',/EXTR)
           ifl = WHERE(xxx EQ 'flake',cnt)
           IF cnt NE 1 THEN STOP
           flakenumber=FIX(xxx[ifl[0]+1])
                      
           o = OBJ_NEW('mascobs',q[i].jul,q[i].fallspeed,match.xyz,im0,im1,im2,match.m0,match.m1,match.m2, $
                                 match.if0,match.if1,match.if2,match.ismulti, $
                                 q[i].dir,flakenumber)
           
           self.add,o
           ismulti[i] = match.ismulti

        ENDIF
        errorcode[ABS(r[0])] =  errorcode[ABS(r[0])] + 1
        print,i+1,' of ',N_ELEMENTS(q),' error code : ',r[0]
    ENDFOR

     nok           = self.count()
     a             = self.toarray()
     dum           = WHERE(ismulti GT 1,nmulti)
     nbelowthres   = TOTAL(errorcode[[1,2,3]])
     nareatoosmall = TOTAL(errorcode[[4,5,6]])

     PRINT,FORMAT='(A60,I9)'  ,'Evaluates image triplets : '                , n_eval
     PRINT,FORMAT='(A60,I9)'  ,'Matches found : '                           , nok
     PRINT,FORMAT='(A60,F9.2)','Percent  found : '                          , FLOAT(nok)/n_eval*100.
     PRINT
     PRINT,'Further Statistics:'
     PRINT
     PRINT,FORMAT='(A60,F9.2)','Error - Images entirely below threshold [%] : '      , FLOAT(nbelowthres  ) /n_eval*100.
     PRINT,FORMAT='(A60,F9.2)','Error - Flakes too small [%] : '                     , FLOAT(nareatoosmall) /n_eval*100.
     PRINT,FORMAT='(A60,F9.2)','Error - No match found in triplet [%] : '            , FLOAT(errorcode[ 7] )/n_eval*100.
     PRINT,FORMAT='(A60,F9.2)','Error - Fallspeed exceeds 10 m/s [%] : '             , FLOAT(errorcode[10] )/n_eval*100.
     PRINT,FORMAT='(A60,F9.2)','Error - Multiflake - Too many flakes in image [%] : ', FLOAT(errorcode[ 9] )/n_eval*100.
     PRINT,FORMAT='(A60,F9.2)','Error - Multiflake - could not determine best [%] : ', FLOAT(errorcode[ 8] )/n_eval*100.
     PRINT,FORMAT='(A60,F9.2)','OK    - Multiflake - picked best in focus [%] : '    , FLOAT(nmulti)        /n_eval*100.
     PRINT,FORMAT='(A60,F9.2)','OK    - Single flake [%] : '                         , FLOAT(nok-nmulti)    /n_eval*100.


END
