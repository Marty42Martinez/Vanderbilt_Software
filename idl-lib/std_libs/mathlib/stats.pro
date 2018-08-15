pro stats, x

if n_elements(x) eq 0 then begin
  print, 'No variable sent to STATS!'
  return
endif
print, 'Min = ', min(x)
print, 'Max = ', max(x)
print, 'Mean = ', mean(x)
print, 'Std = ', stddev(x)
w = where( x LT 0., nl, ncomp = ng)
w = where( x EQ 0, n0)
nl = long(nl)
ng = long(ng)
n0 = long(n0)

ng = ng - n0
n = nl + ng + n0 + 0.
pl = nl / n * 100.
pg = ng / n * 100.
p0 = n0 / n * 100.
print, '# < 0 : ' + string(nl) + '  (' + string(pl,form='(f6.2)')+'%)'
print,  '# = 0 : ' + string(n0) + '  (' + string(p0,form='(f6.2)')+'%)'
print,  '# > 0 : ' + string(ng) + '  (' + string(pg,form='(f6.2)')+'%)'

END