;  CBESELJ01, z, j0, j1, EPS=EPS

; Calculates the bessel functions J0(z) and J1(z), for complex z.

; INPUT
;   z : scalar or vector complex argument

; OUTPUTS
;	j0, j1: double-precision complex bessel functions J0(z) and J1(z)

; KEYWORDS
; 	EPS : the relative accuracy before cut-off when abs(z) < 12.
;		(default 1d-8)

; NOTES:
;	IDL's BESELJ cannot handle complex arguments.
;	This algorithm translated from the C++ algorithm:
;//  cbessjy.cpp -- complex Bessel functions.
;//  Algorithms and coefficient values from "Computation of Special
;//  Functions", Zhang and Jin, John Wiley and Sons, 1996.
;//
;//  (C) 2003, C. Bond. All rights reserved.
;//
;
; Translation by Chris O'Dell, 2003.
;
;


PRO CBESELJ01_Single, z, cj0, cj1, eps=eps

; given scalar complex argument z, return j0(z) and j1(z)

common besscommon, a, b, a1, b1, czero, cone,cii, M_PI_4, M_2_PI

    a0 = abs(z)
    z2 = z*z
    z1 = z
    if (a0 eq 0.0) then begin
        cj0 = cone
        cj1 = czero
        return
	 endif

    if (real(z) LT 0.0) then z1 = -z

    if (a0 LE 12.0) then begin
        cj0 = cone
        cr = cone
        for k = 1,40 do begin
            cr = cr * (-0.25)*z2/double(k)^2
            cj0 = cj0 + cr
            if (abs(cr) LT abs(cj0)*eps) then break
        endfor
        cj1 = cone
        cr = cone
        for k = 1,40 do begin
            cr = cr * (-0.25)*z2/(k*(k+1.0d))
            cj1 = cj1 + cr
            if (abs(cr) LT abs(cj1)*eps) then break
        endfor
        cj1 = cj1 * 0.5*z1
    endif else begin
        if (a0 GE 50.0) then kz = 8 else $
        if (a0 GE 32.0) then kz = 10 else kz = 12
        k = indgen(kz)

		  ct1 = z1 - M_PI_4
		  cp0 = cone + total(a[k]*z1^(-2*k-2.))
		  cq0 = -0.125/z1 + total(b[k]*z1^(-2*k-3.))

        cu = sqrt(M_2_PI/z1)
        cj0 = cu*(cp0*cos(ct1)-cq0*sin(ct1))

        ct2 = z1 - 0.75*!dpi
        cp1 = cone + total(a1[k]*z1^(-2*k-2.))
        cq1 = 0.375/z1 + total(b1[k]*z1^(-2*k-3.))
        cj1 = cu*(cp1*cos(ct2)-cq1*sin(ct2))
    endelse

    if (real(z) LT 0.0) then cj1 = -cj1

END



PRO CBESELJ01, z, j0, j1, EPS=EPS


j1 = z * 0.
j0 = z * 0.

if n_elements(eps) eq 0 then eps = 1d-8

common besscommon, a, b, a1, b1, czero, cone, cii, M_PI_4, M_2_PI

czero = complex(0,0)
cone = complex(1.0d,0.)
cii = complex(0.d,1.0d)
M_PI_4 = 0.78539816339744830962d
M_2_PI = 0.63661977236758134308d

    a = [-7.03125d-2, $
         0.112152099609375d,$
        -0.5725014209747314d,$
         6.074042001273483d,$
        -1.100171402692467d2,$
         3.038090510922384d3,$
        -1.188384262567832d5,$
         6.252951493434797d6,$
        -4.259392165047669d8,$
         3.646840080706556d10,$
        -3.833534661393944d12,$
         4.854014686852901d14,$
        -7.286857349377656d16,$
         1.279721941975975d19 ]

    b = [7.32421875d-2, $
        -0.2271080017089844d, $
         1.727727502584457d, $
        -2.438052969955606d1, $
         5.513358961220206d2, $
        -1.825775547429318d4, $
         8.328593040162893d5, $
        -5.006958953198893d7, $
         3.836255180230433d9, $
        -3.649010818849833d11, $
         4.218971570284096d13, $
        -5.827244631566907d15, $
         9.476288099260110d17, $
        -1.792162323051699d20]


    a1 = [0.1171875d, $
        -0.1441955566406250d, $
         0.6765925884246826d, $
        -6.883914268109947d, $
         1.215978918765359d2, $
        -3.302272294480852d3, $
         1.276412726461746d5, $
        -6.656367718817688d6, $
         4.502786003050393d8, $
        -3.833857520742790d10, $
         4.011838599133198d12, $
        -5.060568503314727d14, $
         7.572616461117958d16, $
        -1.326257285320556d19]

    b1 = [ -0.1025390625d, $
         0.2775764465332031, $
        -1.993531733751297, $
         2.724882731126854d1, $
        -6.038440767050702d2, $
         1.971837591223663d4, $
        -8.902978767070678d5, $
         5.310411010968522d7, $
        -4.043620325107754d9, $
         3.827011346598605d11, $
        -4.406481417852278d13, $
         6.065091351222699d15, $
        -9.833883876590679d17, $
         1.855045211579828d20]

for i = 0L, n_elements(z) - 1 do begin
	CBESELJ01_SINGLE, z[i], j0_i,j1_i, eps=eps
	j0[i] = j0_i
	j1[i] = j1_i
endfor

END