function co_convol, x, filter

; filter is a one-sided filter, but this assumes time-symmetry so I figure that out.
Nf = n_elements(filter)

K = [reverse(filter),filter[1:*]]

return, convol(x,K, /edge_wrap)

end