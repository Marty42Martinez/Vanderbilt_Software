function co_int2D, Z, x, y

; Z:	the 2D tabulated values to be integrated; Z=Z(x,y)
; x: 	the 1D list of x-values
; y: 	the 1D list of y-values


; the x's and y's MUST be equally spaced.  I use a newton-coates formula.

nx = n_elements(x)
x0 = 0
xF = nx-1
xo = indgen((nx+1)/2-1)*2 + 1
xe = indgen(nx/2-1)*2 + 2

ny = n_elements(y)
y0 = 0
yF = ny-1
yo = indgen((ny+1)/2-1)*2 + 1
ye = indgen(ny/2-1)*2 +2

h = double(x[1] - x[0])  ; x spacing
k = double(y[1] - y[0])	 ; y spacing

term1 = Z[x0,y0] + 2*total(Z[xe,y0]) + 4*total(Z[xo,y0]) + Z[xF,y0]
term4 = Z[x0,yF] + 2*total(Z[xe,yF]) + 4*total(Z[xo,yF]) + Z[xF,yF]

;double sum terms:
term2a = 0
for j = 0,n_elements(ye)-1 do term2a = term2a + total(Z[xe,ye[j]])
term2b = 0
for j = 0,n_elements(ye)-1 do term2b = term2b + total(Z[xo,ye[j]])
term3a = 0
term3b = 0
for j = 0,n_elements(yo)-1 do term3a = term3a + total(Z[xe,yo[j]])
for j = 0,n_elements(yo)-1 do term3b = term3b + total(Z[xo,yo[j]])

term2 = total(Z[x0,ye]) + 2*term2a + 4*term2b + total(Z[xF,ye])
term3 = total(Z[x0,yo]) + 2*term3a + 4*term3b + total(Z[xF,yo])

I = h*k/9.*( term1 + 2*term2 + 4*term3 + term4 )

return, I

END