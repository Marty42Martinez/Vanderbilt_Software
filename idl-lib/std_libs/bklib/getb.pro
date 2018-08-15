function GetB, lmax
 ;	implicit none
; 	integer  np, n, lmax, i, l
 ;	real     FWHM(np)
 ;	real     B   (np,0:lmax), pi, theta
lmax = float(lmax)
b = fltarr(lmax+1)

 	pi = 4.*atan(1.)
 	fwhm = 7.0;0./60.

 	   theta = FWHM*(pi/(180.))/sqrt(8.*alog(2.))
for l = 0,lmax do B(l) = exp(-0.5*l*(l+1.)*theta^2.)

 	 	return,b
 	end
