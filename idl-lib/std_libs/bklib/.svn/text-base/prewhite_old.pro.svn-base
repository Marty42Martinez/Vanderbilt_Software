function pwfilter,datain,covmtrx

;this pro takes in a data stream, and forms its
;pre-whitened filter

nel = N_ELEMENTS(datain)

;lag = indgen(nel)
spectraplot, datain,nel, 1,F,sqrtpsd
cvfcn = float(fft(sqrtpsd^2,/inverse))

;covmatrx = form_N(cvfcn, nel)

covmtrx = fltarr(nel,nel)

;form the covar matrix above the diagonal


for i = 0, nel-1 do begin
covmtrx[i:nel-1,i] = cvfcn[0:nel-1-i]

endfor
ct = transpose(covmtrx); upper triangle of cov mat
covmtrx = ct+covmtrx; full cov mtrx



choldc,covmtrx,p,/double; take the sqrt of the cov matrx. Note,
;this returns the sqrt in the lower half of orignal matrix
;and diag elements in p
;see IDL help on choldc


for i = 0,nel-1 do covmtrx[i,i] = covmtrx[i,i]  + p[i]
pwfilt = invertspd(covmtrx); inverse of sqrt-covmtrx.
pwfilt = pwfilt + transpose(pwfilt)
pwfilt = pwfilt/max(pwfilt);normalize it
return, pwfilt
;if original timestream is 't' [which is
;contaminated by 1/f, then pwfilt##t is white
end