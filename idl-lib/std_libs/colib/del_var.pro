PRO del_var, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10

; Delete up to 10 variables

	if n_elements(x1) GT 0 then dummy = temporary(x1)
	if n_elements(x2) GT 0 then dummy = temporary(x2)
	if n_elements(x3) GT 0 then dummy = temporary(x3)
	if n_elements(x4) GT 0 then dummy = temporary(x4)
	if n_elements(x5) GT 0 then dummy = temporary(x5)
	if n_elements(x6) GT 0 then dummy = temporary(x6)
	if n_elements(x7) GT 0 then dummy = temporary(x7)
	if n_elements(x8) GT 0 then dummy = temporary(x8)
	if n_elements(x9) GT 0 then dummy = temporary(x9)
	if n_elements(x10) GT 0 then dummy = temporary(x10)

END
