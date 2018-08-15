PRO co_moments, x, std, n, x_out, std_out, n_out

; This program finds the mean & standard deviation of a dataset,
; when all that is known is the mean and standard deviations of subcomponents
; of that data set; the original points are not in general known.
; Thus, x, std, and n are arrays, each element of which corresponds to the mean, standard
; deviation, and number of elements of a particular subcomponent of the data.

; Note: This is the formal standard deviation, which is the version with the (N-1) in the denominator:
;	    sqrt( (Sum{i=1,N} (x_i - xbar)^2 ) / (N-1) )

; INPUTS:
;	x 		: 	array of mean values
; 	std		:	array of standard deviations
;	n		: 	array of number of points in each bin (or subcomponent)

; OUTPUTS
;	x_out 	: the mean of the overall data set
;	std_out	: the standard deviation of the overall data set
;	n_out	: the number of elements in the overall data set

x_out = x[0]
n_out = n[0]
std_out= std[0] * std[0] * (n_out - 1.)

for i = 1, n_elements(x)-1 do begin
	Ntot = n_out + n[i]
	std_out = std_out +  (n[i]-1.)*std[i]*std[i] + n_out*n[i]/float(Ntot) * (x_out-x[i])^2
	x_out = (n_out * x_out + n[i]*x[i])/Ntot
	N_out = Ntot
endfor

std_out = sqrt(std_out/(n_out-1.))

END

