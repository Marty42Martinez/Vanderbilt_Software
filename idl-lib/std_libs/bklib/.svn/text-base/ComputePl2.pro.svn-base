   function ComputePl2, lmax,z
 ;	! Computes P_lm(z) for m=2 and all
; 	! l=0,1,2,...,lmax.
 ;implicit none
  ;        integer  lmax, l
   ;       real     z, Pl2(0:lmax)

Pl2 = fltarr(lmax+1.)
 	Pl2(0) = 0.
 	Pl2(1) = 0.
 	Pl2(2) = 3.*(1.-z^2.)
 	Pl2(3) = 5.*z*Pl2(2)
    for l=4l, lmax do $
   Pl2(l)=((2.*l-1.)*z*Pl2(l-1)-(l+1.)*Pl2(l-2))/(l-2.)

 	return, Pl2
   	end
