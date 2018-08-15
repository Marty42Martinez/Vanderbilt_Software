PRO mascobs_container::quicklook,waittime=waittime,rescale=rescale,step=step

  KEYWORD_DEFAULT,waittime,0.1
  KEYWORD_DEFAULT,rescale ,  1

  loadct,0

  FOR i=0,self.count()-1 DO BEGIN
  
     o = self->getelem(i)
     c = o->canvas(/hist)
     
     s  = SIZE(c)
     TV,REBIN(c,s[1]*rescale,s[2]*rescale,/SAMPLE)
    
     IF KEYWORD_SET(step) THEN BEGIN
        
     ENDIF ELSE BEGIN
       WAIt,waittime
     ENDELSE
     ERASE
     
  ENDFOR

END
