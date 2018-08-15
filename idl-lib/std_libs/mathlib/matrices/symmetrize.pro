function symmetrize, M

; if M is nearly symmetric, this function returns a fully symmetric M
; averages are used.

return, 0.5 * (M + transpose(M))

end