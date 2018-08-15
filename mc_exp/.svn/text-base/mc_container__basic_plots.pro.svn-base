PRO mc_container::basic_plots

  m        =  self -> evaluate('mass_arr')
  n_agg    =  self -> evaluate('num_aggregate')
  n        =  self -> count()
  
  m1       =  m[4,*]*1e6  ;This is INITIAL MASS
  ;May have to enter a structure as a keyword/whatever
  m2       =  m[0,*]*1e6
  m_agg    =  m[3,*]*1e6
  m_rim    =  m[2,*]*1e6
  m_dgrow  =  m[1,*]*1e6
  m_diff   =  m2 - m1
  
  xpl      =  findgen(n)+1
  ;######################;
  ;######MASS PLOTS######;
  ;######################;
  ;IDEAS: diff grow vs init, rim vs init, m_agg vs init
  
  p1a   =  plot(xpl,m2, ylog=1)
  ;p1b   =  plot(xpl,m2,overplot=1)
  
  p1a.color     = 'forest green'
  p1a.xtitle    = 'Particle Number'
  p1a.ytitle    = 'Particle Mass [mg]'
  p1a.thick     = 3.0
  p1a.name      = 'Mass after "Fallthrough"'
  p1a.title     = 'Snowflake Particle Mass'
  p1a.font_size = 30
  
  
  ;p1b.color     = 'aqua'
  ;p1b.thick     = 2.0
  ;p1b.name      = 'Mass after "Fallthrough"'
  ;p1b.font_size = 30
  
  ;l1            = legend(target=[p1a],font_size=26,thick=3.0)
  
  
  p2   =  plot(xpl,m_diff, ylog=1)
  
  p2.color      = 'aqua'
  p2.symbol     = 3
  p2.sym_filled = 1
  p2.sym_size   = 12.
  p2.linestyle  = 6
  p2.xtitle     = 'Particle Number'
  p2.ytitle     = 'Mass Difference [mg]'
  p2.thick      = 3.0
  p2.name       = 'Mass Difference'
  p2.title      = 'Snowflake Particle Mass Change'
  p2.font_size  = 30
  ;l2            = legend(target=[p2],font_size=26,thick=3.0)
  
  p3   =  plot(m1,m_rim)
  
  p3.color      = 'purple'
  p3.symbol     = 3
  p3.sym_filled = 1
  p3.sym_size   = 12.
  p3.linestyle  = 6
  p3.xtitle     = 'Initial Mass [mg]'
  p3.ytitle     = 'Mass from Riming [mg]'
  p3.thick      = 3.0
  p3.name       = 'Riming vs Initial Mass'
  p3.title      = 'Relationship between Riming and Initial Mass'
  p3.font_size  = 30
  
  p4   =  plot(m1,m_dgrow)
  
  p4.color      = 'blue'
  p4.symbol     = 3
  p4.sym_filled = 1
  p4.sym_size   = 12.
  p4.linestyle  = 6
  p4.xtitle     = 'Initial Mass [mg]'
  p4.ytitle     = 'Mass from Diffusional Growth [mg]'
  p4.thick      = 3.0
  p4.name       = 'Diffusional Growth vs Initial Mass'
  p4.title      = 'Relationship between Diffusional Growth and Initial Mass'
  p4.font_size  = 30
  
;  p5   =  plot(m1,m_agg)
;  
;  p5.color      = 'crimson'
;  p5.symbol     = 3
;  p5.sym_filled = 1
;  p5.sym_size   = 12.
;  p5.linestyle  = 6
;  p5.xtitle     = 'Initial Mass [mg]'
;  p5.ytitle     = 'Mass from Aggregation [mg]'
;  p5.yrange     = [0.0,7.0]
;  p5.thick      = 3.0
;  p5.name       = 'Aggregation vs Initial Mass'
;  p5.title      = 'Relationship between Aggregation and Initial Mass'
;  p5.font_size  = 30
  
  p6   =  plot(xpl,n_agg)
  
  p6.color      = 'crimson'
  p6.xtitle     = 'Particle Number'
  p6.ytitle     = 'Number of Events'
  p6.thick      = 3.0
  p6.name       = 'Number of Aggregation Events'
  p6.title      = 'Number of Aggregation Events for each Particle'
  p6.font_size  = 30
;%%%For containers with low # aggregation events%%%
  p6.symbol     = 3
  p6.sym_filled = 1
  p6.sym_size   = 12.
  p6.linestyle  = 6



end
