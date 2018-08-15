PRO pro1_1020

; Loads up synch files 0909 through 0929 (about 8 of them).
; Plots up as much as possible of these files for all channels, prints them out.

restore, 'c:\chris\data\synch\synch0908.var'
restore, 'c:\chris\data\synch\synch0909.var'
restore, 'c:\chris\data\synch\synch0910.var'
restore, 'c:\chris\data\synch\synch0911.var'
restore, 'c:\chris\data\synch\synch0916.var'
restore, 'c:\chris\data\synch\synch0917.var'
restore, 'c:\chris\data\synch\synch0922.var'
restore, 'c:\chris\data\synch\synch0924.var'
restore, 'c:\chris\data\synch\synch0929.var'

; Initialize Stuff

!p.multi= [0,1,2]
loadct, 12
!x.style=1
!y.style=1
set_plot, printer
device, xoff=2,yoff=2, xsize=15, ysize=24, /color
angle = (360./144.)*findgen(144)

;-------------------------------------------------------------------------------
; TP0

plot, angle, tp0av0908, title='TP0 synchronous signal, staring at sky, 9 different days', $
					    xtitle='angle [deg]', ytitle = 'signal [V]', xrange=[0,360]
oplot, angle, tp0av0909, color = 30
oplot, angle, tp0av0910, color = 60
oplot, angle, tp0av0911, color = 90
oplot, angle, tp0av0916, color = 120
oplot, angle, tp0av0917, color = 150
oplot, angle, tp0av0922, color = 180
oplot, angle, tp0av0924, color = 210
oplot, angle, tp0av0929, color = 240

tp0av = fltarr(144)
tp0sd = fltarr(144)
for i=0,143 do begin
  tp0av[i] = mean([tp0av0908[i],tp0av0909[i],tp0av0910[i],tp0av0911[i],tp0av0916[i],tp0av0917[i], $
  				  tp0av0922[i],tp0av0924[i],tp0av0929[i]])
  tp0sd[i] = stddev([tp0av0908[i],tp0av0909[i],tp0av0910[i],tp0av0911[i],tp0av0916[i],tp0av0917[i], $
  				  tp0av0922[i],tp0av0924[i],tp0av0929[i]])
endfor

plot, angle, tp0av, psym=5, title = 'Average Synchronous signal of 9 days w/error bars', $
					xtitle='angle [deg]',ytitle='signal [V]', xrange=[0,360]
errplot, angle, tp0av+tp0sd/2., tp0av-tp0sd/2.

device, /close_doc

;-------------------------------------------------------------------------------
; tp1

plot, angle, tp1av0908, title='TP1 synchronous signal, staring at sky, 9 different days', $
	  xtitle='angle [deg]', ytitle = 'signal [V]',yrange=[-0.002,0.002],xrange=[0,360]
oplot, angle, tp1av0909, color = 30
oplot, angle, tp1av0910, color = 60
oplot, angle, tp1av0911, color = 90
oplot, angle, tp1av0916, color = 120
oplot, angle, tp1av0917, color = 150
oplot, angle, tp1av0922, color = 180
oplot, angle, tp1av0924, color = 210
oplot, angle, tp1av0929, color = 240

tp1av = fltarr(144)
tp1sd = fltarr(144)
for i=0,143 do begin
  tp1av[i] = mean([tp1av0908[i],tp1av0909[i],tp1av0910[i],tp1av0911[i],tp1av0916[i],tp1av0917[i], $
  				  tp1av0922[i],tp1av0924[i],tp1av0929[i]])
  tp1sd[i] = stddev([tp1av0908[i],tp1av0909[i],tp1av0910[i],tp1av0911[i],tp1av0916[i],tp1av0917[i], $
  				  tp1av0922[i],tp1av0924[i],tp1av0929[i]])
endfor

plot, angle, tp1av, psym=5, title = 'Average synchronous signal of 9 days w/error bars', $
					xtitle='angle [deg]',ytitle='signal [V]', xrange=[0,360],yrange=-[0.0005,0.0005]
errplot, angle, tp1av+tp1sd/2., tp1av-tp1sd/2.




;-------------------------------------------------------------------------------
; j1i

plot, angle, j1iav0908, title='j1i synchronous signal, staring at sky, 9 different days', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',yrange=[-0.005,0.005],xrange=[0,360]
oplot, angle, j1iav0909, color = 30
oplot, angle, j1iav0910, color = 60
oplot, angle, j1iav0911, color = 90
oplot, angle, j1iav0916, color = 120
oplot, angle, j1iav0917, color = 150
oplot, angle, j1iav0922, color = 180
oplot, angle, j1iav0924, color = 210
oplot, angle, j1iav0929, color = 240

j1iav = fltarr(144)
j1isd = fltarr(144)
for i=0,143 do begin
  j1iav[i] = mean([j1iav0908[i],j1iav0909[i],j1iav0910[i],j1iav0911[i],j1iav0916[i],j1iav0917[i], $
  				  j1iav0922[i],j1iav0924[i],j1iav0929[i]])
  j1isd[i] = stddev([j1iav0908[i],j1iav0909[i],j1iav0910[i],j1iav0911[i],j1iav0916[i],j1iav0917[i], $
  				  j1iav0922[i],j1iav0924[i],j1iav0929[i]])
endfor

plot, angle, j1iav, psym=5, title = 'Average Synchronous signal of 9 days w/error bars', $
					xtitle='angle [deg]',ytitle='signal [V]',yrange=[-.002,.002],xrange=[0,360]
errplot, angle, j1iav+j1isd/2., j1iav-j1isd/2.

;-------------------------------------------------------------------------------
; j2i

plot, angle, j2iav0908, title='j2i synchronous signal, staring at sky, 9 different days', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',yrange=[-0.0025,0.0025],xrange=[0,360]
oplot, angle, j2iav0909, color = 30
oplot, angle, j2iav0910, color = 60
oplot, angle, j2iav0911, color = 90
oplot, angle, j2iav0916, color = 120
oplot, angle, j2iav0917, color = 150
oplot, angle, j2iav0922, color = 180
oplot, angle, j2iav0924, color = 210
oplot, angle, j2iav0929, color = 240

j2iav = fltarr(144)
j2isd = fltarr(144)
for i=0,143 do begin
  j2iav[i] = mean([j2iav0908[i],j2iav0909[i],j2iav0910[i],j2iav0911[i],j2iav0916[i],j2iav0917[i], $
  				  j2iav0922[i],j2iav0924[i],j2iav0929[i]])
  j2isd[i] = stddev([j2iav0908[i],j2iav0909[i],j2iav0910[i],j2iav0911[i],j2iav0916[i],j2iav0917[i], $
  				  j2iav0922[i],j2iav0924[i],j2iav0929[i]])
endfor

plot, angle, j2iav, psym=5, title = 'Average Synchronous signal of 9 days w/error bars', $
					xtitle='angle [deg]',ytitle='signal [V]',yrange=[-.001,.001],xrange=[0,360]
errplot, angle, j2iav+j2isd/2., j2iav-j2isd/2.

;-------------------------------------------------------------------------------
; j3i

plot, angle, j3iav0908, title='j3i synchronous signal, staring at sky, 9 different days', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',yrange=[-0.01,0.015],xrange=[0,360]
oplot, angle, j3iav0909, color = 30
oplot, angle, j3iav0910, color = 60
oplot, angle, j3iav0911, color = 90
oplot, angle, j3iav0916, color = 120
oplot, angle, j3iav0917, color = 150
oplot, angle, j3iav0922, color = 180
oplot, angle, j3iav0924, color = 210
oplot, angle, j3iav0929, color = 240

j3iav = fltarr(144)
j3isd = fltarr(144)
for i=0,143 do begin
  j3iav[i] = mean([j3iav0908[i],j3iav0909[i],j3iav0910[i],j3iav0911[i],j3iav0916[i],j3iav0917[i], $
  				  j3iav0922[i],j3iav0924[i],j3iav0929[i]])
  j3isd[i] = stddev([j3iav0908[i],j3iav0909[i],j3iav0910[i],j3iav0911[i],j3iav0916[i],j3iav0917[i], $
  				  j3iav0922[i],j3iav0924[i],j3iav0929[i]])
endfor

plot, angle, j3iav, psym=5, title = 'Average Synchronous signal of 9 days w/error bars', $
					xtitle='angle [deg]',ytitle='signal [V]',yrange=[-.005,.008],xrange=[0,360]
errplot, angle, j3iav+j3isd/2., j3iav-j3isd/2.


;-------------------------------------------------------------------------------
; j1o

plot, angle, j1oav0908, title='j1o synchronous signal, staring at sky, 6 different days', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',yrange=[-0.002,0.002],xrange=[0,360]
oplot, angle, j1oav0909, color = 30
oplot, angle, j1oav0910, color = 60
oplot, angle, j1oav0911, color = 90
oplot, angle, j1oav0916, color = 120
oplot, angle, j1oav0917, color = 150

j1oav = fltarr(144)
j1osd = fltarr(144)
for i=0,143 do begin
  j1oav[i] = mean([j1oav0908[i],j1oav0909[i],j1oav0910[i],j1oav0911[i],j1oav0916[i],j1oav0917[i]])
  j1osd[i] = stddev([j1oav0908[i],j1oav0909[i],j1oav0910[i],j1oav0911[i],j1oav0916[i],j1oav0917[i]])
endfor

plot, angle, j1oav, psym=5, title = 'Average Synchronous signal of 6 days w/error bars', $
					xtitle='angle [deg]',ytitle='signal [V]',yrange=[-.001,.001],xrange=[0,360]
errplot, angle, j1oav+j1osd/2., j1oav-j1osd/2.

;-------------------------------------------------------------------------------
; j2o

plot, angle, j2oav0908, title='j2o synchronous signal, staring at sky, 6 different days', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',yrange=[-0.002,0.002],xrange=[0,360]
oplot, angle, j2oav0909, color = 30
oplot, angle, j2oav0910, color = 60
oplot, angle, j2oav0911, color = 90
oplot, angle, j2oav0916, color = 120
oplot, angle, j2oav0917, color = 150

j2oav = fltarr(144)
j2osd = fltarr(144)
for i=0,143 do begin
  j2oav[i] = mean([j2oav0908[i],j2oav0909[i],j2oav0910[i],j2oav0911[i],j2oav0916[i],j2oav0917[i]])
  j2osd[i] = stddev([j2oav0908[i],j2oav0909[i],j2oav0910[i],j2oav0911[i],j2oav0916[i],j2oav0917[i]])
endfor

plot, angle, j2oav, psym=5, title = 'Average Synchronous signal of 6 days w/error bars', $
					xtitle='angle [deg]',ytitle='signal [V]',yrange=[-.001,.001],xrange=[0,360]
errplot, angle, j2oav+j2osd/2., j2oav-j2osd/2.


;-------------------------------------------------------------------------------
; j3o

plot, angle, j3oav0908, title='j3o synchronous signal, staring at sky, 6 different days', $
					    xtitle='angle [deg]', ytitle = 'signal [V]',yrange=[-0.002,0.002],xrange=[0,360]
oplot, angle, j3oav0909, color = 30
oplot, angle, j3oav0910, color = 60
oplot, angle, j3oav0911, color = 90
oplot, angle, j3oav0916, color = 120
oplot, angle, j3oav0917, color = 150

j3oav = fltarr(144)
j3osd = fltarr(144)
for i=0,143 do begin
  j3oav[i] = mean([j3oav0908[i],j3oav0909[i],j3oav0910[i],j3oav0911[i],j3oav0916[i],j3oav0917[i]])
  j3osd[i] = stddev([j3oav0908[i],j3oav0909[i],j3oav0910[i],j3oav0911[i],j3oav0916[i],j3oav0917[i]])
endfor

plot, angle, j3oav, psym=5, title = 'Average Synchronous signal of 6 days w/error bars', $
					xtitle='angle [deg]',ytitle='signal [V]',yrange=[-.001,.001],xrange=[0,360]
errplot, angle, j3oav+j3osd/2., j3oav-j3osd/2.

end