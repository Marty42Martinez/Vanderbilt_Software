FUNCTION mascobs_container::PrecipHist, titlename=titlename
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%Created by:Marty: August 24, 2015%%%%%;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%%%%%%%%%Description%%%%%%%%%%%%%%%%;
;returns grapic with histogram of # captured
;particles vs Julian Day
;still in progress
;plan to make the axis labels look better
  KEYWORD_DEFAULT,titlename,'Frequency of snowflake capture over time'
  
  jul  = self -> Julday()
  ell  = self -> evaluate('ellipse')
  s    = self -> evaluate('scale')
  n    = self.count()

  ind = fltarr(n)
  for i = 0,n-1 do ind[i] = max(where(ell[*,i].major eq max(ell[*,i].major)))  
  major   =    fltarr(n) 
  for i = 0,n-1 do major[i]     = ell[ind[i],i].major*s[ind[i],i]*10


  ;j0  = jul[0] -1
  j0  = jul[0]
  dt  = jul[-1]-j0
  numh = fix(dt/(2*0.02083))
  check = numh/4
  
  n_weeks = 1+round(jul[-1]-j0)/7
  caldat, j0, m,d,y,hh,mm
  
  Jul_hist = histogram(jul, binsize=1./48, min=j0)
  nn       = n_elements(jul_hist)
  xpl = double(findgen(nn)*(1./48)) + j0
  ;stop
  ;Can make this plot prettier, but it works for now;
  
  if check le 9 then begin
    dummy = LABEL_DATE(DATE_FORMAT='%Y.%N.%D.%H')
    h = plot(xpl,jul_hist,XTICKFORMAT='LABEL_DATE', color='red',$
          title=titlename,xtitle = 'Calendar day (Y.M.D.H)',ytitle='Particle Count',$
          XRANGE=[j0,jul[-1]],/XSTYLE, $
          XTICKVALUES=[JULDAY(m,d,y,hh+findgen(check)*4)] $
          ) 
    return,h
  endif else begin
    check2 = numh/12
	dummy = LABEL_DATE(DATE_FORMAT='%Y.%N.%D.%H')
    h = plot(xpl,jul_hist,XTICKFORMAT='LABEL_DATE', color='red',$
          title=titlename,xtitle = 'Calendar day (Y.M.D.H)',ytitle='Particle Count',$
          XRANGE=[j0,jul[-1]],/XSTYLE, $
          XTICKVALUES=[JULDAY(m,d,y,hh+findgen(check2)*12)] $
          )
    return,h
  
  endelse
  ;%%% Jan 11, 2016 %%%
  ;Matching MMCR plots from icecaps data browswer
  day_iso  = (jul-j0-1)*24.
  Jul_hist = histogram(day_iso, binsize=0.5, min=0.,max = 24.0,reverse_indices=r)
  xpl      = findgen(48)*0.5
  ;stop

  
  
  ;h1        = plot(xpl,Jul_hist,color='red',ytitle='# Particles',$
  ;xrange=[0,24],/xstyle,xtickvalues=[5*(findgen(4)+1)],thick=3,font_size=24,$
  ;xshowtext=0,position=[.15,.52,.9,0.85],yminor=0)

  ;h2        = plot(day_iso,major,color='red',ytitle='Particle Size [mm]',xtitle='Time (hours,GMT)',$
  ;xrange=[0,24],/xstyle,yrange=[0,8],xtickvalues=[5*(findgen(4)+1)],font_size=24,$
  ;symbol='o',sym_filled=1,sym_size=0.4,linestyle=6,$
  ;position=[.15,.15,.9,0.48],/current)

end
