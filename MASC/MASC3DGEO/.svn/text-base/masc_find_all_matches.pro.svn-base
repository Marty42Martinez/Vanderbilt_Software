FUNCTION readandcut,file,threshold,xedge,cnt,yrange=yrange

      img0 = READ_PNG(file)   
      s    = SIZE(img0)
      
      ; if the sun is shining this area is rouhly lit by the sun...
      ; outside of black rim...
      KEYWORD_DEFAULT,yrange,[350,1520]
;      KEYWORD_DEFAULT,yrange,[630,1350]
      
      ; make the edges black....
      img0[0              : s[1]*xedge,*]=0
      img0[s[1]*(1-xedge) :          *,*]=0
      img0[*, 0:yrange[0]]               =0
      img0[*, yrange[1]:*]               =0
     
      img0 = img0 *(img0 GE threshold)
      
      ind  = WHERE(img0 GE threshold,cnt) 
      
      RETURN,img0
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getregions,image,threshold,labim,edge,minarea=minarea

       KEYWORD_DEFAULT,minarea,10

       labim = LABEL_REGION(image GT threshold)
       s     = SIZE(labim)
       n     = MAX(labim)
       
       lab = { $
               sx    : s[1],$
               sy    : s[2],$
               nlab  : 0L, $
               xm    : 0L, $
               ym    : 0L, $
               xr    : [0,0], $
               yr    : [0,0], $
               br    : 0L, $
               nn    : 0L  $
              }
       out = LIST()      
        
       FOR i=1,n DO BEGIN
       
           ind   = WHERE(labim EQ i,cnt)
       
           IF cnt  LT minarea THEN CONTINUE
           
           xx     = ind MOD s[1]
           yy     = ind  /  s[1]
           
           IF MIN(xx) LT s[1]* EDGE     THEN CONTINUE
           IF MIN(yy) LT s[2]* EDGE     THEN CONTINUE
           IF MAX(xx) GT s[1]* (1-EDGE) THEN CONTINUE
           IF MAX(yy) GT s[2]* (1-EDGE) THEN CONTINUE
           
           lab.nlab = i
           lab.nn   = cnt
           lab.xm   = (MAX(FLOAT(xx))+MIN(FLOAT(xx)))/2.
           lab.ym   = (MAX(FLOAT(yy))+MIN(FLOAT(yy)))/2.
           lab.xr   = MINMAX(xx)
           lab.yr   = MINMAX(yy)
           lab.br   = MEAN(FLOAT(image[ind]))

           out.add,lab
       ENDFOR
       
       IF out.count() EQ 0 THEN RETURN,[-1]
       
       out=out.toarray()       

       RETURN,out
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION find_match,datstruct,out,threshold=threshold,edge=edge,img0,img1,img2,_EXTRA=_EXTRA

      KEYWORD_DEFAULT,threshold,6
      KEYWORD_DEFAULT,edge     ,0.12
      
      IF datstruct.fallspeed GT 10.0 THEN RETURN,-10
      IF datstruct.imgfile[0] EQ '' THEN RETURN,-1
      IF datstruct.imgfile[1] EQ '' THEN RETURN,-1
      IF datstruct.imgfile[2] EQ '' THEN RETURN,-1

      ; see if ongs exist.....
      img0 = readandcut(datstruct.dir+datstruct.imgfile[0],threshold,edge,cnt,_EXTRA=_EXTRA)  
      IF cnt EQ 0 THEN RETURN,-1
        
      img1 = readandcut(datstruct.dir+datstruct.imgfile[1],threshold,edge,cnt,_EXTRA=_EXTRA)    
      IF cnt EQ 0 THEN RETURN,-2

      img2 = readandcut(datstruct.dir+datstruct.imgfile[2],threshold,edge,cnt,_EXTRA=_EXTRA)       
      IF cnt EQ 0 THEN RETURN,-3
      
      reg0 = getregions(img0,threshold,labim0,edge)
      IF SIZE(reg0,/TYPE) EQ 2 THEN RETURN,-4     

      reg1 = getregions(img1,threshold,labim1,edge)
      IF SIZE(reg1,/TYPE) EQ 2 THEN RETURN,-5     

      reg2 = getregions(img2,threshold,labim2,edge)
      IF SIZE(reg2,/TYPE) EQ 2 THEN RETURN,-6     
  
      nreg0 = N_ELEMENTS(reg0) 
      nreg1 = N_ELEMENTS(reg1) 
      nreg2 = N_ELEMENTS(reg2) 
      
      IF nreg0*nreg1*nreg2 GT 30.0^3 THEN RETURN,-9
  
      l = LIST()
      FOR i=0,nreg0-1 DO BEGIN
         FOR j=0,nreg1-1 DO BEGIN
            FOR k=0,nreg2-1 DO BEGIN            
               
               IF reg0[i].nn LT 0.2*reg1[j].nn THEN CONTINUE
               IF reg0[i].nn LT 0.2*reg2[k].nn THEN CONTINUE
               IF reg1[j].nn LT 0.2*reg2[k].nn THEN CONTINUE
               IF reg0[i].nn GT 5.0*reg1[j].nn THEN CONTINUE
               IF reg0[i].nn GT 5.0*reg2[k].nn THEN CONTINUE
               IF reg1[j].nn GT 5.0*reg2[k].nn THEN CONTINUE
               
               xyz0 = masc_hv2xyz([reg1[j].xm,reg1[j].ym],[reg0[i].xm,reg0[i].ym],1,0,_EXTRA=_EXTRA)
               xyz1 = masc_hv2xyz([reg1[j].xm,reg1[j].ym],[reg2[k].xm,reg2[k].ym],1,2,_EXTRA=_EXTRA) 
               xyz2 = masc_hv2xyz([reg0[i].xm,reg0[i].ym],[reg2[k].xm,reg2[k].ym],0,2,_EXTRA=_EXTRA) 
               IF NORM(xyz0-xyz1) LT 1. AND NORM(xyz0-xyz2) LT 1. AND NORM(xyz1-xyz1) LT 1. THEN BEGIN
                  xyz  =  MEAN([[xyz0],[xyz1],[xyz2]],dim=2)
                  dum0 = masc_xyz2hv(0,xyz[0],xyz[1],xyz[2],magni=m0,infocus=if0,_EXTRA=_EXTRA)
                  dum1 = masc_xyz2hv(1,xyz[0],xyz[1],xyz[2],magni=m1,infocus=if1,_EXTRA=_EXTRA)
                  dum2 = masc_xyz2hv(2,xyz[0],xyz[1],xyz[2],magni=m2,infocus=if2,_EXTRA=_EXTRA)
                  xn   = NORM(xyz)
                  l.add,{i:i,j:j,k:k,xyz :xyz,xn:xn,m0:m0,m1:m1,m2:m2,if0:if0,if1:if1,if2:if2}
               ENDIF 
            ENDFOR
         ENDFOR   
      ENDFOR
      IF l.count() EQ 0 THEN RETURN,-7
      
      a = l.toarray()
      ind=WHERE(a.xn EQ MIN(a.xn))
      
      
      IF N_ELEMENTS(ind) GT 1 THEN RETURN,-8
      
      out  = { $
               reg0    : reg0[a[ind[0]].i], $
               reg1    : reg1[a[ind[0]].j], $
               reg2    : reg2[a[ind[0]].k], $
               xyz     : a[ind[0]].xyz,     $
               m0      : a[ind[0]].m0,     $
               m1      : a[ind[0]].m1,     $
               m2      : a[ind[0]].m2,     $
               if0     : a[ind[0]].if0,     $
               if1     : a[ind[0]].if1,     $
               if2     : a[ind[0]].if2,     $
               ismulti : l.count()          $
              }  
        
      
      RETURN, 0
      
END 


FUNCTION masc_find_all_matches,_EXTRA=_EXTRA
     
     q         = read_masc_dir(_EXTRA=_EXTRA)
     n_eval    = N_ELEMENTS(q)
     errorcode = FLTARR(11)
     l         = LIST()

     FOR i=0,n_eval-1 DO BEGIN
        r=find_match(q[i],match,_EXTRA=_EXTRA,img0,img1,img2)
        stop
        IF r EQ 0 THEN  l.add,match
        errorcode[ABS(r[0])] =  errorcode[ABS(r[0])] + 1
        print,i+1,' of ',N_ELEMENTS(q),' error code : ',r[0]
    ENDFOR

     nok           = l.count()
     a             = l.toarray()
     dum           = WHERE(a.ismulti EQ 1,nmulti)
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

    

RETURN,l

END
