
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; LIFETIME ROUTINES INIT, CLEANUP, DEFINE, and GET_TAG
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION hist::init,ndims,mini_=mini_,maxi_=maxi_,bin_=bin_,name=name,unit=unit

   IF N_ELEMENTS(mini_) EQ 1 THEN mini = [mini_] ELSE mini=mini_
   IF N_ELEMENTS(maxi_) EQ 1 THEN maxi = [maxi_] ELSE maxi=maxi_
   IF N_ELEMENTS(bin_ ) EQ 1 THEN bin  = [bin_ ] ELSE bin =bin_

   IF SIZE(mini,/DIM) NE ndims THEN STOP
   IF SIZE(maxi,/DIM) NE ndims THEN STOP
   IF SIZE(bin ,/DIM) NE ndims THEN STOP
   
   self.ndims=ndims
   self.mini =PTR_NEW(FLOAT(mini))
   self.maxi =PTR_NEW(FLOAT(maxi))
   self.bin  =PTR_NEW(FLOAT(bin) )
   self.name =PTR_NEW(STRARR(ndims ))
   self.unit =PTR_NEW(STRARR(ndims ))
   IF KEYWORD_SET(unit) THEN *self.unit = unit
   IF KEYWORD_SET(name) THEN *self.name = name
  
   CASE ndims OF 
      1    : BEGIN
               self.n   =PTR_NEW(FLTARR(bin[0]))
               self.mean=PTR_NEW(FLTARR(bin[0]))
               self.stdv=PTR_NEW(FLTARR(bin[0]))
             END
      2    : BEGIN
              self.n   =PTR_NEW(FLTARR(bin[0],bin[1]))
              self.mean=PTR_NEW(FLTARR(bin[0],bin[1]))
              self.stdv=PTR_NEW(FLTARR(bin[0],bin[1]))
             END
      3    : BEGIN
               self.n   =PTR_NEW(FLTARR(bin[0],bin[1],bin[2]))
               self.mean=PTR_NEW(FLTARR(bin[0],bin[1],bin[2]))
               self.stdv=PTR_NEW(FLTARR(bin[0],bin[1],bin[2]))
             END
      4    : BEGIN
               self.n   =PTR_NEW(FLTARR(bin[0],bin[1],bin[2],bin[3]))
               self.mean=PTR_NEW(FLTARR(bin[0],bin[1],bin[2],bin[3]))
               self.stdv=PTR_NEW(FLTARR(bin[0],bin[1],bin[2],bin[3]))
             END
      ELSE : STOP
   ENDCASE
         
   RETURN,1
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO hist::set_names,name
  *self.name=names
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO hist::set_units,nams
  *self.unit=units
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION hist::axis,idim

    IF idim LT 0 OR idim GT self.ndims-1 THEN STOP

    axis = FINDGEN((*self.bin)[idim]) / (*self.bin)[idim] * $
           ((*self.maxi)[idim]-(*self.mini)[idim])        + $
           (*self.mini)[idim]                             + $
           ((*self.maxi)[idim]-(*self.mini)[idim]) /(*self.bin)[idim] / 2.0
        
   RETURN,axis
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION hist::palette,ipal=ipal
   KEYWORD_DEFAULT,ipal,39
   LOADCT,ipal
   TVLCT,r,g,b,/GET
   r=CONGRID(r[30:240],256)
   g=CONGRID(g[30:240],256)
   b=CONGRID(b[30:240],256)
   RETURN,[[r],[g],[b]]
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO hist::cgcontour,mean=mean,stdv=stdv,ipal=ipal,palette=palette,XTITLE=XTITLE,YTITLE=YTITLE,_EXTRA=_EXTRA,nmin=nmin

  IF self.ndims NE 2 THEN RETURN

  KEYWORD_DEFAULT,ipal,39
  KEYWORD_DEFAULT, palette, self->palette(ipal=ipal)
  KEYWORD_DEFAULT,XTITLE,(*self.name)[0]+' '+(*self.unit)[0]
  KEYWORD_DEFAULT,YTITLE,(*self.name)[1]+' '+(*self.unit)[1]
  KEYWORD_DEFAULT,nmin,1
  
  which = 'n'
  IF KEYWORD_SET(stdv) THEN which='stdv'
  IF KEYWORD_SET(mean) THEN which='mean'

  xax = self->axis(0)
  yax = self->axis(1)
  
  data=self->get_tag(which)
  nnn =self->get_tag('n')
  ind= WHERE(nnn LT nmin,cnt)
  IF cnt NE 0 THEN DAta[ind] = -999.
  
  cgcontour,data,xax,yax,palette=palette,XTITLE=XTITLE,YTITLE=YTITLE,_EXTRA=_EXTRA,missing=-999.
  
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO hist::cleanup

   PTR_FREE,self.mini  
   PTR_FREE,self.maxi 
   PTR_FREE,self.bin 
   PTR_FREE,self.mean 
   PTR_FREE,self.stdv 
   PTR_FREE,self.name 
   PTR_FREE,self.unit 


END 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION hist::get_tag,tag
     ; this will return the data entries for the structure field

     valid_fields = TAG_NAMES({hist})
     i            = WHERE(STRUPCASE(tag) EQ STRUPCASE(valid_fields))
	 
	 IF i EQ -1 THEN BEGIN 
	     RETURN,[-1] 
     ENDIF ELSE BEGIN 
	 
	     IF SIZE(self.(i),/TYPE) EQ 10 THEN BEGIN
	        asd = *(self.(i))
	     ENDIF ELSE BEGIN 
	        asd = self.(i)
		 ENDELSE
		 		
     ENDELSE	
	 	 
	 RETURN,asd
	 
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO hist::fill,data_,clip=clip
     
     data=data_
     
     ; this will fill the histogram with data
     IF SIZE(data,/N_DIM) NE 2 THEN BEGIN
        PRINT,'Error: data has to be a 2D filed dimension [npoints,ndims]'
        PRINT,'RETURNING'
        RETURN
     ENDIF 
     s  = SIZE(data)
     IF s[2] NE self.ndims AND s[2] NE self.ndims+1  THEN BEGIN
        PRINT,'Error: data has to be a 2D filed dimension [npoints,ndims] or [npoints,ndims+1]'
        PRINT,'NDIMS is : ',self.ndims
       PRINT,'RETURNING'
       RETURN
     ENDIF
     Is_there_data_to_be_binned = s[2]- self.ndims ; if this is 1 then we have an additional datafield that needs to be binned
                                                   ; w/ mean and stdv
     
     ; make sure data is in right range.....
     IF NOT(KEYWORD_SET(clip)) THEN BEGIN
          FOR i=0,self.ndims-1 DO $
             data[*,i]=data[*,i] > (*Self.mini)[i] < (*self.maxi)[i]
     ENDIF ELSE BEGIN
          FOR i=0,self.ndims-1 DO BEGIN
             ind= WHERE(data[*,i] GE (*self.mini)[i] AND data[*,i] LE (*self.maxi)[i],cnt)
             IF cnt EQ 0 THEN BEGIN
                PRINT,'No data in clipping range.....'
                PRINT,'RETURNING'
                RETURN
             ENDIF
             data=data[ind,*]
          ENDFOR   
     ENDELSE

     ; get indices
     asd     = FLTARR(s[1])+1
     mini    = asd # *self.mini
     maxi    = asd # *self.maxi
     bin     = asd # *self.bin
     ind_xd  = ((data[*,0:self.ndims]-mini) / (maxi-mini)) < 0.9999
     ind_xd  = LONG(ind_xd * bin)
     ind     = ind_xd[*,self.ndims-1]
     
     FOR i=self.ndims-2,0,-1 DO BEGIN
        ind = ind * (*self.bin)[i] + ind_xd[*,i]
     ENDFOR
	 dum=HISTOGRAM(ind,min=0L,max=N_ELEMENTS(*self.n)-1,bin=1,reverse_indices=R)	 

     FOR i = 0L,N_ELEMENTS(*self.n)-1 DO BEGIN
       IF r[i] EQ r[i+1] THEN CONTINUE
       
       (*self.n)[i]    = r[i+1]-r[i]

       IF Is_there_data_to_be_binned EQ 1 THEN BEGIN
          (*self.mean)[i] = MEAN  (data[r[r[i]:r[i+1]-1],self.ndims])
          IF (*self.n)[i] GT 1 THEN $
            (*self.stdv)[i] = STDDEV(data[r[r[i]:r[i+1]-1],self.ndims])
      ENDIF

     ENDFOR
	 
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PRO hist::add_fields,n1,m1,s1,n2,m2,s2,nt,mt,st

  nt =  n1 + n2
  i  =  WHERE(nt EQ 0,cnt)
  mt =  (m1*n1 + m2*n2)/ (nt>1)
  IF cnt NE 0 THEN nt[i] = 0.
  
  st = SQRT(((n1-1)*s1^2.0+(n2-1)*s2^2+n1*m1^2.+n2*m2^2.-nt*mt^2.0)/((nt-1)>1))
  i  =  WHERE(nt LT 2,cnt)
  IF cnt NE 0 THEN st[i] = 0.
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO hist::overwrite_Field,data,mean=mean,stdv=stdv
  
  which = 'n'
  IF KEYWORD_SET(stdv) THEN which='stdv'
  IF KEYWORD_SET(mean) THEN which='mean'
  
  q=TAG_NAMES({hist})
  i=WHERE(STRUPCASE(which) EQ STRUPCASE(q))
  
  *(self.(i[0])) = data
  
END  
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION hist::merge,h2
    
   fail=0
   IF self->get_Tag('ndims') NE h2->get_Tag('ndims')             THEN Fail=1
   IF MAX(ABS(self->get_Tag('mini') - h2->get_Tag('mini'))) NE 0 THEN Fail=1
   IF MAX(ABS(self->get_Tag('maxi') - h2->get_Tag('maxi'))) NE 0 THEN Fail=1
   IF MAX(ABS(self->get_Tag('bin' ) - h2->get_Tag('bin' ))) NE 0 THEN Fail=1

   IF fail EQ 1 THEN BEGIN
     PRINT,'histograms dimensions are different'
     PRINT,'RETURNING'
     RETURN,-1
   ENDIF
   n1  = self->get_tag('n')
   m1  = self->get_tag('mean')
   s1  = self->get_tag('stdv')
   n2  =   h2->get_tag('n')
   m2  =   h2->get_tag('mean')
   s2  =   h2->get_tag('stdv')
   
   self->add_fields,n1,m1,s1,n2,m2,s2,nt,mt,st
   
   new = OBJ_NEW('hist',self.ndims,mini=*self.mini,maxi=*self.maxi,bin=*self.bin,name=*self.name,unit=*self.unit)
   new->overwrite_field,nt
   new->overwrite_field,mt,/MEAN
   new->overwrite_field,st,/STDV
   
   RETURN,new

END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION hist::marginal,dims_=dims_
  
  dims=dims_
  IF N_ELEMENTS(dims) GT 1 THEN dims=dims[REVERSE(sort(dims))] ELSE dims=[dims]
  n = self->get_Tag('N')
  m = self->get_Tag('MEAN')
  s = self->get_Tag('STDV')
  
  sx = SIZE(m)
  
  FOR idim=0,N_ELEMENTS(dims)-1 DO BEGIN

     nn = TOTAL(n,dims[idim]+1)

     mm = TOTAL((m*n),dims[idim]+1)
     mm = mm / (nn>1)
     ind= WHERE(nn EQ 0, CNT)
     IF cnt NE 0 THEN mm[ind] = 0.
     
     ss = (TOTAL((n-1)*s*s,dims[idim]+1)+TOTAL((m*m*(n-1)),dims[idim]+1))- nn*mm*mm
     Ss = SQRT(ss/((nn-1)>1))
     ind= WHERE(nn Lt 2, CNT)
     IF cnt NE 0 THEN ss[ind] = 0.
     
     
     n = nn
     m = mm
     s = ss
  ENDFOR 
  
  ; find the remaining dimensions to write things out into a new histogram...
  iok=FINDGEN(self.ndims)
  FOR i=0,N_ELEMENTS(dims) -1 DO BEGIN
    ind=WHERE(dims[i] EQ iok,comple=c)
    iok=iok[c]
  ENDFOR
  
  mini = (*Self.mini)[iok]
  maxi = (*self.maxi)[iok]
  bin  = (*self.bin )[iok]
  name = (*self.name)[iok]
  unit = (*self.unit)[iok]
  new = OBJ_NEW('hist',N_ELEMENTS(iok),mini=mini,maxi=maxi,bin=bin,name=name,unit=unit)
  new->overwrite_field,n
  new->overwrite_field,m,/MEAN
  new->overwrite_field,s,/STDV
   
  RETURN,new
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION hist::conditional,dims_=dims_,values=values
  
  dims=dims_
  IF N_ELEMENTS(dims) GT 1 THEN dims=dims[REVERSE(sort(dims))] ELSE dims=[dims]
  n = self->get_Tag('N')
  m = self->get_Tag('MEAN')
  s = self->get_Tag('STDV')
  
  ind1d=LINDGEN(N_ELEMENTS(n))
  indxd=ARRAY_INDICES(n,ind1d)
  
  ; now cut out the conditional PDF at the right place
  FOR idim=0,N_ELEMENTS(dims)-1 DO BEGIN
    ix = (Values[idim]-(*self.mini)[dims[idim]]) / ((*self.maxi)[dims[idim]]-(*self.mini)[dims[idim]] ) * (*self.bin)[dims[idim]]
    iok= WHERE(indxd[dims[idim],*] EQ ix,cnt)
    IF cnt EQ 0 THEN STOP
    ind1d=ind1d[  iok]
    indxd=indxd[*,iok]
  ENDFOR
  
  n=n[ind1d]
  m=m[ind1d]
  s=s[ind1d]
 
  iok=FINDGEN(self.ndims)
  FOR i=0,N_ELEMENTS(dims) -1 DO BEGIN
    ind=WHERE(dims[i] EQ iok,comple=c)
    iok=iok[c]
  ENDFOR
  mini = (*Self.mini)[iok]
  maxi = (*self.maxi)[iok]
  bin  = (*self.bin )[iok]
  name = (*self.name)[iok]
  unit = (*self.unit)[iok]
  new = OBJ_NEW('hist',N_ELEMENTS(iok),mini=mini,maxi=maxi,bin=bin,name=name,unit=unit)
  new->overwrite_field,n
  new->overwrite_field,m,/MEAN
  new->overwrite_field,s,/STDV
   
  RETURN,new
  
END
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO hist__define

  structure  = {hist, $
				ndims  : 0L,  $
				mini     : PTR_NEW(), $
				maxi     : PTR_NEW(), $
				bin      : PTR_NEW(), $
				name     : PTR_NEW(), $
				unit     : PTR_NEW(), $
				n        : PTR_NEW(), $
				mean     : PTR_NEW(), $
				stdv     : PTR_NEW()  $
			   } 

END
   
