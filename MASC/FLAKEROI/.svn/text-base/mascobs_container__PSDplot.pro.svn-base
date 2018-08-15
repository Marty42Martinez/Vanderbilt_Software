FUNCTION mascobs_container::PSDplot, titlename=titlename

;CALL METHOD;
;pl = o -> PSDplot(titlename='some title')
  
  KEYWORD_DEFAULT,titlename,'Snowflake Particle Size Distribution'

  ell    =  self -> evaluate('ellipse')
  s      =  self -> evaluate('scale')
  n      =  self.count()
  
  
  ell_0  =  reform(ell[0,*])
  ell_1  =  reform(ell[1,*])
  ell_2  =  reform(ell[2,*])


  rmax_arr = fltarr(n)
  ;%%%CAN DO THIS WITHOUT A FOR LOOP
  ;rmax_arr = max(ell.major, dim=1)
  for i = 0,n-1 do begin
    rmax_arr[i] = max([ell_0[i].major,ell_1[i].major,ell_2[i].major])*s[i]
  endfor
  
  DLE_rmax = (6*.022*(rmax_arr^2.1)/!pi)^(1./3.)*1e3
  all_hist = histogram(DLE_rmax, binsize=200, min=0)
  ;%%%%NEEDS TO BE CHANGED!%%%%%%%
  ;xpl needs to be in centimeters and not microns...;
  xpl = 100+findgen(93)*200
  
  all_log = alog(all_hist > 1.0)
  
  h = plot(xpl,all_hist>1.0, yrange=[1,5000],xrange=[1,3000], ylog=1,color='blue', linestyle=0,symbol=3,sym_size=11,/ystyle,$
  xtitle='Particle Size (microns)',ytitle='$Log(N_D)$',title=titlename,name='MASC Measurements',font_size=20,thick=2.5)

end

;MASC_2014.12.17_06Z.sav
