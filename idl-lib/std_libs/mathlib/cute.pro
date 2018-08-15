function cute, n, t, f, mils = mils, Ghz = Ghz

if n_elements(f) eq 0 then f = 3.0e10 ;[Hz]

if keyword_set(GHz) then f = f * 1e9
c = 3e8 ; [m/s]

if keyword_set(mils) then t = 2.54e-5*t ; convert from mils to meters

return, (!pi*f*t/c)^2 * (n^4-1)*(n^2-1)*(3*n^2-1)/(2*n^4)

END
