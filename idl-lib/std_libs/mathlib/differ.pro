function differ, x1, x2, f=f

if n_elements(f) eq 0 then f=0.1

w = where( abs((x1-x2)/(0.5 * (x1+x2))) ge f )

return, w

end