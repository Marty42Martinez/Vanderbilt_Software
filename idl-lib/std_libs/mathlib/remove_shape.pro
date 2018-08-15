function remove_shape, y, shape

; removes the best-fit amount of "shape" from y
; returns y - alpha * shape, such that the new chi-squared is minimized

my = mean(y)
shape_ = shape - mean(shape)
y_ = y - my
alpha = total(shape_*y_)/total(shape_^2)
print, alpha
return, y - alpha * shape_

end