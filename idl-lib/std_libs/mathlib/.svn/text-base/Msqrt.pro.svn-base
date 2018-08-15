function Msqrt, A, _extra = _extra

; Produces the sqrt of a real, symmetric NxN matrix A

evals = eigenQL(A, eigenvec = S, _extra=_extra)

return, transpose(S) ## (diag(sqrt(evals)) ## S)

end