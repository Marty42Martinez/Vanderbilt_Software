function quadratic_formula, a, b, c

; given a x^2 + b x + c = 0, determine x (two possibilities)

x = (-b + [1,-1] * sqrt(b^2 - 4 * a * c)) / (2 * a)

return, x

end