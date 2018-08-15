pro prewhite, datain, covmtrx,pwfilt, cvf = cvf

;this pro takes in a data stream, and forms its
;pre-whitened filter

nel = N_ELEMENTS(datain)

;lag = indgen(nel)

if n_elements(cvf) eq 0 then cvf = covar(datain, /expand)

;form the covar matrix above the diagonal

covmtrx = form_N(cvf, nel)

choldc,covmtrx,p,/double; take the sqrt of the cov matrx. Note,
;this returns the sqrt in the lower half of orignal matrix
;and diag elements in p
;see IDL help on choldc

L =
for i = 0,nel-1 do covmtrx[i,i] = p[i]
pwfilt = invertspd(covmtrx); inverse of sqrt-covmtrx.
pwfilt = pwfilt + transpose(pwfilt)
pwfilt = pwfilt/max(pwfilt);normalize it
;if original timestream is 't' [which is
;contaminated by 1/f, then pwfilt##t is white
end