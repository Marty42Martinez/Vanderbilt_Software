FUNCTION SDM, x

; x is a data array.  SDM computes the "standard deviation of the mean".
; This is simply stddev(x)/sqrt(N-1), where N is the number of elements in x.

return, stddev(x)/sqrt(n_elements(x)-1)

END