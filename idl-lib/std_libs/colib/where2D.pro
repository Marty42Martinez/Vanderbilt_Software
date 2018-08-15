function where2D, expression

; 2d version of IDL's where function.
; expression : 2D array of 1s and 0s
; return value : the (x,y) locations of where expression EQ 1

Ncols = n_elements(expression[*,0])
w = where(expression)

j = w / Ncols

i = w mod Ncols

out = bytarr(n_elements(w),2)  ; list of coordinate pairs
out[*,0] = i  ; column #
out[*,1] = j  ; rol #

return, out

end

