function stddev_with_err, y, err

; y : array of points
; err : associated 1-sigma errors on each y

; use a monte-carlo with to estimate the actual stddev of y,
; taking into account how much y can possibly vary.
; In reality, we'll get a distribution of sigmas.
; take the mean and variance of this sigma.


N = 20000 ; do N simulations
Ny = n_elements(y)
yy = fltarr(Ny, N)

for i = 0, Ny-1 do yy[i,*] = (randomn(seed, N)*err[i] + y[i])

ybar = total(yy, 1) / Ny
y2bar = total(yy*yy,1)/Ny
std = sqrt(Ny/(Ny-1.)*(y2bar -ybar*ybar))

!p.multi= [0,1,2]
eoplot, findgen(ny), y, err
hist, yy, /fit, /text, nbin=50, /int
stdy = stddev(y)
print, 'Normal Std = ' + num2str(stdy)

return, mean(std)

END