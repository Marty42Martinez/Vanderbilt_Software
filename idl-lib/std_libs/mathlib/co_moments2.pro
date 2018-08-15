PRO co_moments2, x, cov, n, x_out, cov_out, n_out, missing=missing

; This program finds the mean & standard deviation of a dataset,
; when all that is known is the mean and standard deviations of subcomponents
; of that data set; the original points are not in general known.
; Thus, x, std, and n are arrays, each element of which corresponds to the mean, standard
; deviation, and number of elements of a particular subcomponent of the data.

; Note: This is the formal standard deviation, which is the version with the (N-1) in the denominator:
;	    sqrt( (Sum{i=1,N} (x_i - xbar)^2 ) / (N-1) )

; INPUTS:
;	x 		: 	Matrix of Mean Values (Nchan, Nset)
;   cov		:	array of covariance matrices (Nchan,Nchan,Nset)
;	n		: 	array of number of points in each set (Nset)

; OUTPUTS
;	x_out 	: the mean of the overall data set (Nchan)
;	cov_out	: the covariance matrix of the overall data set (Nchan,Nchan)
;	n_out	: the number of elements in the overall data set (scalar)

if n_elements(missing) eq 0 then missing = -999.0
Nset = n_elements(n)

x_out = x[*,0]
n_out = n[0]
cov_out= cov[*,*,0] * (n_out - 1.)
if n_out eq 0 then begin
  x_out = x_out * 0.0 + missing
  cov_out = cov_out * 0.0 + missing
endif
for k = 1, Nset-1 do begin
	Ntot = n_out + n[k]
	if n[k] eq 0 then continue
        delta = x_out - x[*,k] ; difference between mean values for all channels
	dd = delta # transpose (delta)
	cov_out = cov_out + (n[k]-1.) * cov[*,*,k] + (n_out/float(Ntot)) * n[k] * dd
	x_out = (n_out * x_out + n[k]*x[*,k])/Ntot
	N_out = Ntot
endfor

if n_out NE 0 then cov_out = cov_out/(n_out-1.)

END
