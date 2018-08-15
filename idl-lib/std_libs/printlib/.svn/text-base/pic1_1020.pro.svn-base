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
angle = findgen[144]*360./144.

;-------------------------------------------------------------------------------
; TP0

plot, angle, tp0av0908
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
  tp0av[i] = mean(tp0av0908[i],tp0av0909[i],tp0av0910[i],tp0av0911[i],tp0av0916[i],tp0av0917[i], $
  				  tp0av0922[i],tp0av0924[i],tp0av0929[i])
  tp0sd[i] = stddev(tp0av0908[i],tp0av0909[i],tp0av0910[i],tp0av0911[i],tp0av0916[i],tp0av0917[i], $
  				  tp0av0922[i],tp0av0924[i],tp0av0929[i])
endfor

ploterr, angle, tp0av, tp0sd, psym=5

end