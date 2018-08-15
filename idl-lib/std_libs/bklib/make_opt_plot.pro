pro make_opt_plot

;short,med,long, integrations follow
;filein = 'd:\brian\data\polatron_2001\TueApr101859352001ss2nzdata.var';wpinv = 4e-13,tobs = 1.8e6sec
;filein = 'd:\brian\data\polatron_2001\TueApr101919462001ss2nzdata.var';wpinv = 8e-14,tobs = 1e7
;filein = 'd:\brian\data\polatron_2001\TueApr101912202001ss2nzdata.var';, wpinv =4.1e-14,tobs = 2e7

!p.multi = [0,3,1]

three_weeks_filein = 'd:\brian\data\polatron_2001\TueMay081736482001ss2nzdata.var';, wpinv =4.1e-14,tobs = 2e7
restore,three_weeks_filein


fileout = 'd:\brian\data\polatron_2001\optimization.ps';strsplit(filein,'.',/extract)
;fileout = fileout[0]+'.ps'

 startthet = 0
set_plot,'ps'
device,file = fileout
plot, thet[0:*]/!dtor,(sampvarqsig2nz+sampvarusig2nz),/xl,$
xstyle=4, xtitle = 'theta', $
ytitle = 'Signal-to-Noise Ratio',charsize = 2.,$
linestyle = 1 , xr = [.01,10.],yr = [0,10], xmargin = [5,0]
 ;oplot, thet[0:*]/!dtor,(sk2qsig2nz[0:*]+sk2usig2nz[0:*]), linestyle = 4;,/xl,xstyle=4, xtitle = 'theta', ytitle = 'Anticipated Signal to Noise Ratio',linestyle = 1 ;, xr = [.09,30]
 oplot, thet[0:*]/!dtor,(sig2nznoquad[0:*]), linestyle = 0
 oplot, thet[0:*]/!dtor,(sk1qsig2nz[0:*]+sk1usig2nz[0:*]), linestyle = 2
 axis, xaxis = 0,xtitle = 'Ring Opening Angle !7H!6 ',$
 xticks = 3,charsize = 2.
 axis, xaxis = 1, xtitle = 'Number of Pixels', $
 charsize = 2.,xrange = [min(nvec),max(nvec)],$
 xtickv = nvec,xstyle=1;,xtickinterval = 1   , xticks=12
 xyouts ,0.15,8,'3 Weeks',charsize = 1.0
 ;vline,1.8
 ;legend,['Subtract Quad Stokes', 'No 1/f No Subtract Quad','With 1/f No Subtract Quad'],line = [0,1,2],/top,/right; pos = [ .1,1.1]
 ;xyouts,.1,.35,'Int Time='+string(round(t_obs/(24.*3600.)	))+'days'
;legend,['Subtract Quad Stokes', 'No 1/f No Subtract Quad','With 1/f No Subtract Quad'], line = [0,1,2], pos = [ .1,1.1]

twelve_weeks_filein = 'd:\brian\data\polatron_2001\TueMay081828332001ss2nzdata.var';, wpinv =4.1e-14,tobs = 2e7
restore,twelve_weeks_filein

plot, thet[0:*]/!dtor,(sampvarqsig2nz+sampvarusig2nz),$
/xl,xstyle=4, xtitle = 'Ring Opening Angle !7H!6 ',$
charsize = 2.,linestyle = 1 , $
xr = [.01,10.],yr = [0,10],xmargin = [0,0],$
ytickname = [" "," "," "," "," "," "],/ystyle,yminor=0;,$
;xtickname = [" ","0.10", "1.00"," "]

;oplot, thet[0:*]/!dtor,(sk2qsig2nz[0:*]+sk2usig2nz[0:*]), linestyle = 4;,/xl,xstyle=4, xtitle = 'theta', ytitle = 'Anticipated Signal to Noise Ratio',linestyle = 1 ;, xr = [.09,30]
oplot, thet[0:*]/!dtor,(sig2nznoquad[0:*]), linestyle = 0
oplot, thet[0:*]/!dtor,(sk1qsig2nz[0:*]+sk1usig2nz[0:*]), linestyle = 2
axis, xaxis = 0,xtitle = 'Ring Opening Angle !7H!6 ',xticks = 3, xtickname = [" ",'0.10','1.00' ," "],charsize = 2.
axis, xaxis = 1, xtitle = 'Number of Pixels', $
xrange = [min(nvec),max(nvec)],xtickv = nvec,$
charsize = 2.,xstyle=1;,xtickinterval = 1   , xticks=12
xyouts ,0.15,8,'12 Weeks',charsize = 1.0

;vline,1.8
;legend,['Subtract Quad Stokes', 'No 1/f No Subtract Quad','With 1/f No Subtract Quad'],line = [0,1,2],/top,/right; pos = [ .1,1.1]
;xyouts,.1,.35,'Int Time='+string(round(t_obs/(24.*3600.)	))+'days'

twentyfour_weeks_filein = 'd:\brian\data\polatron_2001\TueMay081919172001ss2nzdata.var';, wpinv =4.1e-14,tobs = 2e7
restore,twentyfour_weeks_filein
plot, thet[0:*]/!dtor,(sampvarqsig2nz+sampvarusig2nz),$
/xl,xstyle=4,ystyle=4, linestyle = 1 , charsize = 2.,$
xr = [.01,10.],xmargin = [0,0],$
ytickname = [" "," "," "," "," "," "]

 ;oplot, thet[0:*]/!dtor,(sk2qsig2nz[0:*]+sk2usig2nz[0:*]), linestyle = 4;,/xl,xstyle=4, xtitle = 'theta', ytitle = 'Anticipated Signal to Noise Ratio',linestyle = 1 ;, xr = [.09,30]
 oplot, thet[0:*]/!dtor,(sig2nznoquad[0:*]), linestyle = 0
 oplot, thet[0:*]/!dtor,(sk1qsig2nz[0:*]+sk1usig2nz[0:*]), linestyle = 2
 axis, xaxis = 0,xtitle = 'Ring Opening Angle !7H!6 ',xticks = 3,charsize = 2.
 axis, xaxis = 1, xtitle = 'Number of Pixels',charsize = 2., xrange = [min(nvec),max(nvec)],xtickv = nvec,xstyle=1;,xtickinterval = 1   , xticks=12
 axis, yaxis = 1, charsize = 2.,yrange = [0,10],/ystyle,yticks=5,yminor = 4
 axis, yaxis = 0,ytickname = [" "," "," "," "," "," "];, charsize = 2.,yrange = [0,10],/ystyle,yticks=5,yminor = 4
 vline,1.8
 ;legend,['Subtract Quad Stokes', 'No 1/f No Subtract Quad','With 1/f No Subtract Quad'],line = [0,1,2],/top,/right; pos = [ .1,1.1]
 ;xyouts,.1,.35,'Int Time='+string(round(t_obs/(24.*3600.)	))+'days'
xyouts ,0.02,8,'24 Weeks',charsize = 1.0

device,/close
set_plot,'win'

end