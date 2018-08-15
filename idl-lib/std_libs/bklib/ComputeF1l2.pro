
 	function ComputeF1l2 ,lmax,z,Pl2
 f1l2 = fltarr(lmax+1)
 	sint = 1.-z^2.
 	if (abs(sint) lt 1.e-10) then begin
 	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
 	   ; **** NB:
 	   ; If pixel separation is less than about
 	   ; an arcsecond,then assume it's supposed
 	   ; to be zero and  use analytic result to
 	   ; avoid numerical problems with 0/0:
 	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
 	  for l=2, lmax-1 do F1l2(l) = 0.5

 	endif else begin
 	   for l=2l, lmax do begin
 	      aux1    = 2./(l*(l*l-1.)*(l+2.))
 	      aux2    = (l-4.)/sint + 0.5*l*(l-1.)
 	      aux3    = (l+2.)*z/sint
 	      F1l2(l) = aux1*(-aux2*Pl2(l)+aux3*Pl2(l-1))

 	   endfor
 	  endelse

 	F1l2(0) = 0.
 	F1l2(1) = 0.
 	return, F1l2
 	end
