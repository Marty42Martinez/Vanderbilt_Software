; simple test of cross-correlation btn 2 channels

cc = 0.2; cross correlation coefficient!

truemap = double([-1,1,3.]) ; begin as row vector!
npix = n_elements(truemap)
NoizA = 1.
NoizB = 1.2
N_ = [[1.,0.1,0.1],[0.1,1.,0.1],[0.1,0.1,5.]]
NA1 = N_*NoizA
NA2 = NA1*1.1
NB1 = N_* NoizB
NB2 = NB1 * 1.1

A1 = truemap + randomn(1.3,npix) ## NA1
A2 = truemap + randomn(2.7,npix) ## NA2

B1 = truemap + randomn(232.2323,npix)##NB1
B2 = truemap + randomn(-100.34,npix)##NB2

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

; Now, produce final maps and cov matrices!
N1inv =invertspd(N1,/double)
N2inv =invertspd(N2,/double)
Sinv = N1inv + N2inv
Cov = invertspd(Sinv,/double)

y = Cov ## (N1inv ## y1 + N2inv ## y2)

; now let's put these 2 final maps together with a pointing matrix!
; A will be an npix-by-2npix matrix
A = dblarr(npix,2*npix)
A[*,0:q] = identity(npix)
A[*,npix:q2] = identity(npix)

fmap = max_map(y,cov,A,fcov,/double)
end
