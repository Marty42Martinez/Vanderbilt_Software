function crop, data, crop_percent

; Cuts of first and last crop_percent of 1D data array

n = n_elements(data)
first = round(n*crop_percent/100.)
last = n-1-first

return, data(first:last)

end