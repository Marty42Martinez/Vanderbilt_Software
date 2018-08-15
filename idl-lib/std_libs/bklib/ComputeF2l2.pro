
 	function ComputeF2l2, lmax,z,Pl2
 f2l2 = fltarr(lmax+1)
 	sint = 1.-z^2.
 	if (abs(sint) lt 1.e-10) then begin
 	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
 	   ; **** NB:
 	   ; If pixel separation is less than about
 	   ; an arcsecond,then assume it's supposed
 	   ; to be zero and  use analytic result to
 	   ; avoid numerical problems with 0/0:
 	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
 	   for l=2l, lmax do begin
 	      F2l2(l) = -0.5
 	      F2l2(l) =  0.5*((l-2.)/z-(l+1.)*z)*z^l
 	   endfor
    endif else begin
 	  for  l=2l, lmax do begin
 	     aux1    = 4./(l*(l^2.-1.)*(l+2.)*sint)
 	      aux2    = (l-1.)*z
 	      aux3    = (l+2.)
 	      F2l2(l) = aux1*(-aux2*Pl2(l)+aux3*Pl2(l-1))

 	   endfor
 	endelse
 	F2l2(0) = 0.
 	F2l2(1) = 0.
 	return, F2l2
 	end


