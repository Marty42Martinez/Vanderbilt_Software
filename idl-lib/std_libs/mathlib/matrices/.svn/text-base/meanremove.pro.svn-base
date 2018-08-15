function meanremove, x, xsigma, covar

N = n_elements(x)

D = identity(N) - (fltarr(N,N)+1.)/N

covar = D ## (xsigma ## D)

return, x - mean(x)

end