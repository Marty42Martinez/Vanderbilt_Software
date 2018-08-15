; simple test of cross-correlation btn 2 channels

cc = 0.2; cross correlation coefficient!

oA1 = 3.
oB1 = 3.5
oA2 = -6.
oB2 = -7.

truemap = double([-1,1.,3.]) ; begin as row vector!
npix = n_elements(truemap)
Ip = Identity(npix,/double)
NoizA = 1.
NoizB = 1.2
N_ = [[1.,0,0],[0,1.,0.],[0.,0.,5.]]
NA1 = N_*NoizA
NA2 = NA1*1.1
NB1 = N_* NoizB
NB2 = NB1 * 1.1

A1 = truemap + randomn(1.3,npix) ## NA1 + oA1
A2 = truemap + randomn(2.7,npix) ## NA2 + oA2

B1 = truemap + randomn(232.2323,npix)##NB1 + oB1
B2 = truemap + randomn(-100.34,npix)##NB2 + oB2

y1 = transpose([A1,B1])
y2 = transpose([A2,B2])
; now, combine the channels within each night

N1 = dblarr(2*npix,2*npix) ; the 2 is the # of channels
N2 = N1

off1 = cc*Msqrt(NA1##NB1)
off2 = cc*Msqrt(NA2##NB2)

q = npix-1
q2 = 2*npix-1
N1[0:q,0:q] = NA1
N1[0:q,npix:q2] = off1
N1[npix:q2,0:q] = off1
N1[npix:q2,npix:q2] = NB1

N2[0:q,0:q] = NA2
N2[0:q,npix:q2] = off2
N2[npix:q2,0:q] = off2
N2[npix:q2,npix:q2] = NB2
;***********************************************************************
; now, i must do the de-offsetting.

;FULL METHOD
Zt = fltarr(npix) + 1.
Z = transpose(Zt)
A = [[Z,Z*0],[0*Z,Z]]
At = transpose(A)
W1 = invertspd(At ## invertspd(N1) ## A) ## At ## invertspd(N1)
W2 = invertspd(At ## invertspd(N2) ## A) ## At ## invertspd(N2)
Pi1 = Identity(2*npix) - A ## W1
Pi2 = Identity(2*npix) - A ## W2

o1 = W1 ## y1  ; best guess at offsets for each channel for night 1
o2 = W2 ## y2  ; same but night 2
y1_ = Pi1 ## y1 ; de-offset data for night 1
y2_ = Pi2 ## y2 ; de-offset data for night 2


;****************************************************************************
; Now, produce final maps and cov matrices! (retaining each channel)
N1inv =invertspd(N1,/double) ## PI1 ;pseudo-inverse of N1_
N2inv =invertspd(N2,/double) ## PI2 ;same for N2_
Sinv = N1inv + N2inv ; this is SinvSum in addmaps5 code
; Construct final covariance correctly
		eta = 0.1
		Z2t = dblarr(2*npix) + 1.
		Z2 = transpose(Z2t)
		Wm = 1./(Z2t ## Sinv ## Z2) ## Z2t ## Sinv
		QQt = 1. /(2.*npix)* Z2 ## Z2t
;		QQt = Z2 ## Wm
		PIeff = identity(2*npix) - QQt
		sigma = invertspd(Sinv +eta*QQt,/double)
 		sigma = PIeff ## sigma ## transpose(PIeff)


y = sigma ## (N1inv ## y1_ + N2inv ## y2_)

;******************************************************************************
; now let's put these 2 final maps together with a pointing matrix!
; A will be an npix-by-2npix matrix
Af = dblarr(npix,2*npix)
Af[*,0:q] = identity(npix)
Af[*,npix:q2] = identity(npix)

;fmap = max_map(y,sigma,Af,fcov,/double)
end
