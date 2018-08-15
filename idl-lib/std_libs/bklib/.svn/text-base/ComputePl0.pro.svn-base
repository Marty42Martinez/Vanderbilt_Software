   function ComputePl0 ,lmax,z
 	; Computes P_l(z) for all l=0,1,2,...,lmax.
Pl0= fltarr(lmax+1)
 	Pl0(0) = 1.
 	Pl0(1) = z
 for l=2l, lmax do $
 Pl0(l)=((2.*l-1.)*z*Pl0(l-1)-(l-1.)*Pl0(l-2.))/l

 	return, Pl0
   	end

