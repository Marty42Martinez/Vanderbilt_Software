FUNCTION Getrange, data, pad=pad

if n_elements(pad) eq 0 then pad = 0.1

ymax = max(data)
ymin = min(data)
span = ymax-ymin
ymax = ymax + span*pad
ymin = ymin - span*pad
return, [ymin,ymax]

END