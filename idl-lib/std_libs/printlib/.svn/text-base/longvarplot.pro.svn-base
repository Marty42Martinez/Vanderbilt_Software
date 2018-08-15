pro longvarplot, date


filename = strcompress('d:\brian\data\'+string(date)+'data\coldloadcalib\longvars.var')
restore, filename


time = lindgen(N_ELEMENTS(tp0long))/20.
set_plot, 'printer'
device, /landscape
!p.multi = [0,1,2]
plot,time, tp0long, title = filename + '    tp0long', ytitle = 'volts', xtitle = 'time [sec]'
plot,time, tp1long, title = filename + '    tp1long', ytitle = 'volts', xtitle = 'time [sec]'

!p.multi = [0,1,3]
plot,time, j1long, title = filename + '    j1long', ytitle = 'volts', xtitle = 'time [sec]'
plot,time, j2long, title = filename + '    j2long', ytitle = 'volts', xtitle = 'time [sec]'
plot,time, j3long, title = filename + '    j3long', ytitle = 'volts', xtitle = 'time [sec]'
device,/close
end