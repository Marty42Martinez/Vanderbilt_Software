PRO eplot2, x, down, up, color=color, ecolor=ecolor, ethick=thick,  width=width


oldc = !p.color
if keyword_set(color) then !p.color = color
if keyword_set(ecolor) then !p.color = ecolor

errplot, x, down, up, width=width, th = thick

!p.color = oldc

END