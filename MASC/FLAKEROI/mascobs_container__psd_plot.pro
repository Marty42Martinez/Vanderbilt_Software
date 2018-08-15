FUNCTION mascobs_container::PSD_plot, titlename=titlename, binsize=binsize,_EXTRA=_EXTRA,color=color,dmax=dmax
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%Created by:Marty: August 24, 2015%%%%%;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;%%%%%%%%%%%%%%%%Description%%%%%%%%%%%%%%%%;
;calls psd_struct and creates a nice graphic
;of the PSD

  KEYWORD_DEFAULT,titlename,'Snowflake Particle Size Distribution'
  KEYWORD_DEFAULT, binsize, 0.01 ;centimeters
  KEYWORD_DEFAULT, color, 'blue' ;centimeters

  PSD = self -> psd_struct(binsize=binsize,dmax=dmax)
  
  ;loghist = alog(PSD.hist > 1.0)
  ;stop
  
  h = plot(PSD.xpl,PSD.hist >1.0, yrange=[0.9,3000],xrange=[.001,0.5], ylog=1,color=color, linestyle=0,symbol=3,sym_size=11,/ystyle,$
  xtitle='Particle Size (D_LE: centimeters)',ytitle='$Log(N_D)$',title=titlename,name='MASC Measurements',font_size=20,thick=2.5,_EXTRA=_EXTRA)
  ;stop
  
  return, h



end
