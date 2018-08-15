function Msqrt, A, _extra = _extra

; Produces the sqrt of a real, symmetric NxN matrix A
A_ = symmetrize(A)
evals = eigenQL(A_, eigenvec = S, _extra=_extra)

return, transpose(S) ## (diag(sqrt(evals)) ## S)

end