function rcsprob, rcs_, df

; rcs_ : reduced chi-squared
; df : degrees of freedom

; returns the probability of getting rcs > rcs given df # of dofs.

return, 1. - chisqr_pdf(rcs_*df, df)

end