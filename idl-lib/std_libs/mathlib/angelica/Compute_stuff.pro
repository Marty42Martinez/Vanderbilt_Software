pro ComputePl0, lmax,z,Pl0
; Computes P_l(z) for all l=0,1,2,...,lmax.
;	implicit none
;        integer  lmax, l
;        real     z, Pl0(0:lmax)
	if (size(z))[1] eq 5 then Pl0 = dblarr(lmax+1) else Pl0 = fltarr(lmax+1)
	Pl0(0) = 1
	Pl0(1) = z
	; this for loop is required as it is recursive
    for l=2, lmax do begin
           Pl0(l)= ((2.*l-1.)*z*Pl0(l-1)-(l-1.)*Pl0(l-2.))/l
    endfor
end

pro ComputePl2,lmax,z,Pl2
; Computes P_lm(z) for m=2 and all
; l=0,1,2,...,lmax.

    if (size(z))[1] eq 5 then Pl2 = dblarr(lmax+1) else Pl2 = fltarr(lmax+1)

	Pl2(0) = 0.
	Pl2(1) = 0.
	Pl2(2) = 3.*(1.-z^2)
	Pl2(3) = 5.*z*Pl2(2)
    for l=4, lmax do begin
        Pl2(l)= ((2.*l-1.)*z*Pl2(l-1)-(l+1.)*Pl2(l-2))/(l-2.)
    endfor

end

pro ComputeF1l2, lmax,z,Pl2,F1l2
;	implicit none;
;	integer  l, lmax
;	real     z, sint, aux1, aux2, aux3
;	real     Pl2(0:lmax), F1l2(0:lmax)
	if (size(z))[1] eq 5 then F1l2 = dblarr(lmax+1) else F1l2 = fltarr(lmax+1)
	sint = 1-z^2
	if (abs(sint) lt 1.e-10) then $
	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	   ; **** NB:
	   ; If pixel separation is less than about
	   ; an arcsecond,then assume it's supposed
	   ; to be zero and  use analytic result to
	   ; avoid numerical problems with 0/0:
	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	   F1l2(2:lmax) = 0.5 $
	else begin
	   l = indgen(lmax-1) + 2
	   aux1    = 2./(l*(l*l-1.)*(l+2.))
	   aux2    = (l-4.)/sint + 0.5*l*(l-1.)
	   aux3    = (l+2.)*z/sint
	   F1l2[l] = aux1*(-aux2*Pl2[l]+aux3*Pl2[l-1])
	endelse
end

pro ComputeF2l2, lmax,z,Pl2,F2l2
;	implicit none
;	integer  l, lmax
;	real     z, sint, aux1, aux2, aux3
;	real     Pl2(0:lmax), F2l2(0:lmax)
	if (size(z))[1] eq 5 then F2l2 = dblarr(lmax+1) else F2l2 = fltarr(lmax+1)
	sint = 1-z^2
	if (abs(sint) lt 1.e-10) then $
	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	   ; **** NB:
	   ; If pixel separation is less than about
	   ; an arcsecond,then assume it's supposed
	   ; to be zero and  use analytic result to
	   ; avoid numerical problems with 0/0:
	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	   F2l2(2:lmax) = -0.5 $
;	      F2l2(l) =  0.5*((l-2.)/z-(l+1.)*z)*z**l $
	else begin
	   l = indgen(lmax-1) + 2
	   aux1    = 4./(l*(l^2-1.)*(l+2.)*sint)
	   aux2    = (l-1.)*z
	   aux3    = (l+2.)
	   F2l2[l] = aux1*(-aux2*Pl2[l]+aux3*Pl2[l-1])
	endelse
end

pro ComputeF1l0,lmax,z,Pl0,F1l0
;implicit none ; zzz
;integer  l, lmax
;real     z, sint, aux1, aux2, aux3
;real     Pl0(0:lmax), F1l0(0:lmax)
   if (size(z))[1] eq 5 then F1l0 = dblarr(lmax+1) else F1l0 = fltarr(lmax+1)
	sint = 1-z^2
	if (abs(sint) lt 1.e-10) then $
	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	   ; **** NB:
	   ; If pixel separation is less than about
	   ; an arcsecond,then assume it's supposed
	   ; to be zero and  use analytic result to
	   ; avoid numerical problems with 0/0:
	   ;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	   F1l0[2:lmax] = 0. $
	else begin
		l = indgen(lmax-1)+2
	    aux1    = 2./sqrt(l*(l^2-1.)*(l+2.))
	    aux2    = l/sint + 0.5*l*(l-1.)
        aux3    = l*z/sint
	    F1l0[l] = aux1*(-aux2*Pl0[l]+aux3*Pl0[l-1])
	endelse
end

pro ComputeTT, lmax,Pl0,C,sum
;	implicit none
;	integer  l, lmax
;	real     Pl0(0:lmax)
;	real     C  (0:lmax)
;	real     pi, aux, sum
	l = findgen(lmax-1) + 2 ; array from 2 to lmax
	sum= total((2.*l+1)/(4*!pi)  * C[l] * Pl0[l])
end

pro ComputeQQ, lmax,F1l2,F2l2,E,B,sum
;	implicit none
;	integer  l, lmax
;	real     F1l2(0:lmax), F2l2(0:lmax)
;	real     E   (0:lmax), B   (0:lmax)
;	real     pi, aux, sum
 ;       pi = 4.*atan(1.)
;	sum= 0.
	l = findgen(lmax-1)+2 ; array from 2 to lmax
	sum = total((2.*l+1)/(4*!pi) * (E * F1l2 - B *F2l2) )
end

pro ComputeUU, lmax,F1l2,F2l2,E,B,sum
;	implicit none
;	integer  l, lmax
;	real     F1l2(0:lmax), F2l2(0:lmax)
;	real     E   (0:lmax), B   (0:lmax)
;	real     pi, aux, sum

	l = findgen(lmax-1)+2 ; array from 2 to lmax
	sum = total((2.*l+1)/(4*!pi) * (B * F1l2 - E*F2l2) )
end

pro ComputeTQ, lmax,F1l0,X,sum
;	implicit none
;	integer  l, lmax
;	real     F1l0(0:lmax)
;	real     X   (0:lmax)
;	real     pi, aux, sum
;        pi = 4.*atan(1.)
	l = findgen(lmax-2)+1 ; array from 2 to lmax
	sum = total((2.*l+1)/(4*!pi) * X * F1l0)
end