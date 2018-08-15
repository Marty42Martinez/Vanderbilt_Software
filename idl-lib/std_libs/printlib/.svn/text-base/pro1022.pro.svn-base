PRO pro1022

restore, 'c:\chris\data\synch\synch1014.var'

; Initialize Stuff
bins = 72
!p.multi= [0,1,2]
loadct, 12
!x.style=1
!y.style=1
set_plot, 'printer', /copy
device, xoff=2,yoff=2, xsize=15, ysize=24, set_font='Times Bold', /tt_font
angle = (360./bins)*findgen(bins)



plot, angle, tp0av1014, title='TP0 synchronous signal, staring at TCL, T=22.2 K', $
					    xtitle='angle [deg]', ytitle = 'signal [V]', xrange=[0,360]

plot, angle, tp1av1014, title='TP1 synchronous signal, staring at TCL, T= 22.2 K', $
                    	  xtitle='angle [deg]', ytitle = 'signal [V]',xrange=[0,360]
device, /close_doc
plot, angle, j1iav1014, title='j1i synchronous signal, staring at TCL, T= 22.2 K', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',xrange=[0,360]

plot, angle, j2iav1014, title='j2i synchronous signal, staring at TCL, T= 22.2 K', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',xrange=[0,360]
device, /close_doc
plot, angle, j3iav1014, title='j3i synchronous signal, staring at TCL, T= 22.2 K', $
					xtitle='angle [deg]', ytitle = 'signal [V]',xrange=[0,360]

plot, angle, j1oav1014, title='j1o synchronous signal, staring at TCL, T= 22.2 K', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',xrange=[0,360]
device, /close_doc
plot, angle, j2oav1014, title='j2o synchronous signal, staring at TCL, T= 22.2 K', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',xrange=[0,360]

plot, angle, j3oav1014, title='j3o synchronous signal, staring at TCL, T= 22.2 K', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',xrange=[0,360]

device, /close_doc

end