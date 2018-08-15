; program to test co_moments2

N = 53106
in1 = randomn(seed, N, /double)
in2 = randomn(seed, N, /double)
in3 = randomn(seed, N, /double)

in2 = in1 * 0.5 + in2 * 0.5
in3 = in1*0.5 + in2*0.5 + in3*0.4

covar = dblarr(3,3)
covar[*,0] = [correlate(in1,in1,/covar), correlate(in1,in2,/covar), correlate(in1,in3,/covar)]
covar[0,1] = covar[1,0]
covar[0,2] = covar[2,0]
covar[1,1] = correlate(in2,in2,/covar)
covar[2,2] = correlate(in3,in3,/covar)
covar[1,2] = correlate(in2,in3,/covar)
covar[2,1] = covar[1,2]

ctrue = covar
mtrue = [mean(in1), mean(in2), mean(in3)]

; now do it the other way
div = [0, 500, 12000, 15000, 37000, 37002, N]
Nset = n_elements(div)-1

mn = dblarr(3,Nset)
acovar = dblarr(3,3,Nset)
npoints = lonarr(nset)
for i =0, Nset-1 do begin
	a = div[i]
	b = div[i+1]-1

	i1 = in1[a:b]
	i2 = in2[a:b]
	i3 = in3[a:b]
	mn[*,i] = [mean(i1), mean(i2), mean(i3)]

	covar = dblarr(3,3)
	covar[*,0] = [correlate(i1,i1,/covar), correlate(i1,i2,/covar), correlate(i1,i3,/covar)]
	covar[0,1] = covar[1,0]
	covar[0,2] = covar[2,0]
	covar[1,1] = correlate(i2,i2,/covar)
	covar[2,2] = correlate(i3,i3,/covar)
	covar[1,2] = correlate(i2,i3,/covar)
	covar[2,1] = covar[1,2]
	acovar[*,*,i] = covar
	npoints[i] = b-a+1
endfor

co_moments2, mn, acovar, npoints, mtest, ctest, ntest

print, mtrue
print, mtest
print
print, ctrue
print, ctest

print
print, n
print, ntest

end