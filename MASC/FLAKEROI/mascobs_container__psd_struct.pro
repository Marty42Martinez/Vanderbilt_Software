FUNCTION mascobs_container::PSD_struct, binsize=binsize,dmax=dmax
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%Created by:Marty: August 24, 2015%%%%%;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%%%%%%%%%Description%%%%%%%%%%%%%%%%;
;returns structure that contains tools to
;plot a PSD
  KEYWORD_DEFAULT, binsize, 0.005 ;centimeters

  n      =  self.count()
  IF KEYWORD_SET(dmax) THEN BEGIN
     e = self->evaluate('ellipse')
     s = self->evaluate('scale')
     dle = e.major*s   ; comes out in cm....
  ENDIF ELSE BEGIN
      DLE    =  self -> evaluate('D_LE')
  ENDELSE
  dle = MAX(dle,dim=1)
  
  nbins = MAX(dle)/binsize+1
  
  for i = 0,n-1 do begin
    iso_dle[i]   = dle[ind[i],i]
    major[i]     = ell[ind[i],i].major*s[ind[i],i]
  endfor
  
  h     = histogram(major, binsize=binsize,min=0)
  n_el  = n_elements(h)
  ;12/08/2015;
  ;changed number from 100 - 560;
  ;done because want to include major axis measurements;
  PSD = {$
    xpl     : (binsize/2.)+findgen(nbins)*binsize               , $
	hist    : histogram(DLE, binsize=binsize, min=0,nbins=nbins), $
	binsize : binsize       $
  }
    
  return, PSD

end
