function chol_like, cex,cth,datavec

ctot = cth + cex
;READHEAD DATA:
;gives weak detection, max like at ~15uK
;2-sigma upper limit at ~56uK
;check paper for more precise than this

;datain = [-64.,20.,-29.,34.,-23.,-20.,-36.]
;sigexpt= [35., 34., 27.,26., 26., 32., 39.]



;alternatively:
;first, SVDC to get evals of square matrix Ctot
;then,to get det[A], use : log[det[A]] = trace[log[A]]
;where A = vector of e-vals from SVDC
;svdc,ctot,w,u,v,/double; SVD Ctot for determinant via log
;svdsol,u,w,v,datavec

;choldc to get evals is much faster, but doesn't
;work on Cex or Cth b/c they are mean-removed,
;which causes them to no longer be positive def,
;as req'd by Choldc. Their sum, Cex+Cth [still
;mean-removed, *can* be Choldc...b/c this is a
;regularized inversion

;just leave in positive offset since it reflects our
;ignorance of the mean



;CHOLDC HERE
;solve for y=dat##Ninv by solving y##N = dat for y

ct = ctot

choldc,ct,sqrtevals,/double
;why does chold, cex, give sharp boundary effects if
;the min of cex not >0?
;make ctot into lower triangle, can skip this in idl as it
;will only use the lower half in cholsol

;n is lower tri, with diagonals
;for i = 0,option*npix-1 do begin
	;for j = i,option*npix-1 do begin
	;	n[i,j] = ctot[i,j]
	;	if i EQ j then n[i,i] = (sqrtevals[i])
	;endfor
;endfor

y = cholsol(ct,sqrtevals,datavec,/double)
; cholsol doesn't work for this,
y = sqrtevals*y; need to correct for ctot being lower tri
dtminvd = y##transpose(y)

logdetsqrtm=total(alog(sqrtevals))
logl = -1.*logdetsqrtm - 0.5*dtminvd

;print, 'logdet,dtminv,logl', -1.*logdetsqrtm,- 0.5*dtminvd,logl

RETURN, logl

end

