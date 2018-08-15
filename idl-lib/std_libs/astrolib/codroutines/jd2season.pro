function jd2season, jd

; takes julian dates and returns the seasons they are in:

; Dec 1 thru Feb 29 : Season 0  DJF
; Mar 1 thru May 29 : Season 1  MAM
; June 1 thru Aug 31 : Season 2 JJA
; Sep 1 thru Nov 31 : Season 3 SON

; input : jd : double of julian date, scalar or vector

; return val: season # 0-3, scalar or vector

; will get leap years slightly wrong

daycnv, jd, yr, mn, day, hr

season = (mn / 3) mod 4

return, season

END
