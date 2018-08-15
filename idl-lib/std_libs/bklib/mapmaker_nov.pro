pro mapmaker_nov

;follow method of wright '96

;takes in a (post-cut) data set of j1-3, q,u
;pre-whitens data in each chan, for each stokes
;makes pointing matrix
;makes noise covar matrix
;makes min-var map
restore,'d:\brian\data\polar_2000\full_set\allsections.var'
j1iq = bigstokes.j1i.c2
jdr = bigjdr[6000:7000]
j1iq = j1iq[6000:7000]
p = pointingmatrix(jdr)
pt = transpose(p)
prewhite, j1iq,cv,pw
a = pt##(pw##p)
b = pt##(pw##j1iq)

t = invert(a)##b

end
