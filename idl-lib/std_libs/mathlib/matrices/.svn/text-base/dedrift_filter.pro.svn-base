; program to construct dedrifting filter matrix!

function dedrift_filter, y

N = n_elements(y)

I0 = fltarr(N,N) +1.  ; matrix of 1's

fi = findgen(N)

I1 = cmreplicate(fi,N) ; matrix of linear rows

I = Identity(N)

const = + 1./N * I0
linear = + 1./((2*N-1)*(N/6.)*(N-1)) * I1

D0 = (I - const)
D1 = (I - linear)
D = D1 ## D0
return, D

end