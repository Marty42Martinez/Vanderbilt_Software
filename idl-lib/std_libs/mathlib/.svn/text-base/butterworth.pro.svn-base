function butterworth, f

k = 1.586
r = 1.0e4
c = 7.958e-9

a = k * (1-f^2 * c^2 * r^2)/ ( (f*c*R)^4 + 1 + (f*c*R)^2 * ((k-3)^2-2) )
b = f*c*r*k*(k-3)/((f*c*R)^4 + 1 + (f*c*R)^2 * ((k-3)^2-2) )

return, complex(a,b)

END