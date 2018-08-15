  function computeF1l0, lmax,z,Pl0
 	;implicit none ! zzz
 	;integer  l, lmax
 	;real     z, sint, aux1, aux2, aux3
 	;real     Pl0(0:lmax), F1l0(0:lmax)
F1l0 = fltarr(lmax+1)
 	sint = 1.-z^2.
 	if (abs(sint) lt 1.e-10) then begin
 	   ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 	   ;! **** NB:
 	   ;! If pixel separation is less than about
 	   ;! an arcsecond,then assume it's supposed
 	   ;! to be zero and  use analytic result to
 	   ;! avoid numerical problems with 0/0:
 	   ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 	   for l=2l, lmax do F1l0(l) = 0.

 	endif else begin
 	   for l=2l, lmax do begin
 	      aux1    = 2./sqrt(l*(l^2.-1.)*(l+2.))
 	      aux2    = l/sint + 0.5*l*(l-1.)
 	      aux3    = l*z/sint
 	      F1l0(l) = aux1*(-aux2*Pl0(l)+aux3*Pl0(l-1.))
 	   endfor
 	endelse
 	F1l0(0) = 0.
 	F1l0(1) = 0.
 	return, F1l0
 	end