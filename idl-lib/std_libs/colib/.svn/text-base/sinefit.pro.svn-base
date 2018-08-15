function sinefit, x, y, A, verbose=verbose

; Attempts to fit a sine wave to data x,y

; FIT FORM
; y = A[0] * sin(A[1]*x + A[2]) + A[3]


; x should be evenly spaced and sorted
; Y should really have only one major sine component for
; this to be a reasonable fit, and actually find the global minimum
; to the chi squared.


dx = mean(x[1:*] - x[0:*]) ; mean spacing
A3 = mean(y)

ymod = y - A3 ; remove offset

copsd, y-A3, samp=1/dx, psd, f, /nograph

v = keyword_set(verbose)

w = where(psd eq max(psd))
ny = n_elements(y)

; try 100 different phases
Nphi = 100
phi = findgen(Nphi)/Nphi * 2 * !pi

chi = fltarr(Nphi)
A0 = psd[w[0]]/2. ; the guess of the amplitude
A1 = f[w[0]]*2*!pi ; the guess of the frequency in radians/sec
ymod = ymod / A0
for i =0,Nphi-1 do chi[i] = total((sin(A1*x+phi[i]) - ymod)^2)/ny

wphi = where(chi eq min(chi))
A2 = phi[wphi[0]]

A = [1,A1,A2,0.]
if v then print, 'Initial A = ', [A0,A1,A2,A3]
chi0 = chi[wphi[0]]
if v then print, 'Initial rel Chi^2 = ', chi0
yfit = curvefit(x,ymod,x*0+1,A, function_name='sinefunc', iter=iter)
chif = total((yfit-ymod)^2)/ny
A = [A0*A[0],A[1], A[2], A0*A[3] + A3]
if v then print, 'Final A = ', A
if v then print, 'Final rel Chi^2 = ', chif, ' in ', iter, ' iterations.'

yfit = yfit*A0 + A3

return, yfit

end